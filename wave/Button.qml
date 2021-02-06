import QtQuick 2.12

Rectangle {
        property alias buttonColor: button.color
        property alias textColor: text.color
        property alias text: text.text

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

        MouseArea {
            anchors.fill: button
            onClicked: {
                console.log(text.text)
                if(button.on===false){
                    buttonColor="white"
                    textColor="blue"
                    button.on=true
                }else{
                    buttonColor="blue"
                    textColor="white"
                    button.on=false
                }
                button.parent.toggleButton(button)
            }
        }
}




