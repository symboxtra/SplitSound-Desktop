import QtQuick 2.0

Rectangle {
    anchors.centerIn: parent

    width: 0.3 * main_window.width
    height: 0.4 * main_window.height
    radius: 4
    z: 7

    color: m_modalColor
    visible: false

    property bool dynamic: false
    property int time: -1
    property string defaultMessage: "Remember to add this modal to the closeModals function if you want it to auto-close when clicking outside of it.\n
                                     Assign \"\" to defaultMessage to stop showing this."

    Label {
        anchors.fill: parent
        anchors.margins: 10
        wrapMode: Text.WordWrap
        text: defaultMessage
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
        if ((event.key == Qt.Key_Escape) && (!event.modifiers))
        {
            console.log("escape pressed in modal")
            closeSelf()
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
