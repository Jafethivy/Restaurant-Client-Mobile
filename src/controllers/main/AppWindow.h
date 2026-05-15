#pragma once
#include <QObject>
#include <QString>
#include <QDebug>
#include <QtQml/qqmlregistration.h>
#include <QQmlEngine>

class AppWindow : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int currentScreen READ currentScreen WRITE setCurrentScreen NOTIFY currentScreenChanged)
public:
    explicit AppWindow(QObject *parent = nullptr);
    static AppWindow* create(QQmlEngine *engine, QJSEngine *scriptEngine);

    int currentScreen() const;
    void setCurrentScreen(int screen);

public slots:
    void goToError();
    void goToLogin();
    void goToTables();

signals:
    void currentScreenChanged();

    void loadTables();
    void getMenu();

private:
    int m_currentScreen = 0;
};

