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

    void orderGetter(QVariantList order);
    void getOrder(int orderId);
    void orderTotal(double total);
    void orderCompleted(int id_table);

    void orderSubmitted(int idTable, QVariantList order);
    void orderCreated(QVariantMap order);
    void orderEdit(int id_order, QVariantList order);
    void orderGetTotal(int id_order, QVariantList order);
    void orderComplete(int id_order);
    void orderCancel(int id_order);

    void wsTableStatus(QVariantMap result);

    void logoutWindow();
    void logoutServer();
private:
    Waiter* m_waiter = nullptr;
};
