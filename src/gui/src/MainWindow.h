#ifndef MAIN_WINDOW_H
#define MAIN_WINDOW_H

#include <QMainWindow>

class MainWindow : public QMainWindow
{

    private:

        void createStatusBar();
        

    public:

        MainWindow();
        ~MainWindow();

};

#endif // MAIN_WINDOW_H