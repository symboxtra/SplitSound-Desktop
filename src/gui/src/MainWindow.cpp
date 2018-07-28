/**
 *  Created by Jack McKernan on 5/8/2018.
 */

#include <QQmlContext>
#include <QQuickItem>
#include <QQmlProperty>

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

QObject * MainWindow::getContextProperty(string propertyName)
{
    QObject * object = qvariant_cast<QObject *>(rootContext()->contextProperty(QString::fromStdString(propertyName)));
    return object;
}

/*!
 * To be successfully found, the QML object must have property objectName: "someName"
 *
*/
QObject * MainWindow::getContextObject(string objectName)
{
    QObject * object = rootObject()->findChild<QObject *>(QString::fromStdString(objectName));

    if (object == NULL)
    {
        string warning = "QML object '" + objectName + "' was not found. Be sure to include the property objectName: \"someName\".";
        qDebug(warning.c_str());
    }

    return object;
}

QVariant MainWindow::getProperty(string objectName, string propertyName)
{
    QObject * object = getContextObject(objectName);
    QVariant prop = QQmlProperty::read(object, QString::fromStdString(propertyName));

    return prop;
}


MainWindow::~MainWindow()
{
    ; // empty statement
}
