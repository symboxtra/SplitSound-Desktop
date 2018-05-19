import QtQuick 2.0

Rectangle {
    id: left_panel
    anchors.left: parent.left

    width: 0.3 * parent.width
    height: parent.height - footer.height

    color: m_leftPanelColor

    MouseArea {
        id: left_window_mouse_area
        anchors.fill: parent

        onClicked: {
            parent.focus = true // Switch focus for key events
            closeModals()
            console.log("left panel clicked")
        }
    }
} // END left_panel
