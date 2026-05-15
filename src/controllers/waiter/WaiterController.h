#pragma once
#include <QObject>
#include <QVariant>

class Waiter;

class WaiterController : public QObject
{
    Q_OBJECT
public:
    explicit WaiterController(Waiter* waiter,
        QObject *parent = nullptr);

    void logout();

signals:
    void getMenu();

    void tablesGetter(QVariantList tables);
    void menuGetter(QVariantList categories);

    void logoutWindow();
    void logoutServer();

private:
    Waiter* m_waiter = nullptr;
};
