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

# Include any dependencies generated for this target.
include tests/CMakeFiles/send_connect_sanitized.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include tests/CMakeFiles/send_connect_sanitized.dir/compiler_depend.make

# Include the progress variables for this target.
include tests/CMakeFiles/send_connect_sanitized.dir/progress.make

# Include the compile flags for this target's objects.
include tests/CMakeFiles/send_connect_sanitized.dir/flags.make

tests/CMakeFiles/send_connect_sanitized.dir/send_connect.cc.o: tests/CMakeFiles/send_connect_sanitized.dir/flags.make
tests/CMakeFiles/send_connect_sanitized.dir/send_connect.cc.o: /home/shenyudai/minnow/tests/send_connect.cc
tests/CMakeFiles/send_connect_sanitized.dir/send_connect.cc.o: tests/CMakeFiles/send_connect_sanitized.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/shenyudai/minnow/buile/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tests/CMakeFiles/send_connect_sanitized.dir/send_connect.cc.o"
	cd /home/shenyudai/minnow/buile/tests && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tests/CMakeFiles/send_connect_sanitized.dir/send_connect.cc.o -MF CMakeFiles/send_connect_sanitized.dir/send_connect.cc.o.d -o CMakeFiles/send_connect_sanitized.dir/send_connect.cc.o -c /home/shenyudai/minnow/tests/send_connect.cc

tests/CMakeFiles/send_connect_sanitized.dir/send_connect.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/send_connect_sanitized.dir/send_connect.cc.i"
	cd /home/shenyudai/minnow/buile/tests && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/shenyudai/minnow/tests/send_connect.cc > CMakeFiles/send_connect_sanitized.dir/send_connect.cc.i

tests/CMakeFiles/send_connect_sanitized.dir/send_connect.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/send_connect_sanitized.dir/send_connect.cc.s"
	cd /home/shenyudai/minnow/buile/tests && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/shenyudai/minnow/tests/send_connect.cc -o CMakeFiles/send_connect_sanitized.dir/send_connect.cc.s

# Object files for target send_connect_sanitized
send_connect_sanitized_OBJECTS = \
"CMakeFiles/send_connect_sanitized.dir/send_connect.cc.o"

# External object files for target send_connect_sanitized
send_connect_sanitized_EXTERNAL_OBJECTS =

tests/send_connect_sanitized: tests/CMakeFiles/send_connect_sanitized.dir/send_connect.cc.o
tests/send_connect_sanitized: tests/CMakeFiles/send_connect_sanitized.dir/build.make
tests/send_connect_sanitized: tests/libminnow_testing_sanitized.a
tests/send_connect_sanitized: src/libminnow_sanitized.a
tests/send_connect_sanitized: util/libutil_sanitized.a
tests/send_connect_sanitized: tests/CMakeFiles/send_connect_sanitized.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/shenyudai/minnow/buile/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable send_connect_sanitized"
	cd /home/shenyudai/minnow/buile/tests && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/send_connect_sanitized.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tests/CMakeFiles/send_connect_sanitized.dir/build: tests/send_connect_sanitized
.PHONY : tests/CMakeFiles/send_connect_sanitized.dir/build

tests/CMakeFiles/send_connect_sanitized.dir/clean:
	cd /home/shenyudai/minnow/buile/tests && $(CMAKE_COMMAND) -P CMakeFiles/send_connect_sanitized.dir/cmake_clean.cmake
.PHONY : tests/CMakeFiles/send_connect_sanitized.dir/clean

tests/CMakeFiles/send_connect_sanitized.dir/depend:
	cd /home/shenyudai/minnow/buile && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/shenyudai/minnow /home/shenyudai/minnow/tests /home/shenyudai/minnow/buile /home/shenyudai/minnow/buile/tests /home/shenyudai/minnow/buile/tests/CMakeFiles/send_connect_sanitized.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tests/CMakeFiles/send_connect_sanitized.dir/depend
