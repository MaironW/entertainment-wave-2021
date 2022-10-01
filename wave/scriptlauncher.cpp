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

void ScriptLauncher::launchTerminal(QString command)
{
    QStringList arguments;

    arguments << "-fullscreen" << command;
    m_process->setProgram("xterm");
    m_process->setArguments(arguments);
    m_process->setWorkingDirectory(QString(QDir::homePath()));
    m_process->startDetached();

    // bring window to front of wave main screen
    QProcess window_to_front;
    window_to_front.setProgram("xdotool");
    QStringList xdotool_args;
    xdotool_args << "search" << "--name" << "pi@raspberrypi: ~" << "windowactivate";
    window_to_front.setArguments(xdotool_args);
    window_to_front.start();
    window_to_front.waitForFinished();
    window_to_front.terminate();

    m_process->waitForFinished();
    m_process->terminate();
}
