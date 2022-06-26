add_library(${CMAKE_PROJECT_NAME} SHARED "")

file(GLOB HEADERS *.hpp)
file(GLOB SOURCES *.cpp)

source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${HEADERS} ${SOURCES})

target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_sources(${CMAKE_PROJECT_NAME} PRIVATE ${HEADERS} ${SOURCES})

include_directories("../../deps/red4ext.sdk/include")
include_directories("../../deps/spdlog/include")

link_directories("../../deps/spdlog/build/Release")
