#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "AppContext.h"

int main(int argc, char *argv[]){
    QGuiApplication app(argc, argv);

    AppContext context;

    auto* engine = context.initialize();

    QObject::connect(
        engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection
    );

    engine->loadFromModule("Restaurant_Client_Mobile", "Main");

    return app.exec();
}
