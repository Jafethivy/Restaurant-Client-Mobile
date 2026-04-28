cmake_minimum_required(VERSION 3.16)

project(Restaurant_Client_Mobile VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appRestaurant_Client_Mobile
    main.cpp
)

qt_add_qml_module(appRestaurant_Client_Mobile
    URI Restaurant_Client_Mobile
    QML_FILES
        Main.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appRestaurant_Client_Mobile PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appRestaurant_Client_Mobile
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appRestaurant_Client_Mobile
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appRestaurant_Client_Mobile
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
