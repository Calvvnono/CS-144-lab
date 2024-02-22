#include "tcp_sender.hh"
#include "tcp_config.hh"

#include <random>

using namespace std;

/* TCPSender constructor (uses a random ISN if none given) */
TCPSender::TCPSender( uint64_t initial_RTO_ms, optional<Wrap32> fixed_isn )
  : isn( fixed_isn.value_or( Wrap32 { random_device()() } ) )
  , _isSent_ISN( 0 )
  , _isSent_FIN( 0 )
  , initial_RTO( initial_RTO_ms )
  , cur_RTO( initial_RTO_ms )
  , isStartTimer( 0 )
  , receivedMsg()
  , abs_seqno( 0 )
  , capacity( 1 )
  , outstanding_ones()
  , ready_ones()
  , outstanding_bytes( 0 )
  , consecutive_retransmissions_nums( 0 )
{
  receivedMsg.ackno = isn;
  receivedMsg.window_size = 1;
}
uint64_t TCPSender::sequence_numbers_in_flight() const
{
  return outstanding_bytes;
}

uint64_t TCPSender::consecutive_retransmissions() const
{
  return consecutive_retransmissions_nums;
}

// push函数从流中提取多个段，直到outstanding集合容量超过限制或流结束。
// push生成一段一段消息，push进_outstanding集合，这就是发送方的已发送消息（的备份）的集合。
// push同时也会把消息复制一份放进ready集合，发送就是用ready集合直接pop出来发送。
void TCPSender::push( Reader& outbound_stream )
{
  while ( ready_ones.size() < receivedMsg.window_size ) {
    TCPSenderMessage msg;
    // 判断ISN发没发
    if ( _isSent_ISN == false ) {
      _isSent_ISN = true;
      msg.SYN = true;
      msg.seqno = isn;
    } else { // 直接用abs_seqno设置seqno
      msg.seqno = Wrap32::wrap( abs_seqno, isn );
    }
    // 设置提取的长度，三个限制条件的最小值
    size_t len = min(
      min( static_cast<size_t>( receivedMsg.window_size - outstanding_bytes ), TCPConfig::MAX_PAYLOAD_SIZE ),
      static_cast<size_t>( outbound_stream.bytes_buffered() ) );
  
    read( outbound_stream, len, msg.payload );
    if ( outbound_stream.is_finished() == true && msg.sequence_length() + outstanding_bytes < receivedMsg.window_size ) {
      if ( _isSent_FIN == false ) { 
        _isSent_FIN = true;
        msg.FIN = true;
      }
    }
    if ( msg.sequence_length() == 0 ) // 长度为0，就不用发送了
      break;
    else {
      ready_ones.push_back( msg );
      outstanding_ones.push_back( msg );
      outstanding_bytes += msg.sequence_length();
    }
    // 更新下一段的abs_seqno，_abs_seqno对应出站流上的位置
    abs_seqno += msg.sequence_length();
  }
}

optional<TCPSenderMessage> TCPSender::maybe_send()
{
  if ( ready_ones.size() == 0 )    return nullopt;
  TCPSenderMessage msg( ready_ones.front() );
  ready_ones.pop_front();
  isStartTimer = true;
  return msg;
}

void TCPSender::receive( const TCPReceiverMessage& msg )
{
  receivedMsg = msg;
  // 更新下一次发送时的窗口容量大小
  // 先判断窗口是不是0，是0，当成1
  if ( receivedMsg.window_size == 0 )
    receivedMsg.window_size = 1;
  capacity = msg.window_size; // 保留这个可能变化的值的原始值，用来判断是否执行“指数退避”
  if ( msg.ackno.has_value() == true ) { // ackno有值才需要删除确认的段
    // 确认ackno的有效性,传回来的ackno不能越过现在已经发出去的最新的seqno
    if ( msg.ackno.value().unwrap( isn, abs_seqno ) > abs_seqno )
      return;
    // 删除任何现在已经完全确认的段
    while ( outstanding_bytes != 0 
            && outstanding_ones.front().seqno.unwrap( isn, abs_seqno )
                   + outstanding_ones.front().sequence_length()
                 <= msg.ackno.value().unwrap( isn, abs_seqno ) ) {
      // 当ackno越过集合中某个元素的右边界时，删除这个元素
      outstanding_bytes -= outstanding_ones.front().sequence_length();
      outstanding_ones.pop_front();
      // 有未完成的段被确认时，(即outstanding集合发生pop)才会设置RTO
      // outstanding集合为空(全部未完成的段都完全确认)，则停止计时，重置计时器;否则仍有没确认的段，继续计时
      if ( outstanding_bytes == 0 )
        isStartTimer = false;
      else {
        isStartTimer = true;
      }
      consecutive_retransmissions_nums = 0;
      
      cur_RTO = initial_RTO;
    }
  }
}

TCPSenderMessage TCPSender::send_empty_message() const
{
  TCPSenderMessage msg;
  msg.seqno = Wrap32::wrap( abs_seqno, isn );
  return msg;
}

// tick函数用来模拟时间流逝，即调用tick时间才变化，否则当作时间不变，瞬间完成
void TCPSender::tick( const size_t ms_since_last_tick )
{
  // 判断计时器启动
  if ( isStartTimer == true ) {
    // 重传计时减少
    cur_RTO -= ms_since_last_tick;
  }
  // 如果计时结束
  if ( cur_RTO <= 0 ) {
    // 发起重传
    ready_ones.push_front( outstanding_ones.front() );
    consecutive_retransmissions_nums ++;
    // 重置定时器，执行“指数退避”策略
    if ( capacity > 0 ) {
      cur_RTO = pow( 2, consecutive_retransmissions_nums ) * initial_RTO;
    } else {
      cur_RTO = initial_RTO;
    }
  }
}