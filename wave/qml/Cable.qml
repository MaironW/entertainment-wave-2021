import QtQuick 2.0

MenuTemplate {
    grid_rows: 3
    parent_menu: "TV.qml"
    Component.onCompleted: {
        Qt.createQmlObject("
            Button {
                text: \"70s\"
                actions: [function(){scriptLauncher.launchCommand(\"bash\",[\"myretrotvs.sh\",text])}]
            }
        ", grid)

        Qt.createQmlObject("
            Button {
                text: \"80s\"
                actions: [function(){scriptLauncher.launchCommand(\"bash\",[\"myretrotvs.sh\",text])}]
            }
        ", grid)

        Qt.createQmlObject("
            Button {
                text: \"90s\"
                actions: [function(){scriptLauncher.launchCommand(\"bash\",[\"myretrotvs.sh\",text])}]
            }
        ", grid)

        grid.toggleButton()
    }
}
