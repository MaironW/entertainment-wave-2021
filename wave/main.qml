import QtQuick 2.0
import QtQuick.Window 2.11

Window {
    id: mw
    width: 640
    height: 480
    visible: true
    flags: Qt.FramelessWindowHint
//    visibility: "FullScreen"
    title: qsTr("Entertainmentwave 2021")

    Item {
        Loader {
            id: pageLoader
            focus: true
            source: "Menu.qml"
        }
    }
}
