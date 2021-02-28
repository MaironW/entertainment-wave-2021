import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    width: 640
    height: 480
    visible: true
    visibility: "FullScreen"
    title: qsTr("Entertainmentwave 2021")

    Item {
        Loader {
            id: pageLoader
            focus: true
            source: "Menu.qml"
        }
    }
}
