#pragma once

#include "byte_stream.hh"
#include "tcp_receiver_message.hh"
#include "tcp_sender_message.hh"
#include <deque>

class TCPSender
{
  Wrap32 isn;
  bool _isSent_ISN;
  bool _isSent_FIN;
  uint64_t initial_RTO;
  int cur_RTO;                 // 记录现在的RTO，单位ms
  bool isStartTimer;              // 是否启动计时器
  TCPReceiverMessage receivedMsg; // 记录现在接收器返回给发送器的最新消息(确认号、窗口大小)
  uint64_t abs_seqno; // 记录push时，每一段的abs seqno，要用绝对序列号，因为相对序列号会溢出
  uint16_t capacity;                       // 记录可能变化的窗口的原始值
  std::deque<TCPSenderMessage> outstanding_ones; // 记录所有已发送未完成的段
  std::deque<TCPSenderMessage> ready_ones;       // 记录所有准备好发送的段
  uint64_t outstanding_bytes;                           // 记录已发送未完成的字节数
  uint64_t consecutive_retransmissions_nums;            // 重传次数


public:
  /* Construct TCP sender with given default Retransmission Timeout and possible ISN */
  TCPSender( uint64_t initial_RTO_ms, std::optional<Wrap32> fixed_isn );

  /* Push bytes from the outbound stream */
  void push( Reader& outbound_stream );

  /* Send a TCPSenderMessage if needed (or empty optional otherwise) */
  std::optional<TCPSenderMessage> maybe_send();

  /* Generate an empty TCPSenderMessage */
  TCPSenderMessage send_empty_message() const;

  /* Receive an act on a TCPReceiverMessage from the peer's receiver */
  void receive( const TCPReceiverMessage& msg );

  /* Time has passed by the given # of milliseconds since the last time the tick() method was called. */
  void tick( uint64_t ms_since_last_tick );

  /* Accessors for use in testing */
  uint64_t sequence_numbers_in_flight() const;  // How many sequence numbers are outstanding?
  uint64_t consecutive_retransmissions() const; // How many consecutive retransmissions have happened?
};
