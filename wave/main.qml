import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    id: mw
    width: 640
    height: 480
    visible: true
    visibility: "FullScreen"
    title: qsTr("Entertainmentwave 2021")

    Component.onCompleted:{
        scriptLauncher.launchScript("gen_playlist.sh")
    }

    Item {
        Loader {
            id: pageLoader
            focus: true
            source: "Menu.qml"
        }
    }
}
