cmake_minimum_required(VERSION 3.12)

# Change the project name here!
project(in_world_navigation LANGUAGES CXX)

# Properties.
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Variables.
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED YES)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

foreach(configuration ${CMAKE_CONFIGURATION_TYPES})
    string(TOLOWER ${configuration} configuration_lower)
    string(TOUPPER ${configuration} configuration_upper)

    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${configuration_upper} "${CMAKE_BINARY_DIR}/${configuration_lower}/libs")
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${configuration_upper} "${CMAKE_BINARY_DIR}/${configuration_lower}/bin")
endforeach()

add_definitions(-D_CRT_SECURE_NO_WARNINGS)

add_subdirectory("src/red4ext")