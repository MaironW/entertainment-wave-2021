import QtQuick 2.0

MenuTemplate {
    grid_rows: 2
    parent_menu: "Menu.qml"
    Component.onCompleted: {
        Qt.createQmlObject("
            Button {
                text: \"POWER OFF\"
                actions: [function(){scriptLauncher.launchCommand(\"sudo\",[\"shutdown\",\"now\"])}]
            }
        ", grid)

        Qt.createQmlObject("
            Button {
                text: \"REBOOT\"
                actions: [function(){scriptLauncher.launchCommand(\"sudo\",[\"reboot\",\"now\"])}]
            }
        ", grid)

        grid.toggleButton()
    }
}
