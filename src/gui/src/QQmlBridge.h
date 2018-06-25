/**
 *  Created by Jack McKernan on 6/21/2018.
 */

#ifndef QQML_BRIDGE_H
#define QQML_BRIDGE_H

#include <string>

#include <QObject>
#include <QDebug>

class QQmlBridge : public QObject
{
    Q_OBJECT

    private:

        std::string m_name;

    public:

        QQmlBridge(std::string name);

        std::string getName();

};

#endif // QQML_BRIDGE_H
