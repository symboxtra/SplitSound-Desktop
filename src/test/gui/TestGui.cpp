#include <iostream>
#include <thread>
#include <future>
#include <gtest/gtest.h>

#include <QObject>
#include <QThread>
#include <QTimer>
#include <QMetaObject>
#include <QQmlProperty>

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

        bool isVisible(std::string objectName)
        {
            QObject * test = mainWindow->getContextObject(objectName);
            if (test == NULL)
            {
                ADD_FAILURE();
                return false;
            }

            bool isVisible = mainWindow->getProperty(objectName, "visible").toBool();
            std::cout << "Visibility of '" << objectName << "': " << isVisible << std::endl;

            return isVisible;
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

    QObject * objectFromContext = mainWindow->getContextProperty("testBridge");
    QQmlBridge * bridgeFromContext = qobject_cast<decltype(bridgeFromContext)>(objectFromContext);

    EXPECT_EQ(testBridge->getName(), bridgeFromContext->getName());
}

TEST_F(TestGui, cppBridge_settingsBridge)
{
    // Create bridge
    QScopedPointer<QQmlBridge> settingsBridge(new QQmlSettingsBridge("settingsBridge"));

    mainWindow->addBridge(settingsBridge);

    QObject * objectFromContext = mainWindow->getContextProperty("settingsBridge");
    QQmlSettingsBridge * bridgeFromContext = qobject_cast<decltype(bridgeFromContext)>(objectFromContext);

    EXPECT_EQ(settingsBridge->getName(), bridgeFromContext->getName());
    EXPECT_TRUE(bridgeFromContext->test());
}

TEST_F(TestGui, cppBridge_nonExistentObject)
{
    QObject * test = mainWindow->getContextObject("non_existent");
    EXPECT_TRUE(test == NULL);
}

TEST_F(TestGui, cppBridge_canChangeVisibility)
{
    QObject * test = mainWindow->getContextObject("settings_modal");
    EXPECT_FALSE(isVisible("settings_modal"));

    QQmlProperty(test, "visible").write(true);
    EXPECT_TRUE(isVisible("settings_modal"));
}

TEST_F(TestGui, cppBridge_settingsButton)
{
    QObject * button;

    // Settings button
    button = mainWindow->getContextObject("settings_trigger");
    ASSERT_TRUE(button != NULL);

    EXPECT_FALSE(isVisible("settings_modal"));
    QMetaObject::invokeMethod(button, "clicked");
    EXPECT_TRUE(isVisible("settings_modal"));

    // Upper left close button is on all modals
    button = mainWindow->getContextObject("upper_close_button");
    ASSERT_TRUE(button != NULL);

    QMetaObject::invokeMethod(button, "clicked");
    EXPECT_FALSE(isVisible("settings_modal"));
}

TEST_F(TestGui, cppBrige_inputButton)
{
    QObject * button;

    // Input selector
    button = mainWindow->getContextObject("input_selector_trigger");
    ASSERT_TRUE(button != NULL);

    EXPECT_FALSE(isVisible("input_selector_modal"));
    QMetaObject::invokeMethod(button, "clicked");
    EXPECT_TRUE(isVisible("input_selector_modal"));

    // Input selector should toggle
    QMetaObject::invokeMethod(button, "clicked");
    EXPECT_FALSE(isVisible("input_selector_modal"));
}

// Disabled since the MouseArea currently handles the onClick
// Need to rearrange this in QML
TEST_F(TestGui, DISABLED_cppBridge_disconnectButton)
{
    QObject * button;

    // Disconnect button
    button = mainWindow->getContextObject("footer_disconnect_button");
    ASSERT_TRUE(button != NULL);

    EXPECT_FALSE(isVisible("modal"));

    // Example with args: QMetaObject::invokeMethod(button, "method", Q_ARG(QObject*, variable));
    QMetaObject::invokeMethod(button, "clicked");
    EXPECT_TRUE(isVisible("modal"));

    // Click somewhere outside modal
    button = mainWindow->getContextObject("center_circle");
    ASSERT_TRUE(button != NULL);

    QMetaObject::invokeMethod(button, "clicked");
    EXPECT_FALSE(isVisible("modal"));
}