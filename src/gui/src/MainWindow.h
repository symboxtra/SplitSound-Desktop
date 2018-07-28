/**
 *  Created by Jack McKernan on 5/8/2018.
 */

#ifndef MAIN_WINDOW_H
#define MAIN_WINDOW_H

#include <string>

#include <QQuickView>
#include <QObject>
#include <QVariant>

#include "QQmlBridge.h"

class QSplitSoundApplication;

class MainWindow : public QQuickView
{

    private:
        

    public:

        MainWindow();
        virtual ~MainWindow();

        void addBridge(QScopedPointer<QQmlBridge> &bridge);
        QObject * getContextProperty(std::string propertyName);
        QObject * getContextObject(std::string objectName);
        QVariant getProperty(std::string objectName, std::string propertyName);

};

#endif // MAIN_WINDOW_H
