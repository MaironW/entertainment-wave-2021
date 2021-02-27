#ifndef SCRIPTLAUNCHER_H
#define SCRIPTLAUNCHER_H

#include <QObject>
#include <QProcess>

class ScriptLauncher : public QObject
{

    Q_OBJECT

public:
    explicit ScriptLauncher(QObject *parent = 0);
    Q_INVOKABLE void launchScript(QString script);

private:
    QProcess *m_process;
};

#endif
