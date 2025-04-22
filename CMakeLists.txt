cmake_minimum_required(VERSION 3.16)
project(UpdateServiceScreen)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Определяем архитектуру для вывода сообщений и возможной логики
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(TARGET_ARCH "x64")
    message(STATUS "Configuring for 64-bit (x64)")
elseif(CMAKE_SIZEOF_VOID_P EQUAL 4)
    set(TARGET_ARCH "x86")
    message(STATUS "Configuring for 32-bit (x86)")
else()
    message(FATAL_ERROR "Unsupported architecture pointer size: ${CMAKE_SIZEOF_VOID_P}")
endif()

# Выходной файл будет просто в папке сборки
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

set(CMAKE_EXE_LINKER_FLAGS "-static")

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    add_compile_options(-mwindows)
    add_link_options(-mwindows)
endif()

# Одна цель
add_executable(UpdateServiceScreen src/main.cpp)

# Общие библиотеки
target_link_libraries(UpdateServiceScreen PRIVATE gdiplus shcore user32 gdi32)

# Библиотеки MinGW
if(MINGW)
    target_link_libraries(UpdateServiceScreen PRIVATE stdc++fs)
    # mingw32 нужна только для x86
    if(TARGET_ARCH STREQUAL "x86")
        target_link_libraries(UpdateServiceScreen PRIVATE mingw32)
    endif()
endif()

message(STATUS "Output: ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/UpdateServiceScreen.exe")
