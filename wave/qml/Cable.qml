import QtQuick 2.0

Rectangle {
    id: tv
    width: mw.width
    height: mw.height
    color: "blue"

    Text {
        id: menuText
        text: "CABLE"
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
            text: "70s"
        }

        Button {
            buttonColor: "blue"
            textColor: "white"
            text: "80s"
        }

        Button {
            buttonColor: "blue"
            textColor: "white"
            text: "90s"
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
            if(event.key === Qt.Key_Backspace)
                pageLoader.source = "TV.qml"
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
            if(children[currentButton].text==="70s"){
                console.log("70s")
                scriptLauncher.launchScript("my70stv.sh")
            }
            else if(children[currentButton].text==="80s"){
                console.log("80s")
                scriptLauncher.launchScript("my80stv.sh")
            }
            else if(children[currentButton].text==="90s"){
                console.log("90s")
                scriptLauncher.launchScript("my90stv.sh")
            }
        }
    }
}




