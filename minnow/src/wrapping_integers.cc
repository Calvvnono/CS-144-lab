#include "wrapping_integers.hh"
#include <iostream>
#include <cmath>
using namespace std;
const uint32_t maxLength_32 = 4294967295;  // aka 2^32-1
const uint64_t maxLength = 4294967296;     // aka 2^32

Wrap32 Wrap32::wrap( uint64_t n, Wrap32 zero_point )
{
  // Your code here.
  /*Wrap32 ans (0);
  uint32_t zero_point_32 = zero_point.raw_value_;
  uint64_t num = n%maxLength;
  ans.raw_value_ = (zero_point_32+num > maxLength_32) ? zero_point_32+num-maxLength_32-1 : zero_point_32+num;
  return ans;*/
  Wrap32 seqno( zero_point + static_cast<uint32_t>( n ) );
  return seqno;
}

uint64_t Wrap32::unwrap( Wrap32 zero_point, uint64_t checkpoint ) const
{
  uint64_t res;
  if(raw_value_>=zero_point.raw_value_)   res = raw_value_ - zero_point.raw_value_;
  else                                    res = raw_value_ + maxLength - zero_point.raw_value_;

  if (checkpoint <= res)    return res; 
  int mul = (checkpoint-res)/maxLength;
  res = (checkpoint-res-mul*maxLength < res+(mul+1)*maxLength-checkpoint) ? res+mul*maxLength : res+(mul+1)*maxLength;
  return res;
}
