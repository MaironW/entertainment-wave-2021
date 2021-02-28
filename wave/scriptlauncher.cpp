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
    QStringList arguments;

    m_process->setWorkingDirectory("script");

    arguments << script;
    m_process->setProgram("bash");
    m_process->setArguments(arguments);
    m_process->startDetached();

    m_process->waitForFinished();
    m_process->terminate();

}

void ScriptLauncher::launchVideo(QString video)
{
    QStringList arguments;

    arguments << "-fs" << video;
    m_process->setProgram("mpv");
    m_process->setArguments(arguments);
    m_process->startDetached();

    m_process->waitForFinished();
    m_process->terminate();
}
