#include "WaiterController.h"
#include "Waiter.h"

WaiterController::WaiterController(Waiter* waiter, QObject *parent)
    : QObject(parent), m_waiter(waiter){

    connect(m_waiter, &Waiter::getMenu,
        this, &WaiterController::getMenu);
    connect(m_waiter, &Waiter::getOrder,
        this, &WaiterController::getOrder);

    connect(this, &WaiterController::tablesGetter,
        m_waiter, &Waiter::tablesGetter);
    connect(this, &WaiterController::menuGetter,
        m_waiter, &Waiter::menuSetter);
    connect(this, &WaiterController::orderGetter,
        m_waiter, &Waiter::orderGetter);
    connect(this, &WaiterController::orderCreated,
        m_waiter, &Waiter::orderCreated);
    connect(this, &WaiterController::orderTotal,
        m_waiter, &Waiter::orderTotal);
    connect(this, &WaiterController::orderCompleted,
        m_waiter, &Waiter::orderCompleted);

    connect(m_waiter, &Waiter::orderSubmitted,
        this, &WaiterController::orderSubmitted);
    connect(m_waiter, &Waiter::orderEdit,
        this, &WaiterController::orderEdit);
    connect(m_waiter, &Waiter::orderGetTotal,
        this, &WaiterController::orderGetTotal);
    connect(m_waiter, &Waiter::orderComplete,
        this, &WaiterController::orderComplete);

    connect(m_waiter, &Waiter::logout,
        this, &WaiterController::logout);
}

void WaiterController::logout(){
    emit logoutWindow();
    emit logoutServer();
}
