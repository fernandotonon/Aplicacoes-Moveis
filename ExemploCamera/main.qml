import QtQuick 2.15
import QtQuick.Window 2.15
import QtMultimedia 5.15
import QtQuick.Controls 2.15

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Exemplo Câmera")

    ListModel{
        id:fotos
    }

    ListView{
        id: fotosView
        anchors.bottom: parent.bottom
        width: parent.width
        height: 100
        orientation: ListView.Horizontal
        model: fotos
        delegate: Image{
            width: 100; height: 100
            fillMode: Image.PreserveAspectCrop
            source:foto
        }
    }

    VideoOutput{
        width: parent.width
        height: parent.height-fotosView.height
        anchors.bottom: fotosView.top
        source: camera
    }

    Camera{
        id:camera
        imageCapture.onImageSaved: fotos.append({"foto":"file:///"+path})
    }

    Image {
        id: videoStopMotion
        width: parent.width
        height: parent.height-fotosView.height
        fillMode: Image.PreserveAspectFit
        visible: false
        property int indice: 0
    }

    Column{
        anchors.right: parent.right
        spacing: 5
        Button{
            text:"Tirar Foto"
            enabled: !videoStopMotion.visible
            onClicked: camera.imageCapture.capture()
        }
        Button{
            text:"Play Video"
            onClicked: {
                videoStopMotion.indice=0
                videoStopMotion.source=fotos.get(0).foto
                videoStopMotion.visible=true
                timerStopMotion.start()
            }
        }
        Button{
            text:"Stop"
            onClicked: {
                videoStopMotion.indice=0
                videoStopMotion.source=fotos.get(0).foto
                videoStopMotion.visible=false
                timerStopMotion.stop()
            }
        }
        Button{
            text:"Limpar"
            onClicked: fotos.clear()
        }
    }

    Timer{
        id:timerStopMotion
        interval: 500
        repeat: true
        onTriggered: {
            videoStopMotion.indice = videoStopMotion.indice<fotos.count-1?videoStopMotion.indice+1:0
            mudarFoto(videoStopMotion.indice)
        }
    }

    function mudarFoto(indice){
        videoStopMotion.source=fotos.get(indice).foto
        console.log(indice)
    }
}
