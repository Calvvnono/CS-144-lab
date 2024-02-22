#include "reassembler.hh"

using namespace std;

void Reassembler::insert(uint64_t first_index, string data, bool is_last_substring, Writer& output)
{
  // Calculate the last index in the byte_stream
  uint64_t last_str_tail = now_index_;

  // Iterate through the buffer to find the right position for the new data
  auto it = buffer_.begin();
  while ( it != buffer_.end()) {
    if (first_index >= it->first) {
      last_str_tail = it->first + (it->second).length();
      it ++;
      continue;  // Data starts after the current segment of the reassembler
    }
    if (first_index + data.length() <= last_str_tail) {
      break;     // Data is completely covered by the last substring in the reassembler
    }

    // Calculate the start position and length of the effective part of data
    uint64_t index = std::max(first_index, last_str_tail);
    uint64_t start = index - first_index;
    uint64_t length = std::min(data.length() - start, it->first - index);

    // Extract the substring and insert it into the right position
    string str = data.substr(start, length);
    buffer_.insert({index, str}); 
    bytes_pending_ += str.length();

    // Update the tail of the last substring in the reassembler
    last_str_tail = it->first + (it->second).length();
    it ++;
  }

  // If the data should be added to the end of the reassembler
  if (first_index + data.length() > last_str_tail && first_index < now_index_ + output.available_capacity()) {
    uint64_t index = std::max(first_index, last_str_tail);
    uint64_t start = index - first_index;
    uint64_t length = std::min(data.length() - start, output.available_capacity() - (index - now_index_));

    // Extract tlast_str_tail = it->first + (it->second).length();he substring and push it to the end of the reassembler
    string str = data.substr(start, length);
    buffer_.insert({index, str});
    bytes_pending_ += str.length();
  }


  // Pop datagrams from the reassembler that are now available for output
  // Keep popping until substrings become inconsistent
  for (auto iter = buffer_.begin(); iter != buffer_.end(); ) {
    if (iter->first == now_index_) {
      output.push(iter->second);
      bytes_pending_ -= (iter->second).length();
      now_index_ += (iter->second).length();
      iter = buffer_.erase(iter);
      // Erase the current substring and move to the next substring in the reassembler
    } else {
      break;
    }
  }

  // Check if this is the last substring and close the output if needed
  if (is_last_substring) {
    received_last_ = true;
  }

  if (received_last_ && buffer_.empty()) {
    output.close();
    now_index_ = 0;
    bytes_pending_ = 0;
    received_last_ = false;
  }
}

uint64_t Reassembler::bytes_pending() const
{
  return bytes_pending_;
}