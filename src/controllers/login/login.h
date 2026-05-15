#pragma once
#include <QObject>
#include <QString>
#include <QDebug>
#include <QtQml/qqmlregistration.h>
#include <QQmlEngine>

class Login : public QObject {
    Q_OBJECT
public:
    explicit Login(QObject* parent = nullptr);
    static Login* create(QQmlEngine *engine, QJSEngine *scriptEngine);

public slots:
    void loginStatus(const int& area,
        const bool& status);

signals:
    void loginAttempt(const QString& id_user,
        const QString& pwd_user);
    void loginSuccess();
    void loginError();

};
