import QtQuick 2.14
import QtQuick.Window 2.14
import QtSensors 5.15
import QtQuick.Controls 2.15

Window {
    id:janela
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    Column{
        spacing: 5
        Text{
            text: QmlSensors.sensorTypes().join(", ")
        }

        Text{
            id:acc
        }

        Text{
            id:ori
        }

        Text{
            id:tilt
        }

        Text{
            id:gir
        }

        Text{
            id:mag
        }

        Text{
            id:temp
        }

        Text{
            id:umi
        }

        Button{
            text: "Reset Tilt"
            onClicked: {
                sensorTilt.calibrate()
                rect.x = janela.width/2 - rect.width/2
                rect.y = janela.height/2 - rect.height/2
            }
        }
    }

    Accelerometer{
        Component.onCompleted: start()
        onReadingChanged: {
            var r = reading
            acc.text = "Acelerometro: x: "+r.x+" y: " + r.y + " z: " +r.z
        }
    }

    OrientationSensor{
        Component.onCompleted: start()
        onReadingChanged: {
            var r = reading
            var orientacao = ""
            switch(r.orientation){
            case 0: orientacao = "indefinido"
                break;
            case 1: orientacao = "TopUp"
                break;
            case 2: orientacao = "TopDown"
                break;
            case 3: orientacao = "LeftUp"
                break;
            case 4: orientacao = "RightUp"
                break;
            case 5: orientacao = "FaceUp"
                break;
            case 6: orientacao = "FaceDown"
                break;
            }

            ori.text = "Orientação: "+orientacao
        }
    }

    TiltSensor{
        id: sensorTilt
        property real ultimoX: 0
        property real ultimoY: 0
        Component.onCompleted: {
            calibrate()
            start()
        }
        onReadingChanged: {
            var r = reading
            tilt.text = "Tilt: x: "+r.xRotation+" y: " + r.yRotation
            var x = r.xRotation-ultimoX
            var y = r.yRotation-ultimoY
            move(x*10,y*10)
            ultimoX=r.xRotation
            ultimoY=r.yRotation
        }
    }

    function move(x,y){
        rect.x+=x
        rect.y-=y
    }

    Rectangle{
        id: rect
        x:parent.width/2 - width/2
        y: parent.height/2 - height/2
        width: 100
        height: 100
        color: "blue"
    }


    Gyroscope{
        Component.onCompleted: start()
        onReadingChanged: {
            var r = reading
            gir.text = "Giroscopio: x: "+r.x+" y: " + r.y + " z: " +r.z
        }
    }

    Magnetometer{
        Component.onCompleted: start()
        onReadingChanged: {
            var r = reading
            mag.text = "Magnetometro: cLevel: "+ r.calibrationLevel +" x: "+r.x+" y: " + r.y + " z: " +r.z
        }
    }

    AmbientTemperatureSensor{
        Component.onCompleted: start()
        onReadingChanged: {
            var r = reading
            temp.text = "Temperatura: "+ r.temperature
        }
    }

    HumiditySensor{
        Component.onCompleted: start()
        onReadingChanged: {
            var r = reading
            umi.text = "Umidade abs: "+ r.absoluteHumidity + " rel: " + r.relativeHumidity
        }
    }

    ProximitySensor{
        Component.onCompleted: start()
        onReadingChanged: {
            var r = reading
            umi.text = "Proximo: "+ r.near?"sim":"não"
        }
    }
    DistanceSensor{
        Component.onCompleted: start()
        onReadingChanged: {
            var r = reading
            umi.text = "Proximo: "+ r.distance
        }
    }

}
