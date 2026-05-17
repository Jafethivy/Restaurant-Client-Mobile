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

signals:
    void getMenu();
    void menuChanged();
    void getOrder(int orderId);

    void tablesGetter(QVariantList tables);
    void orderGetter(QVariantList order);
    void orderSubmitted(int idTable, QVariantList order);

    void changeTableStatus(int tableId, bool hasOrder, int orderId);

    void logout();
private:
    QVariantList m_menu;
};
