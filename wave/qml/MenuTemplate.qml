import QtQuick 2.0

Rectangle {
    property alias grid: menuSelection
    property alias grid_rows: menuSelection.rows
    property string parent_menu: ""

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
        columns: 1; spacing: 3

        property int currentButton: 0

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
                pageLoader.source = parent_menu
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
            children[currentButton].onPressed()
        }
    }
}
