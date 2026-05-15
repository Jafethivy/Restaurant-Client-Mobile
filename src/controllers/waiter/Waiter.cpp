#include "Waiter.h"

Waiter::Waiter(QObject *parent)
    : QObject{parent}{
}

void Waiter::menuSetter(QVariantList menu){
    m_menu = menu;
}

QVariantList Waiter::menuGetter() const {
    return m_menu;
}
