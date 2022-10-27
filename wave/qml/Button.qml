import QtQuick 2.0

Rectangle {
    property alias buttonColor: button.color
    property alias textColor: text.color
    property alias text: text.text

    property var actions
    property bool on: false

    id: button
    Text {
        id: text
        text: "TV"
        font.pixelSize: 36
        color: "white"
        font.family: "VCR OSD Mono"
    }

    color: "blue"
    width: childrenRect.width
    height: childrenRect.height

    function onPressed() {
        for(var i=0; i<actions.length; i++){
            actions[i]();
        }
    }
}
