#include "tcp_receiver.hh"
#include <iostream>
using namespace std;

void TCPReceiver::receive( TCPSenderMessage message, Reassembler& reassembler, Writer& inbound_stream )
{
  // Your code here.
  if ( message.SYN ) {
    zeropoint = message.seqno;
    flag = true;
    message.seqno = message.seqno + 1; // 此时seqno指向ISN，因此需要重定向为有效载荷的第一个字符
  }

  if ( message.FIN ) {
    endingSegment = true;
    tail = Wrap32( message.seqno + message.payload.size() );  
  } else {
    endingSegment = false;
  }

  if ( flag ) {
    uint64_t checkpoint = inbound_stream.bytes_pushed();
    uint64_t idx = message.seqno.unwrap ( zeropoint,checkpoint ) - 1;
    string data = message.payload;
    reassembler.insert ( idx, data, endingSegment, inbound_stream );
  }
}

TCPReceiverMessage TCPReceiver::send( const Writer& inbound_stream ) const
{
  // Your code here.
  TCPReceiverMessage ans;
  uint64_t sum = inbound_stream.bytes_pushed();

  if ( flag ) {
    Wrap32 temp = Wrap32::wrap ( sum+1, zeropoint ); // sum先+1转成absolute seqno，再wrap
    if ( temp == tail ) {
      ans.ackno = temp + 1;                          // 特殊情况，ackno需要越过FIN
    } else {
      ans.ackno = temp;
    }
  } else {
    ans.ackno = nullopt;
  }

  if( inbound_stream.available_capacity() > UINT16_MAX ) {
    ans.window_size = UINT16_MAX;
  } else {
    ans.window_size = inbound_stream.available_capacity();
  }

  return ans;
}
