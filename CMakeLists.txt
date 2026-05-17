cmake_minimum_required(VERSION 3.16)

project(Restaurant_Client_Mobile VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

set(SERVICES
    src/services/AuthService.h
    src/services/AuthService.cpp
    src/services/TablesService.h
    src/services/TablesService.cpp
    src/services/MenuService.h
    src/services/MenuService.cpp
    src/services/OrderService.h
    src/services/OrderService.cpp
)
set(CONTROLLERS
    src/controllers/login/Login.h
    src/controllers/login/Login.cpp
    src/controllers/login/LoginController.h
    src/controllers/login/LoginController.cpp

    src/controllers/main/AppWindow.h
    src/controllers/main/AppWindow.cpp
    src/controllers/main/AppController.h
    src/controllers/main/AppController.cpp

    src/controllers/waiter/Waiter.h
    src/controllers/waiter/Waiter.cpp
    src/controllers/waiter/WaiterController.h
    src/controllers/waiter/WaiterController.cpp
)

qt_add_executable(appRestaurant_Client_Mobile
    main.cpp
    AppContext.h
    AppContext.cpp
    ${SERVICES}
    ${CONTROLLERS}
)

set(QML_TABLES
    qml/tables
)
set(UTILS
    qml/utils
)
set(QML_UI
    qml/Main.qml
    qml/Theme.qml
    qml/LoginScreen.qml

    ${UTILS}/PopupComponent.qml
    ${UTILS}/CustomLoader.qml
    ${QML_TABLES}/TableItem.qml
    ${QML_TABLES}/TablesScreen.qml
    ${QML_TABLES}/MenuScreen.qml
    ${QML_TABLES}/ExpandableCategory.qml
    ${QML_TABLES}/OrderScreen.qml
)
qt_add_qml_module(appRestaurant_Client_Mobile
    URI Restaurant_Client_Mobile
    VERSION 1.0
    QML_FILES
        ${QML_UI}
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

if(ANDROID)
    set_property(TARGET appRestaurant_Client_Mobile PROPERTY QT_ANDROID_ABIS "arm64-v8a;armeabi-v7a")
endif()

include(GNUInstallDirs)
install(TARGETS appRestaurant_Client_Mobile
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

set(QML_IMPORT_PATH ${CMAKE_BINARY_DIR} CACHE STRING "QML import paths" FORCE)
