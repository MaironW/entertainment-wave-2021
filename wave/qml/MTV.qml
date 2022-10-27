import QtQuick 2.0

MenuTemplate {
    grid_rows: 2
    parent_menu: "TV.qml"
    Component.onCompleted: {
        Qt.createQmlObject("
            Button {
                text: \"SHUFFLE\"
                actions: [function(){scriptLauncher.launchCommand(\"python3\",[\"gen_playlist.py\",\"/media/usb_device/mtv\",\"mtv\"])},
                          function(){scriptLauncher.launchCommand(\"bash\",[\"videoloop.sh\",\"/media/usb_device/mtv\"])}]
            }
        ", grid)

        Qt.createQmlObject("
            Button {
                text: \"COLLECTION\"
                actions: [function(){scriptLauncher.launchCommand(\"python3\",[\"gen_playlist.py\",\"/media/usb_device/mtv\",\"mtv\"])},
                          function(){pageLoader.source = \"MTVlist.qml\"}]
            }
        ", grid)

        grid.toggleButton()
    }
}
