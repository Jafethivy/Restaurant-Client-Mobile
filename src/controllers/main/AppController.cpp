#include "AppController.h"
#include "AppWindow.h"

AppController::AppController(AppWindow* appWindow,
    QObject *parent)
    : QObject(parent), m_appWindow(appWindow){

    connect(this, &AppController::loginError,
        m_appWindow, &AppWindow::goToError);

    connect(m_appWindow, &AppWindow::loadTables,
        this, &AppController::loadTables);
}
