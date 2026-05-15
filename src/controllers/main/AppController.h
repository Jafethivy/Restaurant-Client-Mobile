#pragma once
#include <QObject>

class AppWindow;

class AppController : public QObject
{
    Q_OBJECT
public:
    explicit AppController(AppWindow* m_appWindow,
        QObject *parent = nullptr);

signals:
    void loginError();
    void loadTables();

private:
    AppWindow* m_appWindow = nullptr;
};
