import QtQuick 2.0

MenuTemplate {
    grid_rows: 2
    parent_menu: "TV.qml"
    Component.onCompleted: {
        Qt.createQmlObject("
            Button {
                text: \"SHUFFLE\"
                actions: [function(){scriptLauncher.launchCommand(\"python3\",[\"gen_playlist.py\",\"/media/usb_device/mtv\",\"vhs\"])},
                          function(){scriptLauncher.launchCommand(\"bash\",[\"videoloop.sh\",\"/media/usb_device/vhs\"])}]
            }
        ", grid)

        Qt.createQmlObject("
            Button {
                text: \"COLLECTION\"
                actions: [function(){scriptLauncher.launchCommand(\"python3\",[\"gen_playlist.py\",\"/media/usb_device/vhs\",\"vhs\"])},
                          function(){pageLoader.source = \"VHSlist.qml\"}]
            }
        ", grid)

        grid.toggleButton()
    }
}
