import QtQuick 2.0
import QtQuick.Controls 2.2
import "Constants.js" as Constants

ToolTip {
    parent: parent
    visible: Constants.showToolTips && parent.hovered

    delay: 1000
    timeout: 5000
}
