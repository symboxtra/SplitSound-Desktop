# Add include directories
add_include_dir(src res)

# Add source files
add_sources(
    res/SplitSound.qrc
    res/logos/windows/SplitSound.rc
    src/main.cpp
    src/QSplitSoundApplication.cpp
    src/QQmlBridge.cpp
    src/QQmlSettingsBridge.cpp
    src/MainWindow.cpp
)