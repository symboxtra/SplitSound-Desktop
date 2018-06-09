/**
 *  Created by Jack McKernan on 5/8/2018.
 */

#include "MainWindow.h"

MainWindow::MainWindow()
{
    setTitle("SplitSound");
    resize(800, 500);
    setMinimumSize(QSize(450, 280));
    setResizeMode(QQuickView::SizeRootObjectToView); // Size QML root to window

    setSource(QUrl("qrc:/main.qml"));
}

MainWindow::~MainWindow()
{

}
