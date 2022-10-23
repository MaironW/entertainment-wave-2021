#ifndef SCRIPTLAUNCHER_H
#define SCRIPTLAUNCHER_H

#include <QObject>
#include <QProcess>

class ScriptLauncher : public QObject
{

    Q_OBJECT

public:
    explicit ScriptLauncher(QObject *parent = nullptr);
    Q_INVOKABLE void launchCommand(QString command, QStringList arguments);
    Q_INVOKABLE void launchVideo(QString video);
    Q_INVOKABLE void launchTerminal(QString command);

private:
    QProcess *m_process;
};

#endif
