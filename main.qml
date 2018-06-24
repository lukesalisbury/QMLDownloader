import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls.Styles.Desktop 1.0
import QtQuick.Controls 1.5

Window {
	visible: true
	width: 640
	height: 480
	title: qsTr("QML Downloader")
	id: pageDownloads
	color: "#ffffffff"
	opacity: 1

	signal update;

	MouseArea {
		id: mousearea1
		anchors.top: textField.bottom
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		propagateComposedEvents: false

		Rectangle {
			id: dialogDownloads
			anchors.rightMargin: 8
			anchors.leftMargin: 8
			anchors.bottomMargin: 8
			anchors.topMargin: 8
			anchors.fill: parent

			ListView {
				id: listDownloads
				clip: true
				anchors.fill: parent
				model: ListModel {}
				delegate: DownloadListDelegate {}
				WorkerScript {
					id: workerDownloads
					source: "prosaic-download-queue.js"
				}

			}

		}
	}
	TextField {
		id: textField
		height: 20
		anchors.right: parent.right
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.rightMargin: 8
		anchors.leftMargin: 8
		anchors.bottomMargin: 8
		anchors.topMargin: 8
		placeholderText: qsTr("Enter Url, then press Enter")

		Keys.onReturnPressed: {
			humbleDownloader.append(text, 'system')
		}
	}

	/* Creation */
	Component.onCompleted: {
		update()
	}

	onUpdate: {
		workerDownloads.sendMessage({model: listDownloads.model, items: humbleDownloader.items})
	}

	/* Connections */
	Connections {
		target: humbleDownloader
		onProgress: {
			pageDownloads.update()
		}
		onError: {
			pageDownloads.update()
		}
		onCompleted: {
			pageDownloads.update()
		}
		onUpdated: {
			pageDownloads.update()
		}
	}

}
