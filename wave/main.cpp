#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>

#include "scriptlauncher.h"
#include "fileio.h"
#include "gamepad.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    QQmlContext *context = engine.rootContext();
    ScriptLauncher launcher;
    context->setContextProperty("scriptLauncher", &launcher);

    qmlRegisterType<FileIO, 1>("FileIO",1,0,"FileIO");

    Gamepad gp;
    context->setContextProperty("Gamepad", &gp);

    engine.load(url);
    return app.exec();
}
