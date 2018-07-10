#include <iostream>
#include <thread>
#include <future>
#include <gtest/gtest.h>

#include <QTimer>

#include "QSplitSoundApplication.h"
#include "MainWindow.h"
#include "QQmlBridge.h"
#include "QQmlSettingsBridge.h"

class TestGui : public ::testing::Test {

    protected:

        QSplitSoundApplication * app = NULL;
        MainWindow * mainWindow = NULL;

        virtual void SetUp()
        {
            int argc = 0;
            app = new QSplitSoundApplication(argc, NULL);
            mainWindow = new MainWindow();
        }

        virtual void TearDown()
        {
            app->close();
            delete mainWindow;
            delete app;
        }

};

TEST_F(TestGui, intial_appCanStart)
{
    ASSERT_TRUE(app != NULL);
    ASSERT_TRUE(mainWindow != NULL);

    QTimer::singleShot(500, app, &QCoreApplication::quit); // wait 1 second and then quit
    EXPECT_EQ(app->exec(), 0);
}

TEST_F(TestGui, initial_getInstance)
{
    QSplitSoundApplication * instance = app->getInstance();
    EXPECT_EQ(instance, app);
}

TEST_F(TestGui, cppBridge_canAddAndRetrieve)
{
    // Create bridge
    QScopedPointer<QQmlBridge> testBridge(new QQmlBridge("testBridge"));

    mainWindow->addBridge(testBridge);

    QObject * objectFromContext = mainWindow->getProperty("testBridge");
    QQmlBridge * bridgeFromContext = qobject_cast<decltype(bridgeFromContext)>(objectFromContext);

    EXPECT_EQ(testBridge->getName(), bridgeFromContext->getName());
}

TEST_F(TestGui, cppBridge_settingsBridge)
{
    // Create bridge
    QScopedPointer<QQmlBridge> settingsBridge(new QQmlSettingsBridge("settingsBridge"));

    mainWindow->addBridge(settingsBridge);

    QObject * objectFromContext = mainWindow->getProperty("settingsBridge");
    QQmlSettingsBridge * bridgeFromContext = qobject_cast<decltype(bridgeFromContext)>(objectFromContext);

    EXPECT_EQ(settingsBridge->getName(), bridgeFromContext->getName());
    EXPECT_TRUE(bridgeFromContext->test());
}
