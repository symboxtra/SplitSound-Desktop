/**
 *  Created by Jack McKernan on 5/8/2018.
 */

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

void QSplitSoundApplication::close()
{
    this->quit();
}

QSplitSoundApplication::~QSplitSoundApplication()
{
    ; // empty statement
}
