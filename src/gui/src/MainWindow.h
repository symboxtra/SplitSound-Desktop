/**
 *  Created by Jack McKernan on 5/8/2018.
 */

#ifndef MAIN_WINDOW_H
#define MAIN_WINDOW_H

#include <QQuickView>
#include "QQmlBridge.h"

class QSplitSoundApplication;

class MainWindow : public QQuickView
{

    private:
        

    public:

        MainWindow();
        ~MainWindow();

        void addBridge(QScopedPointer<QQmlBridge> &bridge);

};

#endif // MAIN_WINDOW_H
