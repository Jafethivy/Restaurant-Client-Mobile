#include "LoginController.h"
#include "Login.h"

LoginController::LoginController(Login* login,
    QObject *parent)
    : QObject(parent), m_login(login){

    connect(m_login, &Login::loginAttempt,
        this, &LoginController::loginAttempt);

    connect(this, &LoginController::loginStatus,
        m_login, &Login::loginStatus);

    connect(m_login, &Login::loginError,
        this, &LoginController::loginError);
}
