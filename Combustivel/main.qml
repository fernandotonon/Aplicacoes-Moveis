import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.12
import "combustivel.js" as Combustivel
import Qt.labs.settings 1.1

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Valida Preço Combustível")

    Settings{
        category: "Combustivel"
        fileName: "config.ini"

        property alias alcool: alcool.text
        property alias gasolina: gasolina.text
    }

    Column{
        anchors.centerIn: parent
        spacing: 10
        Row{
            spacing: 10
            Text{
                anchors.verticalCenter: parent.verticalCenter
                text:"Álcool: "
            }
            TextField{
                id: alcool
                width: 100
                height: 30
                inputMask: "9.00"
            }
        }
        Row{
            spacing: 10
            Text{
                anchors.verticalCenter: parent.verticalCenter
                text:"Gasolina: "
            }
            TextField{
                id: gasolina
                width: 100
                height: 30
                inputMask: "9.00"
            }
        }
        Button{
            text:"Verificar"
            onClicked: {
                if(Combustivel.compensaAlcool(alcool.text,gasolina.text)){
                    mensagem.text = "Compensa Álcool"
                }else{
                    mensagem.text = "Compensa Gasolina"
                }
            }
        }
        Text {
            id: mensagem
            color: "green"
        }
    }

}
