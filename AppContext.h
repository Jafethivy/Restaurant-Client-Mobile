#pragma once
#include <QObject>
#include <QQmlApplicationEngine>
#include <qqml.h>

class Login;
class AppWindow;
class Waiter;

class LoginController;
class AppController;
class WaiterController;

class AuthService;
class TablesService;
class MenuService;

class AppContext : public QObject
{
    Q_OBJECT
public:
    explicit AppContext(QObject *parent = nullptr);
    QQmlApplicationEngine* initialize();

private:
    void createObjects();
    void createSingeltons();
    void setupThreads();
    void setupConnections() const;
    void cleanup();

private:
    QString m_baseUrl = "http://192.168.1.84:8080/api";
    QString m_baseUrlB = "http://172.16.26.233:8080/api";
    QQmlApplicationEngine* engine = nullptr;

    Login* m_login = nullptr;
    AppWindow* m_appWindow = nullptr;
    Waiter* m_waiter = nullptr;

    LoginController* m_loginController = nullptr;
    AppController* m_appController = nullptr;
    WaiterController* m_waiterController = nullptr;

    AuthService* m_authService = nullptr;
    TablesService* m_tablesService = nullptr;
    MenuService* m_menuService = nullptr;
};
