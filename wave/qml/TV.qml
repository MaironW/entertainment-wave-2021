import QtQuick 2.0

MenuTemplate {
    grid_rows: 3
    parent_menu: "Menu.qml"
    Component.onCompleted: {
        Qt.createQmlObject("
            Button {
                text: \"MTV\"
                actions: [function(){pageLoader.source = \"MTV.qml\"}]
            }
        ", grid)

        Qt.createQmlObject("
            Button {
                text: \"VHS\"
                actions: [function(){pageLoader.source = \"VHS.qml\"}]
            }
        ", grid)

        Qt.createQmlObject("
            Button {
                text: \"CABLE\"
                actions: [function(){pageLoader.source = \"Cable.qml\"}]
            }
        ", grid)

        grid.toggleButton()
    }
}
