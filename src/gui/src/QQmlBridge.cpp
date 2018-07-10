/**
 *  Created by Jack McKernan on 6/21/2018.
 */

#include "QQmlBridge.h"

using namespace std;

QQmlBridge::QQmlBridge(string name)
{
    this->m_name = name;
}

string QQmlBridge::getName()
{
    return this->m_name;
}
