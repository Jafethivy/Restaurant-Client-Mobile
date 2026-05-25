#include "AppContext.h"

#include "src/controllers/login/Login.h"
#include "src/controllers/main/AppWindow.h"
#include "src/controllers/waiter/Waiter.h"

#include "src/controllers/login/LoginController.h"
#include "src/controllers/main/AppController.h"
#include "src/controllers/waiter/WaiterController.h"

#include "src/services/AuthService.h"
#include "src/services/TablesService.h"
#include "src/services/MenuService.h"
#include "src/services/OrderService.h"

#include "src/network/WebSocketClient.h"

AppContext::AppContext(QObject *parent)
    : QObject{parent}
{}

QQmlApplicationEngine* AppContext::initialize(){
    createObjects();
    createSingeltons();
    setupThreads();
    setupConnections();
    return engine;
}

void AppContext::createObjects(){
    engine = new QQmlApplicationEngine();

    m_login = new Login();
    m_appWindow = new AppWindow();
    m_waiter = new Waiter();

    m_loginController = new LoginController(m_login);
    m_appController = new AppController(m_appWindow);
    m_waiterController = new WaiterController(m_waiter);

    m_authService = new AuthService();
    m_authService->setBaseUrl(m_baseUrl); //Cambiar
    m_tablesService = new TablesService();
    m_tablesService->setBaseUrl(m_baseUrl); //Cambiar
    m_menuService = new MenuService();
    m_menuService->setBaseUrl(m_baseUrl); //Cambiar
    m_orderService = new OrderService();
    m_orderService->setBaseUrl(m_baseUrl); //Cambiar
}

void AppContext::createSingeltons(){
    qmlRegisterSingletonType<Login>("LoginLogic", 1, 0, "Login",
        [this](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject* {
            return m_login;
    });
    qmlRegisterSingletonType<AppWindow>("AppWindowLogic", 1, 0, "AppWindow",
        [this](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject* {
            return m_appWindow;
    });
    qmlRegisterSingletonType<Waiter>("WaiterLogic", 1, 0, "Waiter",
        [this](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject* {
            return m_waiter;
    });
}

void AppContext::setupThreads(){

}

void AppContext::setupIfSuccess(int area, bool success) {
    if (success) {
        m_webSocketClient = new WebSocketClient();
        m_webSocketClient->connectToServer(m_wsUrl, m_authService->token());
        setupWsConnections();
        m_tablesService->setToken(m_authService->token());
        m_menuService->setToken(m_authService->token());
        m_orderService->setToken(m_authService->token());
        m_waiter->getMenu();
    }
}

void AppContext::setupConnections() const {
    QObject::connect(m_authService, &AuthService::loginStatus,
        this, &AppContext::setupIfSuccess);

    QObject::connect(m_loginController, &LoginController::loginAttempt,
        m_authService, &AuthService::attemptLogin,
        Qt::AutoConnection);
    QObject::connect(m_authService, &AuthService::loginStatus,
        m_loginController, &LoginController::loginStatus,
        Qt::AutoConnection);
    QObject::connect(m_loginController, &LoginController::loginError,
        m_appController, &AppController::loginError,
        Qt::AutoConnection);

    QObject::connect(m_appController, &AppController::loadTables,
        m_tablesService, &TablesService::getAllTables,
        Qt::AutoConnection);
    QObject::connect(m_waiterController, &WaiterController::getMenu,
        m_menuService, &MenuService::getMenu,
        Qt::AutoConnection);
    QObject::connect(m_waiterController, &WaiterController::getOrder,
        m_orderService, &OrderService::getOrder,
        Qt::AutoConnection);

    QObject::connect(m_waiterController, &WaiterController::orderSubmitted,
        m_orderService, &OrderService::createOrder,
        Qt::AutoConnection);
    QObject::connect(m_waiterController, &WaiterController::orderEdit,
        m_orderService, &OrderService::updateOrder,
        Qt::AutoConnection);
    QObject::connect(m_waiterController, &WaiterController::orderGetTotal,
        m_orderService, &OrderService::totalOrder,
        Qt::AutoConnection);
    QObject::connect(m_waiterController, &WaiterController::orderComplete,
        m_orderService, &OrderService::completeOrder,
        Qt::AutoConnection);

    QObject::connect(m_tablesService, &TablesService::tablesGetter,
        m_waiterController, &WaiterController::tablesGetter,
        Qt::AutoConnection);
    QObject::connect(m_menuService, &MenuService::menuGetter,
        m_waiterController, &WaiterController::menuGetter,
        Qt::AutoConnection);
    QObject::connect(m_orderService, &OrderService::orderLoaded,
        m_waiterController, &WaiterController::orderGetter,
        Qt::AutoConnection);
    QObject::connect(m_orderService, &OrderService::orderTotal,
        m_waiterController, &WaiterController::orderTotal,
        Qt::AutoConnection);
    QObject::connect(m_orderService, &OrderService::orderCompleted,
        m_waiterController, &WaiterController::orderCompleted,
        Qt::AutoConnection);

    QObject::connect(m_waiterController, &WaiterController::logoutWindow,
        m_appWindow, &AppWindow::goToLogin,
        Qt::AutoConnection);
    QObject::connect(m_waiterController, &WaiterController::logoutWindow,
        m_appWindow, &AppWindow::goToLogin,
        Qt::AutoConnection);
    QObject::connect(m_waiterController, &WaiterController::logoutServer,
        m_authService, &AuthService::logout,
        Qt::AutoConnection);
    QObject::connect(m_waiterController, &WaiterController::logoutServer,
        this, &AppContext::cleanup,
        Qt::AutoConnection);

    QObject::connect(m_orderService, &OrderService::orderCreated,
        m_waiterController, &WaiterController::orderCreated,
        Qt::AutoConnection);
}

void AppContext::setupWsConnections() const{
    QObject::connect(m_webSocketClient, &WebSocketClient::tableStatusChange,
        m_waiterController, &WaiterController::wsTableStatus,
        Qt::AutoConnection);
}

void AppContext::cleanup(){
    m_webSocketClient->~WebSocketClient();
}
