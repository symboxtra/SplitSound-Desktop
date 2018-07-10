/**
 *  Created by Jack McKernan on 5/20/2018.
 */

import QtQuick 2.7
import QtQuick.Controls 2.3

Modal {

    visible: true
    message: "" // Override warning message

    width: 0.8 * parent.width
    height: 0.5 * parent.height

    property int progressPercent: 50
    property int numServersFound: 0

    CustomLabel {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: progress_bar.top
        anchors.bottomMargin: 15
        text: "Searching for devices"
    }

    CustomProgressBar {
        id: progress_bar
        value: 25
    }


    CustomLabel {
        id: found_label
        anchors.top: progress_bar.bottom
        anchors.topMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Found: " + numServersFound
    }

    Button {
        anchors.top: found_label.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter

        text: "Cancel"

        onClicked: {
            console.log("search cancelled")
            closeSelf()
        }
    }

}
