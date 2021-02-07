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

            property int currentButton: 0

            Button {
                buttonColor: "white"
                textColor: "blue"
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

            focus: true
            Keys.onPressed: {
                if(event.key === Qt.Key_Up)
                    menuSelection.currentButton--
                    if(menuSelection.currentButton===-1)
                        menuSelection.currentButton=3
                    menuSelection.toggleButton()
                if(event.key === Qt.Key_Down)
                    menuSelection.currentButton++
                    if(menuSelection.currentButton===4)
                        menuSelection.currentButton=0
                    menuSelection.toggleButton()
            }

            function toggleButton(){
                for(var i=0; i< menuSelection.rows; i++){
                    menuSelection.children[i].buttonColor="blue"
                    menuSelection.children[i].textColor="white"
                menuSelection.children[menuSelection.currentButton].buttonColor="white"
                menuSelection.children[menuSelection.currentButton].textColor="blue"
                }
            }
        }
    }
}


