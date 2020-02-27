#include <qdevicewatcher.h>

#include <QCoreApplication>
#include <QDebug>
#include <QDir>
#include <QProcess>
#include <QStorageInfo>
#include <QTimer>

void startUpdate(const QString &swuPath)
{
    const auto cmd = "swupdate -i " + swuPath + " && sync && reboot";

#ifdef Q_PROCESSOR_ARM
    QProcess().start(cmd.toUtf8().data());
#else
    qInfo() << cmd;
#endif
}

int main(int argc, char *argv[])
{
    auto checkUsbData = [](const auto &device) {
        foreach (const auto &storage, QStorageInfo::mountedVolumes()) {
            if (storage.device() != device) {
                continue;
            }

            qDebug() << storage.rootPath();
            const auto usbEntries = QDir(storage.rootPath()).entryList(QDir::Files, QDir::Name);
            for (const auto &filePath : usbEntries) {
                if (filePath == "MS_force_update") {
                    startUpdate(storage.rootPath() + "/" + filePath);
                }
            }
        }
    };

    QCoreApplication a(argc, argv);

    qInfo() << "fupdate-daemon starting...";

    QDeviceWatcher deviceWatcher;

    QObject::connect(&deviceWatcher, &QDeviceWatcher::deviceAdded, [&](auto device) {
        qDebug() << "Device" << device << "added";
        // Wait for the OS to mount the devices!
        QTimer::singleShot(2500, [=]() { checkUsbData(device); });
    });

    deviceWatcher.start();
    return a.exec();
}
