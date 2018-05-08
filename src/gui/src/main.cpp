#include <QQmlApplicationEngine>
#include <QQuickStyle>

#include "QSplitSoundApplication.h"
#include "MainWindow.h"

int main(int argc, char *argv[]) {

    QCoreApplication::setOrganizationName("Symboxtra Software");
    QCoreApplication::setOrganizationDomain("http://symboxtra.tk");
    QCoreApplication::setApplicationName("SplitSound");
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QQuickStyle::setStyle("Material");

    QSplitSoundApplication app(argc, argv);
    QQmlApplicationEngine engine;

    engine.load(QUrl("qrc:/main.qml"));

    return app.exec();
}
