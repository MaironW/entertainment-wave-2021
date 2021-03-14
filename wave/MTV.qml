import QtQuick 2.12

Rectangle {
    id: tv
    width: 640
    height: 480
    color: "black"

    Text {
        id: menuText
        text: "MTV"
        y: 70
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 36
        color: "white"
        font.family: "VCR OSD Mono"
    }


    Rectangle {
        width: 400; height: 200
        x: 4; anchors.top: menuText.bottom; anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        color: "black"

        Component {
            id: musicDelegate
            Item {
                width: 400; height: 20
                Column {
                    Text {
                        text: name
                        color: "white"
                        font.family: "VCR OSD MONO"
                        font.pixelSize: 20
                    }
                }

                Keys.onPressed: {
                    if(event.key === Qt.Key_Return)
                        scriptLauncher.launchVideo(link)
                }
            }


        }

        ListView {
            id: musicList
            anchors.fill: parent
            model: MusicList {}
            delegate: musicDelegate
            highlight: Rectangle { color: "blue" }
            focus: true

            Keys.onPressed: {
                if(event.key === Qt.Key_Backspace)
                    pageLoader.source = "TV.qml"
            }
        }
    }
}

