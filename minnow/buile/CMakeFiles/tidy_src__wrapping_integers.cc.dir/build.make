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

# Utility rule file for tidy_src__wrapping_integers.cc.

# Include any custom commands dependencies for this target.
include CMakeFiles/tidy_src__wrapping_integers.cc.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/tidy_src__wrapping_integers.cc.dir/progress.make

CMakeFiles/tidy_src__wrapping_integers.cc:
	clang-tidy --quiet -header-filter=.* -p=/home/shenyudai/minnow/buile /home/shenyudai/minnow/src/wrapping_integers.cc

tidy_src__wrapping_integers.cc: CMakeFiles/tidy_src__wrapping_integers.cc
tidy_src__wrapping_integers.cc: CMakeFiles/tidy_src__wrapping_integers.cc.dir/build.make
.PHONY : tidy_src__wrapping_integers.cc

# Rule to build all files generated by this target.
CMakeFiles/tidy_src__wrapping_integers.cc.dir/build: tidy_src__wrapping_integers.cc
.PHONY : CMakeFiles/tidy_src__wrapping_integers.cc.dir/build

CMakeFiles/tidy_src__wrapping_integers.cc.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/tidy_src__wrapping_integers.cc.dir/cmake_clean.cmake
.PHONY : CMakeFiles/tidy_src__wrapping_integers.cc.dir/clean

CMakeFiles/tidy_src__wrapping_integers.cc.dir/depend:
	cd /home/shenyudai/minnow/buile && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/shenyudai/minnow /home/shenyudai/minnow /home/shenyudai/minnow/buile /home/shenyudai/minnow/buile /home/shenyudai/minnow/buile/CMakeFiles/tidy_src__wrapping_integers.cc.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/tidy_src__wrapping_integers.cc.dir/depend
