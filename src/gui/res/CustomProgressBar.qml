/**
 *  Created by Jack McKernan on 5/20/2018.
 */

import QtQuick 2.7
import "Constants.js" as Constants

Rectangle {
    id: outer_progres_bar
    anchors.centerIn: parent

    width: 0.8 * parent.width
    height: 0.1 * parent.height

    property real value: 50
    property real minimum: 0
    property real maximum: 100
    property string progressColor: Constants.accentColorDark
    property string backgroundColor: Constants.accentColor

    color: backgroundColor

    Rectangle {
        anchors.left: parent.left

        width: (value - minimum) / (maximum - minimum) * parent.width
        height: parent.height

        color: progressColor
    }

}
