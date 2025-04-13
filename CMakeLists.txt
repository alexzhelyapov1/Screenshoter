cmake_minimum_required(VERSION 3.12)
project(UpdateServiceScreen)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_EXE_LINKER_FLAGS "-static")

# Настройки для Windows GUI приложения (аналог -mwindows)
if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    add_compile_options(-mwindows)
    add_link_options(-mwindows)
endif()

add_executable(UpdateServiceScreen
    src/main.cpp
)

# Подключаем системные библиотеки Windows
target_link_libraries(UpdateServiceScreen PRIVATE
    gdiplus
    shcore
    user32
    gdi32
)

# Для MinGW может потребоваться явно указать стандартную библиотеку
if(MINGW)
    target_link_libraries(UpdateServiceScreen PRIVATE
        stdc++fs  # Для поддержки filesystem в C++17
        mingw32
    )
endif()