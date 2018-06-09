/**
 *  Created by Jack McKernan on 5/8/2018.
 */

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

    // Must be done after creating the application
    QFontDatabase::addApplicationFont(":/fonts/materialdesignicons-webfont.ttf");
    QFont font("Roboto");
    font.setStyleHint(QFont::SansSerif);
    QApplication::setFont(font);

    MainWindow mainWindow;
    mainWindow.show();

    return app.exec();
}
