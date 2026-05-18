#pragma once
#include <QObject>
#include <Qvariant>
#include <QJsonArray>
#include <QJsonObject>

class Waiter : public QObject{
    Q_OBJECT
    Q_PROPERTY(QVariantList menuGetter READ menuGetter NOTIFY menuChanged)
public:
    explicit Waiter(QObject *parent = nullptr);

public slots:
    QVariantList menuGetter() const;
    void menuSetter(QVariantList menu);

    void orderCreated(QVariantMap order);
    void orderCompleted(int id_table);

signals:
    void getMenu();
    void menuChanged();
    void getOrder(int orderId);
    void orderTotal(double total);

    void tablesGetter(QVariantList tables);
    void orderGetter(QVariantList order);
    void orderSubmitted(int idTable, QVariantList order);

    void orderEdit(int id_order, QVariantList order);
    void orderGetTotal(int id_order, QVariantList order);
    void orderComplete(int id_order);
    void orderCancel(int id_order);

    void changeTableStatus(int tableId, bool hasOrder, int orderId);
    void closeSome_thing();
    void changeTableCompleted(int tableId, bool hasOrder, int orderId);
    void closeSomething();


    void logout();
private:
    QVariantList m_menu;
};
