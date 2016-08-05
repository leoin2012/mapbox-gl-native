# This file is to be reused by target platforms that don't
# support `mason` (i.e. Yocto). Do not add any `mason` macro.

option(WITH_QT_4        "Use Qt4 instead of Qt5"        OFF)
option(WITH_QT_DECODERS "Use builtin Qt image decoders" OFF)
option(WITH_QT_OFFLINE  "Use sqlite3 for offline cache" ON)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden -D__QT__")
set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -fvisibility=hidden -D__QT__")

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(MBGL_QT_FILES
    # File source
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/default/asset_file_source.cpp
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/default/online_file_source.cpp

    # Misc
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/default/log_stderr.cpp
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/qt/src/thread_local.cpp

    # Platform integration
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/qt/src/async_task.cpp
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/qt/src/async_task_impl.hpp
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/qt/src/http_file_source.cpp
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/qt/src/http_file_source.hpp
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/qt/src/http_request.cpp
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/qt/src/http_request.hpp
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/qt/src/image.cpp
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/qt/src/qmapbox.cpp
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/qt/src/qmapboxgl.cpp
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/qt/src/qmapboxgl_p.hpp
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/qt/src/run_loop.cpp
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/qt/src/run_loop_impl.hpp
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/qt/src/string_stdlib.cpp
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/qt/src/timer.cpp
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/qt/src/timer_impl.hpp

    # Public headers
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/qt/include/qmapbox.hpp
    PRIVATE ${CMAKE_SOURCE_DIR}/platform/qt/include/qmapboxgl.hpp
)

if(WITH_QT_OFFLINE)
    list(APPEND MBGL_QT_FILES
        PRIVATE ${CMAKE_SOURCE_DIR}/platform/default/default_file_source.cpp
        PRIVATE ${CMAKE_SOURCE_DIR}/platform/default/mbgl/storage/offline.cpp
        PRIVATE ${CMAKE_SOURCE_DIR}/platform/default/mbgl/storage/offline_database.cpp
        PRIVATE ${CMAKE_SOURCE_DIR}/platform/default/mbgl/storage/offline_database.hpp
        PRIVATE ${CMAKE_SOURCE_DIR}/platform/default/mbgl/storage/offline_download.cpp
        PRIVATE ${CMAKE_SOURCE_DIR}/platform/default/mbgl/storage/offline_download.hpp
        PRIVATE ${CMAKE_SOURCE_DIR}/platform/default/sqlite3.cpp
        PRIVATE ${CMAKE_SOURCE_DIR}/platform/default/sqlite3.hpp
    )
endif()

include_directories(
    PRIVATE platform/qt/include
)

# C++ app
add_executable(mbgl-qt
    ${CMAKE_SOURCE_DIR}/platform/qt/app/main.cpp
    ${CMAKE_SOURCE_DIR}/platform/qt/app/mapwindow.cpp
    ${CMAKE_SOURCE_DIR}/platform/qt/app/mapwindow.hpp
    ${CMAKE_SOURCE_DIR}/platform/qt/app/source.qrc
)

if(WITH_QT_4)
    include(${CMAKE_SOURCE_DIR}/platform/qt/qt4.cmake)
else()
    include(${CMAKE_SOURCE_DIR}/platform/qt/qt5.cmake)
endif()

# OS specific configurations
if (CMAKE_HOST_SYSTEM_NAME STREQUAL "Darwin")
    list(APPEND MBGL_QT_FILES
        PRIVATE ${CMAKE_SOURCE_DIR}/platform/darwin/src/headless_view_cgl.cpp
        PRIVATE ${CMAKE_SOURCE_DIR}/platform/darwin/src/nsthread.mm
        PRIVATE ${CMAKE_SOURCE_DIR}/platform/default/headless_display.cpp
        PRIVATE ${CMAKE_SOURCE_DIR}/platform/default/headless_view.cpp

    )
    list(APPEND MBGL_QT_LIBRARIES
        PRIVATE "-framework Foundation"
        PRIVATE "-framework OpenGL"
    )
elseif (CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
    list(APPEND MBGL_QT_FILES
        PRIVATE ${CMAKE_SOURCE_DIR}/platform/default/headless_display.cpp
        PRIVATE ${CMAKE_SOURCE_DIR}/platform/default/headless_view.cpp
        PRIVATE ${CMAKE_SOURCE_DIR}/platform/default/headless_view_glx.cpp
        PRIVATE ${CMAKE_SOURCE_DIR}/platform/default/thread.cpp
    )
    list(APPEND MBGL_QT_LIBRARIES
        PRIVATE -lGL
        PRIVATE -lX11
    )
elseif (CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    list(APPEND MBGL_QT_FILES
        PRIVATE ${CMAKE_SOURCE_DIR}/platform/qt/src/thread.cpp
    )
endif()
