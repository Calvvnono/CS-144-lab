# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.24

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/shenyudai/minnow

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/shenyudai/minnow/buile

# Utility rule file for format.

# Include any custom commands dependencies for this target.
include CMakeFiles/format.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/format.dir/progress.make

CMakeFiles/format:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/shenyudai/minnow/buile/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Formatting source code..."
	clang-format -i /home/shenyudai/minnow/apps/webget.cc /home/shenyudai/minnow/src/byte_stream.cc /home/shenyudai/minnow/src/byte_stream.hh /home/shenyudai/minnow/src/byte_stream_helpers.cc /home/shenyudai/minnow/src/network_interface.cc /home/shenyudai/minnow/src/network_interface.hh /home/shenyudai/minnow/src/reassembler.cc /home/shenyudai/minnow/src/reassembler.hh /home/shenyudai/minnow/src/tcp_receiver.cc /home/shenyudai/minnow/src/tcp_receiver.hh /home/shenyudai/minnow/src/tcp_sender.cc /home/shenyudai/minnow/src/tcp_sender.hh /home/shenyudai/minnow/src/wrapping_integers.cc /home/shenyudai/minnow/src/wrapping_integers.hh /home/shenyudai/minnow/tests/byte_stream_basics.cc /home/shenyudai/minnow/tests/byte_stream_capacity.cc /home/shenyudai/minnow/tests/byte_stream_many_writes.cc /home/shenyudai/minnow/tests/byte_stream_one_write.cc /home/shenyudai/minnow/tests/byte_stream_speed_test.cc /home/shenyudai/minnow/tests/byte_stream_stress_test.cc /home/shenyudai/minnow/tests/byte_stream_test_harness.hh /home/shenyudai/minnow/tests/byte_stream_two_writes.cc /home/shenyudai/minnow/tests/common.cc /home/shenyudai/minnow/tests/common.hh /home/shenyudai/minnow/tests/conversions.hh /home/shenyudai/minnow/tests/net_interface.cc /home/shenyudai/minnow/tests/network_interface_test_harness.hh /home/shenyudai/minnow/tests/reassembler_cap.cc /home/shenyudai/minnow/tests/reassembler_dup.cc /home/shenyudai/minnow/tests/reassembler_holes.cc /home/shenyudai/minnow/tests/reassembler_overlapping.cc /home/shenyudai/minnow/tests/reassembler_seq.cc /home/shenyudai/minnow/tests/reassembler_single.cc /home/shenyudai/minnow/tests/reassembler_speed_test.cc /home/shenyudai/minnow/tests/reassembler_test_harness.hh /home/shenyudai/minnow/tests/reassembler_win.cc /home/shenyudai/minnow/tests/receiver_test_harness.hh /home/shenyudai/minnow/tests/recv_close.cc /home/shenyudai/minnow/tests/recv_connect.cc /home/shenyudai/minnow/tests/recv_reorder.cc /home/shenyudai/minnow/tests/recv_reorder_more.cc /home/shenyudai/minnow/tests/recv_special.cc /home/shenyudai/minnow/tests/recv_transmit.cc /home/shenyudai/minnow/tests/recv_window.cc /home/shenyudai/minnow/tests/send_ack.cc /home/shenyudai/minnow/tests/send_close.cc /home/shenyudai/minnow/tests/send_connect.cc /home/shenyudai/minnow/tests/send_extra.cc /home/shenyudai/minnow/tests/send_retx.cc /home/shenyudai/minnow/tests/send_transmit.cc /home/shenyudai/minnow/tests/send_window.cc /home/shenyudai/minnow/tests/sender_test_harness.hh /home/shenyudai/minnow/tests/test_should_be.hh /home/shenyudai/minnow/tests/wrapping_integers_cmp.cc /home/shenyudai/minnow/tests/wrapping_integers_extra.cc /home/shenyudai/minnow/tests/wrapping_integers_roundtrip.cc /home/shenyudai/minnow/tests/wrapping_integers_unwrap.cc /home/shenyudai/minnow/tests/wrapping_integers_wrap.cc /home/shenyudai/minnow/util/address.cc /home/shenyudai/minnow/util/address.hh /home/shenyudai/minnow/util/arp_message.cc /home/shenyudai/minnow/util/arp_message.hh /home/shenyudai/minnow/util/buffer.hh /home/shenyudai/minnow/util/checksum.hh /home/shenyudai/minnow/util/ethernet_frame.hh /home/shenyudai/minnow/util/ethernet_header.cc /home/shenyudai/minnow/util/ethernet_header.hh /home/shenyudai/minnow/util/exception.hh /home/shenyudai/minnow/util/file_descriptor.cc /home/shenyudai/minnow/util/file_descriptor.hh /home/shenyudai/minnow/util/ipv4_datagram.hh /home/shenyudai/minnow/util/ipv4_header.cc /home/shenyudai/minnow/util/ipv4_header.hh /home/shenyudai/minnow/util/parser.hh /home/shenyudai/minnow/util/random.cc /home/shenyudai/minnow/util/random.hh /home/shenyudai/minnow/util/socket.cc /home/shenyudai/minnow/util/socket.hh /home/shenyudai/minnow/util/tcp_config.hh /home/shenyudai/minnow/util/tcp_receiver_message.hh /home/shenyudai/minnow/util/tcp_sender_message.hh

format: CMakeFiles/format
format: CMakeFiles/format.dir/build.make
.PHONY : format

# Rule to build all files generated by this target.
CMakeFiles/format.dir/build: format
.PHONY : CMakeFiles/format.dir/build

CMakeFiles/format.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/format.dir/cmake_clean.cmake
.PHONY : CMakeFiles/format.dir/clean

CMakeFiles/format.dir/depend:
	cd /home/shenyudai/minnow/buile && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/shenyudai/minnow /home/shenyudai/minnow /home/shenyudai/minnow/buile /home/shenyudai/minnow/buile /home/shenyudai/minnow/buile/CMakeFiles/format.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/format.dir/depend

