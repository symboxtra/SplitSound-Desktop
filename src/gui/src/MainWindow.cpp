/**
 *  Created by Jack McKernan on 5/8/2018.
 */

#include <QQmlContext>

#include "MainWindow.h"

using namespace std;

MainWindow::MainWindow()
{
    setTitle("SplitSound");
    resize(800, 500);
    setMinimumSize(QSize(450, 280));
    setResizeMode(QQuickView::SizeRootObjectToView); // Size QML root to window

    setSource(QUrl("qrc:/main.qml"));
}

void MainWindow::addBridge(QScopedPointer<QQmlBridge> &bridge)
{
    rootContext()->setContextProperty(QString::fromStdString(bridge->getName()), bridge.data());
}

QObject * MainWindow::getProperty(string name)
{
    QObject * object = qvariant_cast<QObject *>(rootContext()->contextProperty(QString::fromStdString(name)));
    return object;
}

MainWindow::~MainWindow()
{

}
