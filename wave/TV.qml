import QtQuick 2.0

Rectangle {
    id: tv
    width: mw.width
    height: mw.height
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
            text: "CABLE"
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
            if(children[currentButton].text==="MTV"){
                pageLoader.source = "MTV.qml"
//                console.log("MTV")
//                scriptLauncher.launchVideo("https://www.youtube.com/watch?v=_hI0qMtdfng")
            }
            else if(children[currentButton].text==="VHS"){
                console.log("VHS")
                scriptLauncher.launchVideo("https://www.youtube.com/watch?v=vgbMONXc9Cs")
            }
            else if(children[currentButton].text==="CABLE"){
                console.log("CABLE")
                scriptLauncher.launchScript("my80stv.sh")
            }
        }
    }
}




