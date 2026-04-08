cmake_minimum_required(VERSION 3.10)

project(emp_private_refutation)


set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_FLAGS "-msse4.1 -mrdseed -maes -mpclmul -O3 -pthread -w -Wl,-rpath -Wl,LIBDIR")

# Allow manual specification of emp-tool and emp-zk paths
set(EMP_TOOL_DIR "" CACHE PATH "Path to emp-tool")
set(EMP_ZK_DIR "" CACHE PATH "Path to emp-zk")

# Check for emp-tool and emp-zk in this repo first (highest priority)
if(NOT EMP_TOOL_DIR OR EMP_TOOL_DIR STREQUAL "")
  if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/emp-tool")
    set(EMP_TOOL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/emp-tool")
    message(STATUS "Found emp-tool in repository")
  endif()
endif()

if(NOT EMP_ZK_DIR OR EMP_ZK_DIR STREQUAL "")
  if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/emp-zk")
    set(EMP_ZK_DIR "${CMAKE_CURRENT_SOURCE_DIR}/emp-zk")
    message(STATUS "Found emp-zk in repository")
  endif()
endif()

# Search for emp-tool in common system locations
if(NOT EMP_TOOL_DIR OR EMP_TOOL_DIR STREQUAL "")
  find_path(EMP_TOOL_FOUND 
    NAMES "emp-tool" 
    PATHS 
      ~/dev/emp-tool
      ~/emp-tool
      /opt/emp-tool
      /usr/local/emp-tool
      /usr/emp-tool
      /home/ubuntu/emp-tool
      $ENV{HOME}/emp-tool
    NO_DEFAULT_PATH)
  if(EMP_TOOL_FOUND)
    set(EMP_TOOL_DIR ${EMP_TOOL_FOUND})
    message(STATUS "Found emp-tool at system location: ${EMP_TOOL_DIR}")
  endif()
endif()

# Search for emp-zk in common system locations
if(NOT EMP_ZK_DIR OR EMP_ZK_DIR STREQUAL "")
  find_path(EMP_ZK_FOUND
    NAMES "emp-zk"
    PATHS 
      ~/dev/emp-zk
      ~/emp-zk
      /opt/emp-zk
      /usr/local/emp-zk
      /usr/emp-zk
      /home/ubuntu/emp-zk
      $ENV{HOME}/emp-zk
    NO_DEFAULT_PATH)
  if(EMP_ZK_FOUND)
    set(EMP_ZK_DIR ${EMP_ZK_FOUND})
    message(STATUS "Found emp-zk at system location: ${EMP_ZK_DIR}")
  endif()
endif()

# Set defaults if not found
if(NOT EMP_TOOL_DIR OR EMP_TOOL_DIR STREQUAL "")
  set(EMP_TOOL_DIR "/home/ubuntu/emp-tool")
endif()

if(NOT EMP_ZK_DIR OR EMP_ZK_DIR STREQUAL "")
  set(EMP_ZK_DIR "/home/ubuntu/emp-zk")
endif()

message(STATUS "EMP_TOOL_DIR: ${EMP_TOOL_DIR}")
message(STATUS "EMP_ZK_DIR: ${EMP_ZK_DIR}")

# Check if directories exist and provide helpful warning
if(NOT EXISTS "${EMP_TOOL_DIR}")
  message(WARNING "emp-tool directory not found at: ${EMP_TOOL_DIR}")
  message(WARNING "Please install emp-tool or set EMP_TOOL_DIR manually:")
  message(WARNING "  cmake . -DEMP_TOOL_DIR=/path/to/emp-tool")
endif()

if(NOT EXISTS "${EMP_ZK_DIR}")
  message(WARNING "emp-zk directory not found at: ${EMP_ZK_DIR}")
  message(WARNING "Please install emp-zk or set EMP_ZK_DIR manually:")
  message(WARNING "  cmake . -DEMP_ZK_DIR=/path/to/emp-zk")
endif()

include_directories(include ${EMP_TOOL_DIR})
include_directories(include ${EMP_ZK_DIR})


#
#enable_testing()
#
#add_subdirectory(src)
#add_subdirectory(test)

# unit
#add_executable(test test.cpp clause.cpp f2kpoly.cpp xf2kpoly.cpp polynomial.cpp clauseRAM.cpp proof.cpp)
#target_link_libraries(test PUBLIC emp-tool emp-zk gmp ssl crypto ntl gmp)

add_executable(test main.cpp polynomial.cpp clause.cpp clauseRAM.cpp)
target_link_libraries(test PUBLIC emp-tool emp-zk gmp ssl crypto ntl gmp)
