#include "AppWindow.h"

AppWindow::AppWindow(QObject *parent)
    : QObject{parent}{

}

int AppWindow::currentScreen() const {
    return m_currentScreen;
}

void AppWindow::setCurrentScreen(int screen){
    if (m_currentScreen != screen) {
        m_currentScreen = screen;
        emit currentScreenChanged();
    }
}

void AppWindow::goToLogin(){
    setCurrentScreen(0);
}

void AppWindow::goToTables(){
    setCurrentScreen(1);
    emit loadTables();

}

void AppWindow::goToError(){

}
