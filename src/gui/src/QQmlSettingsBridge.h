/**
 *  Created by Jack McKernan on 6/21/2018.
 */

#ifndef QQML_SETTINGS_BRIDGE_H
#define QQML_SETTINGS_BRIDGE_H

#include <QObject>
#include <QDebug>

#include "QQmlBridge.h"

class QQmlSettingsBridge : public QQmlBridge
{
    Q_OBJECT

    public:

        QQmlSettingsBridge(std::string name);

        Q_INVOKABLE bool test();

};

#endif // QQML_SETTINGS_BRIDGE_H
