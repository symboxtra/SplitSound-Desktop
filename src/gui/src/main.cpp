#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QFontDatabase>
#include <QQmlDebuggingEnabler>

#include "QSplitSoundApplication.h"
#include "MainWindow.h"

int main(int argc, char *argv[]) {

    QQmlDebuggingEnabler enabler;

    QCoreApplication::setOrganizationName("Symboxtra Software");
    QCoreApplication::setOrganizationDomain("http://symboxtra.tk");
    QCoreApplication::setApplicationName("SplitSound");
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QQuickStyle::setStyle("Material");

    QSplitSoundApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // Must be done after creating the application
    QFontDatabase::addApplicationFont(":/fonts/materialdesignicons-webfont.ttf");

    engine.load(QUrl("qrc:/main.qml"));

    return app.exec();
}
