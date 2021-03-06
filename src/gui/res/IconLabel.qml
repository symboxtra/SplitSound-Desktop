/**
 *  Created by Jack McKernan on 5/8/2018.
 */

import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import "fonts/Icon.js" as MdiFont

Text {
    font.family: "Material Design Icons"
    font.pixelSize: Math.min(0.05 * main_container.height, 0.05 * main_container.width)

    verticalAlignment: Text.AlignVCenter

    property bool clickable: true
    property string initialColor: "white"
    property string hoverColor: initialColor
    property real initialOpacity: 0.85
    property real hoverOpacity: 0.6

    color: initialColor
    opacity: initialOpacity

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: (clickable) ? Qt.PointingHandCursor : undefined
        hoverEnabled: clickable
        propagateComposedEvents: true // Allow clicks to propogate

        // Pass click on
        onPressed: {
            if (clickable)
                parent.parent.focus = true // Switch focus for key events
            mouse.accepted = false
        }

        // Hover controls
        onEntered: {
            if (clickable)
            {
                parent.color = hoverColor
                parent.opacity = hoverOpacity
            }
        }
        onExited: {
            if (clickable)
            {
                parent.color = initialColor
                parent.opacity = initialOpacity
            }
        }
    }
}
