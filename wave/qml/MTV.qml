import QtQuick 2.0
import FileIO 1.0

Rectangle {
    id: tv
    width: mw.width
    height: mw.height
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

    ListModel { id: dataPlaylist }


    Rectangle {
        width: 400; height: 200
        x: 4; anchors.top: menuText.bottom; anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        color: "black"

        FileIO {
            id:filePlaylist
            source: "/playlist/mtv.json"
            onError: console.log(msg)
        }

        Component.onCompleted: {
            var JsonString = filePlaylist.read()
            var JsonObject = JSON.parse(JsonString)
            for(var i=0; i< JsonObject.length; i++){
                dataPlaylist.append({
                                 "title": JsonObject[i].title,
                                 "source": JsonObject[i].source
                                 })
            }
        }

        Component {
            id: musicDelegate
            Item {
                width: 400; height: 20
                Column {
                    Text {
                        text: title
                        color: "white"
                        font.family: "VCR OSD MONO"
                        font.pixelSize: 20
                    }
                }

                Keys.onPressed: {
                    if(event.key === Qt.Key_Return)
                        scriptLauncher.launchVideo(source)
                }
            }
        }

        ListView {
            id: musicList
            anchors.fill: parent
            model: dataPlaylist
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

