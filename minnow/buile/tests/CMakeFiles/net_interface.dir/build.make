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
include tests/CMakeFiles/net_interface.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include tests/CMakeFiles/net_interface.dir/compiler_depend.make

# Include the progress variables for this target.
include tests/CMakeFiles/net_interface.dir/progress.make

# Include the compile flags for this target's objects.
include tests/CMakeFiles/net_interface.dir/flags.make

tests/CMakeFiles/net_interface.dir/net_interface.cc.o: tests/CMakeFiles/net_interface.dir/flags.make
tests/CMakeFiles/net_interface.dir/net_interface.cc.o: /home/shenyudai/minnow/tests/net_interface.cc
tests/CMakeFiles/net_interface.dir/net_interface.cc.o: tests/CMakeFiles/net_interface.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/shenyudai/minnow/buile/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tests/CMakeFiles/net_interface.dir/net_interface.cc.o"
	cd /home/shenyudai/minnow/buile/tests && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tests/CMakeFiles/net_interface.dir/net_interface.cc.o -MF CMakeFiles/net_interface.dir/net_interface.cc.o.d -o CMakeFiles/net_interface.dir/net_interface.cc.o -c /home/shenyudai/minnow/tests/net_interface.cc

tests/CMakeFiles/net_interface.dir/net_interface.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/net_interface.dir/net_interface.cc.i"
	cd /home/shenyudai/minnow/buile/tests && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/shenyudai/minnow/tests/net_interface.cc > CMakeFiles/net_interface.dir/net_interface.cc.i

tests/CMakeFiles/net_interface.dir/net_interface.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/net_interface.dir/net_interface.cc.s"
	cd /home/shenyudai/minnow/buile/tests && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/shenyudai/minnow/tests/net_interface.cc -o CMakeFiles/net_interface.dir/net_interface.cc.s

# Object files for target net_interface
net_interface_OBJECTS = \
"CMakeFiles/net_interface.dir/net_interface.cc.o"

# External object files for target net_interface
net_interface_EXTERNAL_OBJECTS =

tests/net_interface: tests/CMakeFiles/net_interface.dir/net_interface.cc.o
tests/net_interface: tests/CMakeFiles/net_interface.dir/build.make
tests/net_interface: tests/libminnow_testing_debug.a
tests/net_interface: src/libminnow_debug.a
tests/net_interface: util/libutil_debug.a
tests/net_interface: tests/CMakeFiles/net_interface.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/shenyudai/minnow/buile/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable net_interface"
	cd /home/shenyudai/minnow/buile/tests && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/net_interface.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tests/CMakeFiles/net_interface.dir/build: tests/net_interface
.PHONY : tests/CMakeFiles/net_interface.dir/build

tests/CMakeFiles/net_interface.dir/clean:
	cd /home/shenyudai/minnow/buile/tests && $(CMAKE_COMMAND) -P CMakeFiles/net_interface.dir/cmake_clean.cmake
.PHONY : tests/CMakeFiles/net_interface.dir/clean

tests/CMakeFiles/net_interface.dir/depend:
	cd /home/shenyudai/minnow/buile && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/shenyudai/minnow /home/shenyudai/minnow/tests /home/shenyudai/minnow/buile /home/shenyudai/minnow/buile/tests /home/shenyudai/minnow/buile/tests/CMakeFiles/net_interface.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tests/CMakeFiles/net_interface.dir/depend

