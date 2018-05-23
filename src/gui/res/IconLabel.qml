import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import "fonts/Icon.js" as MdiFont

Text {
    font.family: "Material Design Icons"
    font.pixelSize: Math.min(0.05 * main_container.height, 0.27 * main_container.width)

    verticalAlignment: Text.AlignVCenter

    color: "white"

    property real initialOpacity: 0.85
    property real hoverOpacity: 0.6
    opacity: initialOpacity

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        propagateComposedEvents: true // Allow clicks to propogate

        // Pass click on
        onPressed: {
            parent.parent.focus = true // Switch focus for key events
            mouse.accepted = false
        }

        // Hover controls
        onEntered: {
            parent.opacity = hoverOpacity
        }
        onExited: {
            parent.opacity = initialOpacity
        }
    }
}
