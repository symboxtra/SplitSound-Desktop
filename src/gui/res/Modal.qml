/**
 *  Created by Jack McKernan on 5/19/2018.
 */

import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0
import "fonts/Icon.js" as MdiFont
import "Constants.js" as Constants

Popup {
    id: modal

    Material.theme: parent.Material.theme
    Material.accent: parent.Material.accent

    x: (parent.width - width) / 2 // Center
    y: (parent.height - height) / 2

    width: 0.3 * main_container.width
    height: 0.4 * main_container.height

    background: Rectangle {
        color: Constants.modalColor
        radius: 4
    }

    visible: false
    dim: false // dims with white; doesn't look good
    z: 7

    modal: true

    property bool dynamic: false
    property bool showCloseButton: true
    property bool customDim: true
    property bool blockClicks: false // interferes with Popup.closeOnPressOutside

    property string title: ""
    property string message: ""

    Rectangle {
        id: background_filter

        visible: customDim

        // Extend outside of parent
        x: 0 - parent.parent.x - 50 // parent is contentItem; parent.parent is Popup
        y: 0 - parent.parent.y - 50
        width: main_container.width + 50
        height: main_container.height + 50

        color: "black"
        opacity: 0.5
    }

    // Block clicks on rest of UI
    MouseArea {
        id: click_blocker

        enabled: blockClicks
        hoverEnabled: true // Qt bug: prevent hover events from messing up Popup click handler

        // Extend outside of parent
        x: 0 - parent.parent.x - 50 // parent is contentItem; parent.parent is Popup
        y: 0 - parent.parent.y - 50
        width: main_container.width + 50
        height: main_container.height + 50

        onClicked: {
            console.log("click_blocker clicked")
        }
        onEntered: {} // Prevent hover events
    }

    CustomLabel {
        id: modal_title
        anchors.top: parent.top
        anchors.topMargin: 0.2 * parent.height
        anchors.horizontalCenter: parent.horizontalCenter

        font.weight: Font.ExtraBold
        text: title
    }

    CustomLabel {
        id: modal_message_box
        anchors.centerIn: parent
        width: 0.8 * parent.width

        text: message
    }

    // close button (x)
    Button {
        id: upper_close_button
        anchors.top: parent.top
        anchors.right: parent.right

        visible: showCloseButton

        background: IconLabel {
            text: MdiFont.Icon.closeCircleOutline
            initialColor: Material.color(Material.Red)
            opacity: 0.7
        }

        onClicked: {
            closeSelf() // TODO: send cancelled signal if applicable
        }
    }

    function closeSelf() {
        if (dynamic)
            destroy()
        else {
            visible = false
            focus = false
        }
    }

    function showSelf() {
        visible = true
    }

}
