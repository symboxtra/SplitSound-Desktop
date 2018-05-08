import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3

ApplicationWindow {
    id: window
    title: "SplitSound"
    width: 600
    height: 380
    visible: true

    Material.theme: Material.Dark
    Material.accent: Material.DeepOrange

    ToolButton
    {
        text:"Open Drawer"
        anchors.centerIn: parent
        onClicked:
            drawer.open()
    }

    Drawer {
        id: drawer
        width: 0.33 * window.width
        height: window.height
        
        Text {
            text: "Drawer"
            anchors.centerIn: parent
        }
    }

}

