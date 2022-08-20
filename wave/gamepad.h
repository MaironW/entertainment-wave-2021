#ifndef GAMEPAD_H
#define GAMEPAD_H

#include <QObject>
#include <QFileSystemWatcher>

class Gamepad : public QObject
{
    Q_OBJECT
public:
    explicit Gamepad(QObject *parent = nullptr);
    QString command;
private:
    QFileSystemWatcher *watcher;
public slots:
    void readModified(const QString& str);
signals:
    void newCommand(int button, int action);
};

#endif // GAMEPAD_H
