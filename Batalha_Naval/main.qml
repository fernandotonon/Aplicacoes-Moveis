import QtQuick 2.14
import QtQuick.Window 2.14

Window {
    visible: true
    width: 640
    height: 560
    title: qsTr("Batalha Naval")
    property var elementos:[]
    property int total:0
    property int max: 20
    property int maxErros: 20
    property int countErros: 0
    property int countAcertos: 0
    Component.onCompleted: reset()
    function reset(){
        total=0
        countAcertos=0
        countErros=0
        for(let i=0; i<100; i++){
            elementos.push(total<max?Math.round(Math.random()*6/10):0)
            total+=elementos[i]
        }
    }

    Column{
        spacing: 10
        Row{
            spacing: 10
            Text {
                text: "Erros: "+countErros+"/"+maxErros
            }
            Text {
                text: "Acertos: "+countAcertos+"/"+total
            }
        }

        GridView{
            width: 500
            height: 500
            cellWidth: 50
            cellHeight: 50
            model:100
            delegate:
            Rectangle{
                width: 50
                height: 50
                color: "darkgreen"
                border.color: "lightgreen"
                border.width: 2
                Rectangle{
                    anchors.centerIn: parent
                    width: 40
                    height: 40
                    color: "darkgreen"
                    radius: 25
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            if(elementos[index]===0){
                                parent.color="blue"
                                countErros++
                                imgAgua.visible=true
                            }
                            else{
                                parent.color="red"
                                countAcertos++
                                imgBarco.visible=true
                            }
                        }
                    }
                }
                Image {
                    id:imgAgua
                    anchors.fill: parent
                    source: "agua.png"
                    visible: false
                }
                Image {
                    id:imgBarco
                    anchors.fill: parent
                    source: "barco"+Math.round(Math.random()*3+1)+".png"
                    visible: false
                }
            }
        }
    }

    function textoFinal(){
                          if(countAcertos>=total)
                            return "Venceu"
                          else if (countErros>=maxErros)
                            return "Perdeu"
                          return ""
                      }
    function corFinal(){
        if(countAcertos>=total)
          return "green"
        else if (countErros>=maxErros)
          return "red"
        return "black"
    }
    Rectangle{
        anchors.fill: parent
        visible: countAcertos>=total||countErros>=maxErros
        Text {
            anchors.centerIn: parent
            text: textoFinal()
            color:corFinal()
            font.pixelSize: 20
        }
    }
}
