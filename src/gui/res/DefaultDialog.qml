/**
 *  Created by Jack McKernan on 5/19/2018.
 */

import QtQuick 2.7
import QtQuick.Controls 2.3

Modal {

    visible: false
    message: "" // Override warning message

    property string button1Text: "OK"
    property string button2Text: "Cancel"

    Rectangle {
        anchors.fill: parent
        anchors.margins: 10
        color: "transparent"

        Rectangle {
            id: default_dialog_button_box
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: parent.color

            height: 0.2 * parent.height
            width: 0.7 * parent.width

            Button {
                id: default_dialog_button_1
                anchors.left: parent.left
                anchors.centerIn: (button2Text === "") ? parent : undefined
                anchors.verticalCenter: parent.verticalCenter

                width: 0.5 * parent.width

                text: button1Text
                visible: button1Text !== ""

                onClicked: {
                    console.log("default dialog confirmed")
                    closeSelf()
                }
            }

            Button {
                id: default_dialog_button_2
                anchors.left: default_dialog_button_1.right
                anchors.leftMargin: 3
                anchors.verticalCenter: parent.verticalCenter

                width: 0.5 * parent.width

                text: button2Text
                visible: button2Text !== ""

                onClicked: {
                    console.log("default dialog cancelled")
                    closeSelf()
                }
            }
        }
    }
}
