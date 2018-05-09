import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import "fonts/Icon.js" as MdiFont

ApplicationWindow {
    id: main_window
    title: "SplitSound"
    visible: true

    width: 600
    height: 380
    minimumWidth: 150
    minimumHeight: 150

    Material.theme: Material.Dark
    Material.accent: Material.DeepOrange
    font.family: "Roboto"

    Rectangle {
        id: header

        width: main_window.width
        height: Math.min(0.1 * main_window.height, 0.3 * main_window.width)

        color: "#232323"

        Button {
            id: menu_button

            background: IconLabel {
                text: MdiFont.Icon.menu
            }

            onClicked:
                drawer.open()
        }
    }

    Button {
        id: center_circle
        anchors.centerIn: parent

        Material.elevation: 200

        background: Rectangle {
            implicitWidth: Math.min(0.23 * main_window.width, 0.5 * main_window.height)
            implicitHeight: width
            radius: width * 0.5
            color: "#AE5733"
        }

        Image {
            id: headphones
            width: center_circle.width - 0.2 * center_circle.width
            height: center_circle.height - 0.2 * center_circle.height
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenterOffset: -0.05 * center_circle.height
            anchors.centerIn: parent
            source: "qrc:/images/headphones.svg"
        }
    }

    Drawer {
        id: drawer
        width: 0.33 * main_window.width
        height: main_window.height

        Text {
            text: "Drawer"
            anchors.centerIn: parent
        }
    }
}

