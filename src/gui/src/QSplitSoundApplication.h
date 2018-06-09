/**
 *  Created by Jack McKernan on 5/8/2018.
 */

#ifndef QSPLITSOUNDAPPLICATION_H
#define QSPLITSOUNDAPPLICATION_H

#include <QApplication>

class QSplitSoundApplication : public QApplication
{

    private:
        
        static QSplitSoundApplication * m_instance;

    public:

        QSplitSoundApplication(int& argc, char ** argv);
        ~QSplitSoundApplication();

        static QSplitSoundApplication * getInstance();

};

#endif // QSPLITSOUNDAPPLICATION_H
