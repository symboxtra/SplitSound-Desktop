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
    QFontDatabase::addApplicationFont(":/materialdesignicons-webfont.ttf");

    QSplitSoundApplication app(argc, argv);
    QQmlApplicationEngine engine;

    engine.load(QUrl("qrc:/main.qml"));

    return app.exec();
}
