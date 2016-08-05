find_package(Qt5Core     REQUIRED)
find_package(Qt5Gui      REQUIRED)
find_package(Qt5Location REQUIRED)
find_package(Qt5Network  REQUIRED)
find_package(Qt5OpenGL   REQUIRED)
find_package(Qt5Quick    REQUIRED)
find_package(Qt5Widgets  REQUIRED)

QT5_ADD_RESOURCES(MBGL_QT_FILES ${CMAKE_SOURCE_DIR}/platform/qt/qmapbox.qrc)

set(MBGL_QT_LIBRARIES
    PRIVATE Qt5::Core
    PRIVATE Qt5::Gui
    PRIVATE Qt5::Network
    PRIVATE Qt5::OpenGL
)

add_library(qmapboxgl SHARED
    ${CMAKE_SOURCE_DIR}/platform/qt/include/qquickmapboxgl.hpp
    ${CMAKE_SOURCE_DIR}/platform/qt/include/qquickmapboxglstyleproperty.hpp
    ${CMAKE_SOURCE_DIR}/platform/qt/src/qquickmapboxgl.cpp
    ${CMAKE_SOURCE_DIR}/platform/qt/src/qquickmapboxglrenderer.cpp
    ${CMAKE_SOURCE_DIR}/platform/qt/src/qquickmapboxglrenderer.hpp
    ${CMAKE_SOURCE_DIR}/platform/qt/src/qquickmapboxglstyleproperty.cpp
)

target_link_libraries(qmapboxgl
    PRIVATE mbgl-core
    PRIVATE Qt5::Core
    PRIVATE Qt5::Gui
    PRIVATE Qt5::Location
    PRIVATE Qt5::OpenGL
    PRIVATE Qt5::Quick
)

target_link_libraries(mbgl-qt
    PRIVATE qmapboxgl
    PRIVATE Qt5::OpenGL
    PRIVATE Qt5::Widgets
)

# QtQuick app
add_executable(mbgl-qt-qml
    ${CMAKE_SOURCE_DIR}/platform/qt/qmlapp/main.cpp
    ${CMAKE_SOURCE_DIR}/platform/qt/qmlapp/qml.qrc
)

target_link_libraries(mbgl-qt-qml
    PRIVATE qmapboxgl
    PRIVATE Qt5::Location
    PRIVATE Qt5::Quick
)
