/**
 *  Created by Jack McKernan on 5/23/2018.
 */

import QtQuick 2.0
import QtQuick.Controls 2.2
import "Constants.js" as Constants

ToolTip {
    parent: parent
    visible: Constants.showToolTips && parent.hovered

    delay: 1000
    timeout: 5000

    z: parent.z // prevent going beneath parents with high z
}
