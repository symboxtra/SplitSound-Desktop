#include <QApplication>
#include <QWidget>

#include "Test.h"

int main(int argc, char *argv[]) {

    QApplication app(argc, argv);

    QWidget window;

    window.resize(250, 150);
    window.setWindowTitle("Hello world!");
    window.show();

    return app.exec();
}
