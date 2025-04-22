cmake_minimum_required(VERSION 3.16)
project(UpdateServiceScreen)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(OUTPUT_DIR_X86 ${CMAKE_BINARY_DIR}/x86)
set(OUTPUT_DIR_X64 ${CMAKE_BINARY_DIR}/x64)
file(MAKE_DIRECTORY ${OUTPUT_DIR_X86} ${OUTPUT_DIR_X64})

set(CMAKE_EXE_LINKER_FLAGS "-static")

# Настройки для Windows GUI приложения (аналог -mwindows)
if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    add_compile_options(-mwindows)
    add_link_options(-mwindows)
endif()

set(SOURCES src/main.cpp)

add_executable(UpdateServiceScreen_x86 ${SOURCES})
set_target_properties(UpdateServiceScreen_x86 PROPERTIES 
    RUNTIME_OUTPUT_NAME "UpdateServiceScreen"
    RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_DIR_X86}
)
target_compile_options(UpdateServiceScreen_x86 PRIVATE -m32)
target_link_options(UpdateServiceScreen_x86 PRIVATE -m32)
target_link_libraries(UpdateServiceScreen_x86 PRIVATE gdiplus shcore user32 gdi32)
if(MINGW)
    target_link_libraries(UpdateServiceScreen_x86 PRIVATE stdc++fs mingw32)
endif()


add_executable(UpdateServiceScreen_x64 ${SOURCES})
set_target_properties(UpdateServiceScreen_x64 PROPERTIES
    RUNTIME_OUTPUT_NAME "UpdateServiceScreen"
    RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_DIR_X64}
)
target_link_libraries(UpdateServiceScreen_x64 PRIVATE gdiplus shcore user32 gdi32)
if(MINGW)
    target_link_libraries(UpdateServiceScreen_x64 PRIVATE stdc++fs)
endif()
