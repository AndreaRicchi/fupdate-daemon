QT -= gui

CONFIG += c++1z console
CONFIG -= app_bundle

DEFINES += QT_DEPRECATED_WARNINGS

include($$PWD/src/qdevicewatcher.pri)

SOURCES += \
        $$PWD/src/main.cpp

# Default rules for deployment.
target.path = /opt/bin
!isEmpty(target.path): INSTALLS += target
