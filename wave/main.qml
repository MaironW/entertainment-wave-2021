import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Entertainmentwave 2021")

    Rectangle {
        id: page
        width: 640
        height: 480
        color: "blue"

        Text {
            id: menuText
            text: "MENU"
            y: 70
            anchors.horizontalCenter: page.horizontalCenter
            font.pixelSize: 36
            color: "white"
            font.family: "VCR OSD Mono"
        }

        Grid {
            id: menuSelection
            x: 4; anchors.top: menuText.bottom; anchors.topMargin: 30
            anchors.horizontalCenter: page.horizontalCenter
            rows: 4; columns: 1; spacing: 3

            Button {
                buttonColor: "blue"
                textColor: "white"
                text: "TV"
            }

            Button {
                buttonColor: "blue"
                textColor: "white"
                text: "VIDEOGAME"
            }

            Button {
                buttonColor: "blue"
                textColor: "white"
                text: "RADIO"
            }

            Button {
                buttonColor: "blue"
                textColor: "white"
                text: "SETTINGS"
            }

            function toggleButton(selbutton){
                for(var i=0; i< menuSelection.rows; i++){
                    menuSelection.children[i].buttonColor="blue"
                    menuSelection.children[i].textColor="white"
                selbutton.buttonColor="white"
                selbutton.textColor="blue"
                }
            }
        }
    }
}


