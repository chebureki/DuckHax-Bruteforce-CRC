cmake_minimum_required(VERSION 3.5)
enable_language(CUDA)
project(dh-brute)

include_directories(
    src
)

set (SRCS
    src/bruteforce.cu
    src/crc.cu
    src/hashsets.cu
)

add_executable(${CMAKE_PROJECT_NAME} ${SRCS})

