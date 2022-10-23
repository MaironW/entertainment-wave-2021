import QtQuick 2.0

MenuTemplate {
    grid_rows: 4
    parent_menu: "Menu.qml"
    Component.onCompleted: {
        Qt.createQmlObject("
            Button {
                text: \"TV\"
                actions: [function(){pageLoader.source = \"TV.qml\"}]
            }
        ", grid)

        Qt.createQmlObject("
            Button {
                text: \"VIDEOGAME\"
                actions: [function(){scriptLauncher.launchCommand(\"openbox\",\"--exit\")}]
            }
        ", grid)

        Qt.createQmlObject("
            Button {
                text: \"RADIO\"
                actions: [function(){scriptLauncher.launchTerminal(\"spotify\")}]
            }
        ", grid)

        Qt.createQmlObject("
            Button {
                text: \"EXIT\"
                actions: [function(){pageLoader.source = \"Exit.qml\"}]
            }
        ", grid)

        grid.toggleButton()
    }
}
