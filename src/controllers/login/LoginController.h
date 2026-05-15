#pragma once
#include <QObject>

class Login;

class LoginController : public QObject
{
    Q_OBJECT
public:
    explicit LoginController(Login* login,
        QObject *parent = nullptr);

signals:
    void loginAttempt(const QString& username, const QString& password);
    void loginStatus(const int& area, const bool& status);
    void loginError();
private:
    Login* m_login = nullptr;
};
