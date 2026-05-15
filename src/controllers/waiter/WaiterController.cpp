#include "WaiterController.h"
#include "Waiter.h"

WaiterController::WaiterController(Waiter* waiter, QObject *parent)
    : QObject(parent), m_waiter(waiter){

    connect(m_waiter, &Waiter::getMenu,
        this, &WaiterController::getMenu);

    connect(this, &WaiterController::tablesGetter,
        m_waiter, &Waiter::tablesGetter);
    connect(this, &WaiterController::menuGetter,
        m_waiter, &Waiter::menuSetter);

    connect(m_waiter, &Waiter::logout,
        this, &WaiterController::logout);
}

void WaiterController::logout(){
    emit logoutWindow();
    emit logoutServer();
}
