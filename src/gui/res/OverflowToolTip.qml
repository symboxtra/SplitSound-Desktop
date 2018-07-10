/**
 *  Created by Jack McKernan on 5/29/2018.
 */

import QtQuick 2.0
import QtQuick.Controls 2.2
import "Constants.js" as Constants

MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true

    property bool showOnlyOnClip: true
    property bool hovered: false
    property string text: ""

    onEntered: {
        hovered = true
    }

    onExited: {
        hovered = false
    }

    // Display full name only when text is elided
    ToolTip {
        parent: mouseArea.parent
        visible: Constants.showToolTips && hovered && (parent.truncated || !showOnlyOnClip)

        delay: 1000
        timeout: 5000
        text: mouseArea.text

        z: parent.z // prevent going beneath parents with high z
    }
}

