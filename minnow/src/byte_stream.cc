#include <stdexcept>
#include <iostream>
#include "byte_stream.hh"

using namespace std;

ByteStream::ByteStream( uint64_t capacity ) : capacity_( capacity ) {}

void Writer::push( string data )
{
  // Your code here.
  for (auto t:data) {
    if(buffer.size() == capacity_)  break;
    buffer.push (t);
    bytes_Pushed ++;
    leftStr += t;     
  }
}

void Writer::close()
{
  // Your code here.
  is_Closed = true;
}

void Writer::set_error()
{
  // Your code here.
  has_Error = true;
}

bool Writer::is_closed() const
{
  // Your code here.
  return is_Closed;
}

uint64_t Writer::available_capacity() const
{
  // Your code here.
  return capacity_ - buffer.size();
}

uint64_t Writer::bytes_pushed() const
{
  // Your code here.
  return bytes_Pushed;
}

string_view Reader::peek() const
{
  // Your code here.
  return leftStr;
}

bool Reader::is_finished() const
{
  // Your code here.
  return (is_Closed && buffer.empty());
}

bool Reader::has_error() const
{
  // Your code here.
  return has_Error;
}

void Reader::pop( uint64_t len )
{
  // Your code here.
  if(buffer.size() < len) {
    has_Error = true;
    return;
  }
  int tmp = len;
  while(tmp) {
    buffer.pop();
    tmp --;
    bytes_Popped ++;
  }
  leftStr = leftStr.substr (len);  // cut the already popped part
}

uint64_t Reader::bytes_buffered() const
{
  // Your code here.
  return buffer.size();
}

uint64_t Reader::bytes_popped() const
{
  // Your code here.
  return bytes_Popped;
}
