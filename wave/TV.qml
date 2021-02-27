import QtQuick 2.12

Rectangle {
    id: tv
    width: 640
    height: 480
    color: "blue"

    Text {
        id: menuText
        text: "TV"
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
        rows: 3; columns: 1; spacing: 3

        property int currentButton: 0

        Button {
            buttonColor: "white"
            textColor: "blue"
            text: "MTV"
        }

        Button {
            buttonColor: "blue"
            textColor: "white"
            text: "VHS"
        }

        Button {
            buttonColor: "blue"
            textColor: "white"
            text: "COMMERCIALS"
        }

        focus: true

        Keys.onPressed: {
            if(event.key === Qt.Key_Up)
                currentButton--
                if(currentButton===-1)
                    currentButton=2
                toggleButton()
            if(event.key === Qt.Key_Down)
                currentButton++
                if(currentButton===3)
                    currentButton=0
                toggleButton()
            if(event.key === Qt.Key_Return)
                selectMenu()
            if(event.key === Qt.Key_Backspace)
                pageLoader.source = "Menu.qml"
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
            if(children[currentButton].text==="MTV")
                console.log("MTV")
            if(children[currentButton].text==="VHS")
                console.log("VHS")
                scriptLauncher.launchScript("my80stv.sh")
            if(children[currentButton].text==="COMMERCIALS")
                console.log("COMMERCIALS")
        }
    }
}




