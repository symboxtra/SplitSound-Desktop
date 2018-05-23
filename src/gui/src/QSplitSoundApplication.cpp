
#include <QtCore>
#include <QtGui>

#include "QSplitSoundApplication.h"

QSplitSoundApplication * QSplitSoundApplication::m_instance = NULL;

QSplitSoundApplication::QSplitSoundApplication(int& argc, char ** argv) : QApplication(argc, argv)
{
    m_instance = this;
}

QSplitSoundApplication * QSplitSoundApplication::getInstance()
{
    return m_instance;
}

QSplitSoundApplication::~QSplitSoundApplication()
{

}
