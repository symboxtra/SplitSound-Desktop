/**
 *  Created by Jack McKernan on 5/8/2018.
 */

#ifndef MAIN_WINDOW_H
#define MAIN_WINDOW_H

#include <string>

#include <QQuickView>
#include "QQmlBridge.h"

class QSplitSoundApplication;

class MainWindow : public QQuickView
{

    private:
        

    public:

        MainWindow();
        virtual ~MainWindow();

        void addBridge(QScopedPointer<QQmlBridge> &bridge);
        QObject * getProperty(std::string name);

};

#endif // MAIN_WINDOW_H
