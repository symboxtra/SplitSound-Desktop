/**
 *  Created by Jack McKernan on 6/21/2018.
 */

#include <iostream>
#include "QQmlSettingsBridge.h"

using namespace std;

QQmlSettingsBridge::QQmlSettingsBridge(string name) : QQmlBridge(name)
{}

void QQmlSettingsBridge::test()
{
    qDebug("Settings window opened");
}
