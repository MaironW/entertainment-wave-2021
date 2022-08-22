import QtQuick 2.0

Rectangle {
    id: menu
    width: mw.width
    height: mw.height
    color: "blue"

    Text {
        id: menuText
        text: "MENU"
        y: 70
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 36
        color: "white"
        font.family: "VCR OSD Mono"
    }

    Grid {
        id: menuSelection
        x: 4; anchors.top: menuText.bottom; anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
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
                currentButton--
                if(currentButton===-1)
                    currentButton=rows-1
                toggleButton()
            if(event.key === Qt.Key_Down)
                currentButton++
                if(currentButton===rows)
                    currentButton=0
                toggleButton()
            if(event.key === Qt.Key_Return)
                selectMenu()
        }

        function toggleButton(){
            for(var i=0; i< rows; i++){
                children[i].buttonColor="blue"
                children[i].textColor="white"
            children[currentButton].buttonColor="white"
            children[currentButton].textColor="blue"
            }
        }

        function selectMenu(){
            pageLoader.focus = true
            if(children[currentButton].text==="TV"){
                pageLoader.source = "TV.qml"
            }
            else if(children[currentButton].text==="VIDEOGAME"){
                console.log("VIDEOGAME")
                scriptLauncher.launchScript("emulationstation.sh")
            }
            else if(children[currentButton].text==="RADIO"){
                console.log("RADIO")
                scriptLauncher.launchTerminal("spotify")
            }
            else if(children[currentButton].text==="SETTINGS"){
                console.log("SETTINGS")
                scriptLauncher.launchScript("gen_playlist.sh")
            }
        }
    }
}





