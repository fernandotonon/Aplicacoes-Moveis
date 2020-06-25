import QtQuick 2.14
import QtQuick.Window 2.14
import QtMultimedia 5.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Media Player")

    FileDialog{
        id: fileDialog
        onAccepted: {
            mediaPlayer.source = fileUrl
            mediaPlayer.play()
        }
    }

    Button{
        width: 100; height: 30
        text:"Abrir"
        onClicked: fileDialog.open()
    }

    MediaPlayer{
        id: mediaPlayer
        onStopped: play()
        onAvailabilityChanged: {if(MediaPlayer.Available) play()
            console.log("availability: "+availability)
        }
        onErrorStringChanged: console.log("errorString: "+errorString)
    }

    VideoOutput{
        anchors.fill: parent
        source: mediaPlayer
    }

    Rectangle {
        id: progressBar
        anchors.left: parent.left;  anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 30
        height: 10
        color: "lightGray"
        Rectangle {
            anchors.left: parent.left;  anchors.top: parent.top
            anchors.bottom: parent.bottom
             width: mediaPlayer.duration>0?parent.width*mediaPlayer.position/mediaPlayer.duration:0
             color: "darkGray"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: if (mediaPlayer.seekable) {
                           mediaPlayer.seek(mediaPlayer.duration * mouse.x/width);
                       }
        }
    }
}
