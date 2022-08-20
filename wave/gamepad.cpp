#include "gamepad.h"
#include <QFileSystemWatcher>
#include <QDebug>
#include <QFile>
#include <QProcess>

Gamepad::Gamepad(QObject *parent) : QObject(parent)
{
    watcher = new QFileSystemWatcher(this);
    connect(watcher, SIGNAL(fileChanged(const QString &)), this, SLOT(readModified(const QString &)));
    qDebug() << watcher->addPath("/home/pi/js");
}

void Gamepad::readModified(const QString& str)
{
    QFile file(str);
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)){
        QTextStream stream(&file);
        while(!stream.atEnd()){
            command = stream.readLine();
        }
    }
    QStringList list = command.split(" ", QString::SkipEmptyParts);
    int button = list[1].toInt();
    int action = list[2].compare("pressed");
    emit newCommand(button,action);
    file.close();
}
