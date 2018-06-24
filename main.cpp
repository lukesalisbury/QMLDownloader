#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "prosaic-download-queue.hpp"

QNetworkAccessManager webManager;
ProsaicDownloadQueue * humble_download;

QNetworkAccessManager * getNetworkManager()
{
	return &webManager;
}

QString getPathFromSettings(QString type)
{
	Q_UNUSED(type);
	QString path = QStandardPaths::writableLocation(QStandardPaths::CacheLocation);
	QDir dir;
	if ( dir.mkpath(path) )
		return path;
	return ""; // Return Empty String if path can not be created
}

bool doesFileExists(QString path) {
	QFileInfo check_file(path);
	return (check_file.exists() && check_file.isFile());
}

int main(int argc, char *argv[])
{
	QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

	QGuiApplication app(argc, argv);

	humble_download = new ProsaicDownloadQueue();

	QQmlApplicationEngine engine;
	engine.rootContext()->setContextProperty("humbleDownloader", humble_download);
	engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

	if (engine.rootObjects().isEmpty())
		return -1;


	//humble_download->append(QString("https://mokoi.info/index.html"), "system");
	//humble_download->append(QString("http://mokoi.info/images/index/os_3ds.png"), "system");

	int retval = app.exec();

	delete humble_download;

	return retval;
}
