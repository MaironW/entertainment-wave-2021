#include "scriptlauncher.h"
#include <QDebug>
#include <QDir>

ScriptLauncher::ScriptLauncher(QObject *parent) :
    QObject(parent),
    m_process(new QProcess(this))
{
}

void ScriptLauncher::launchScript(QString script)
{
    m_process->setWorkingDirectory("script");
    m_process->start("bash",QStringList() << script);
}
