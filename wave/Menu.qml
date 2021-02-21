import QtQuick 2.12

Rectangle {
    id: menu
    width: 640
    height: 480
    color: "blue"

    Text {
        id: menuText
        text: "MENU"
        y: 70
        anchors.horizontalCenter: menu.horizontalCenter
        font.pixelSize: 36
        color: "white"
        font.family: "VCR OSD Mono"
    }

    Grid {
        id: menuSelection
        x: 4; anchors.top: menuText.bottom; anchors.topMargin: 30
        anchors.horizontalCenter: menu.horizontalCenter
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
                    currentButton=3
                toggleButton()
            if(event.key === Qt.Key_Down)
                currentButton++
                if(currentButton===4)
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
            if(children[currentButton].text==="TV")
                pageLoader.source = "TV.qml"
            if(children[currentButton].text==="VIDEOGAME")
                console.log("VIDEOGAME")
            if(children[currentButton].text==="RADIO")
                console.log("RADIO")
            if(children[currentButton].text==="SETTINGS")
                console.log("SETTINGS")
        }
    }
}





