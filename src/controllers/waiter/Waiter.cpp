#include "Waiter.h"

Waiter::Waiter(QObject *parent)
    : QObject{parent}{
}

void Waiter::menuSetter(QVariantList menu){
    m_menu = menu;
    emit menuChanged();
}

QVariantList Waiter::menuGetter() const {
    return m_menu;
}

void Waiter::orderCreated(QVariantMap order){
    int tableId = order["id_table"].toInt();
    int hasOrder = order["success"].toBool();
    int orderId = order["id_order"].toInt();
    emit changeTableStatus(tableId, hasOrder, orderId);
}
