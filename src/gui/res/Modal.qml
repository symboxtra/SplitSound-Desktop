import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0
import "fonts/Icon.js" as MdiFont

Rectangle {
    id: modal
    anchors.centerIn: parent

    width: 0.3 * main_container.width
    height: 0.4 * main_container.height
    radius: 4
    z: 7

    color: m_modalColor
    visible: false

    property int time: -1
    property bool dynamic: false
    property bool allowClose: true
    property bool showCloseButton: true
    property bool useClickBlocker: false
    property bool useBackgroundFilter: false
    property string title: ""
    property string message: "Remember to add this modal to the closeModals function if you want it to auto-close when clicking outside of it.\n
                                     Assign \"\" to message to stop showing this."

    // Background filter and click blocker
    Rectangle {
        id: background_filter

        visible: useBackgroundFilter

        // Position outside of parent
        x: 0 - parent.x
        y: 0 - parent.y
        width: main_container.width
        height: main_container.height

        color: "black"
        opacity: 0.5
    }

    // Block clicks on rest of UI
    MouseArea {
        id: click_blocker

        enabled: useClickBlocker
        hoverEnabled: useClickBlocker

        // Position outside of parent
        x: 0 - parent.x
        y: 0 - parent.y
        width: main_container.width
        height: main_container.height

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

    // Must be before other clickable elements (z-index lower)
    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true // Allow clicks to propogate using mouse.accepted = false

        onClicked: {
            parent.focus = true // Switch focus for key events
            console.log("default modal handler clicked -- not propogating")
        }
    }

    Keys.onPressed: {
        if (allowClose && (event.key === Qt.Key_Escape) && (!event.modifiers))
        {
            console.log("escape pressed in modal")
            closeSelf()
        }
    }

    // close button (x)
    Button {
        id: upper_close_button
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 5

        visible: allowClose && showCloseButton

        background: IconLabel {
            text: MdiFont.Icon.closeCircleOutline
            color: Material.color(Material.Red)
            opacity: 0.7
        }

        onClicked: {
            closeSelf() // TODO: send cancelled signal if applicable
        }
    }



    function closeSelf() {
        if (dynamic && time != -1)
            destroy(time)
        else if (dynamic)
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
