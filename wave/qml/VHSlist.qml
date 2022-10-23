import QtQuick 2.0
import FileIO 1.0

Rectangle {
    id: vhslist
    width: mw.width
    height: mw.height
    color: "black"

    Text {
        id: menuText
        text: "VHS"
        y: 70
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 36
        color: "white"
        font.family: "VCR OSD Mono"
    }

    ListModel { id: dataPlaylist }

    Rectangle {
        width: 600; height: 260
        x: 20; anchors.top: menuText.bottom; anchors.topMargin: 30
        color: "black"

        FileIO {
            id:filePlaylist
            source: "/playlist/vhs.json"
            onError: console.log(msg)
        }

        Component.onCompleted: {
            var JsonString = filePlaylist.read()
            var JsonObject = JSON.parse(JsonString)
            for(var i=0; i< JsonObject.length; i++){
                dataPlaylist.append({
                                 "title": JsonObject[i].title,
                                 "source": JsonObject[i].source,
				 "collection": JsonObject[i].collection
                                 })
            }
        }

        Component {
            id: musicDelegate
            Item {
                width: parent.width; height: 20
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
                    pageLoader.source = "VHS.qml"
            }
        }
    }
}

