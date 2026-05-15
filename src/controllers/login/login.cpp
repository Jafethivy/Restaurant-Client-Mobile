#include "Login.h"

Login::Login(QObject* parent) : QObject(parent)
{}

Login* Login::create(QQmlEngine *engine, QJSEngine *scriptEngine){
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
    static Login *instance = new Login();
    return instance;
}

void Login::loginStatus(const int& area, const bool& status){
    if(status){
        emit loginSuccess();
    }else{
        emit loginError();
    }
}
