import QtQuick 2.14
import QtQuick.Window 2.14
import QtWebSockets 1.1
import QtQuick.Controls 2.12

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Jogo Batalha Naval")
    visibility: Window.Maximized
    property int totalJogador:0

    WebSocketServer {
        id: server
        listen: true
        host: "0.0.0.0"
        port: 1234
        accept: true
        onClientConnected: {
            jogo.visible=true
            campoIP.visible=false
            webSocket.onTextMessageReceived.connect(function (message) {
                var obj = JSON.parse(message)
                var objResposta = {}
                objResposta.tipo = "valor"
                objResposta.valor = JSON.stringify(dadosJogador.get(obj.indice))
                objResposta.indice = obj.indice
                objResposta.venceu = obj.total+dadosJogador.get(obj.indice).valor===totalJogador

                if(objResposta.venceu){
                    venceu.text=qsTr("Perdedor!")
                    venceu.color="red"
                }

                webSocket.sendTextMessage(JSON.stringify(objResposta))
            })
        }
        onErrorStringChanged: {
            console.log(errorString);
        }
        Component.onCompleted: {
            console.log(url)
        }
    }

    WebSocket{
        id: socket
        active: false

        onTextMessageReceived: {
            var obj = JSON.parse(message)
            if(obj.tipo === "valor"){
                dadosOponente.remove(obj.indice)
                dadosOponente.insert(obj.indice,JSON.parse(obj.valor))
                if(obj.venceu){
                    venceu.visible=true
                    gridJogador.visible=false
                    gridOponente.visible=false
                }
            }
        }

        onStatusChanged: {
            if(socket.status == WebSocket.Error){
                console.log("Erro: "+socket.errorString)
            } else if(socket.status == WebSocket.Open){
                jogo.visible=true
                campoIP.visible=false
            } else if(socket.status == WebSocket.Closed){
                console.log("Socket fechado")
            }
        }
    }

    Row{
        id:campoIP
        anchors.centerIn: parent
        spacing: 5
        Text{
            anchors.verticalCenter: parent.verticalCenter
            text: "IP: "
        }
        TextField{
            id:ip
            height: 30
            width: 100
            inputMask: "000.000.000.000"
        }
        Button{
            text: "Conectar"
            height: 30
            onPressed: {
                socket.url="ws://"+ip.text+":1234"
                socket.active=true
            }
        }
    }

    Item{
        id:jogo
        visible: false
        anchors.fill: parent

        ListModel{
            id: dadosJogador
            Component.onCompleted: {
                for(var i=0;i<100;i++){
                    var obj = {}
                    obj.valor = Math.round(Math.random()*0.6)
                    if(obj.valor===1)
                        totalJogador++
                    dadosJogador.append(obj)
                }
            }
        }
        ListModel{
            id: dadosOponente
            Component.onCompleted: {
                for(var i=0;i<100;i++){
                    var obj = {}
                    obj.valor = 2
                    dadosOponente.append(obj)
                }
            }
        }

        Row{
            Column{
                Text {
                    text: qsTr("Jogador:")
                }
                GridView{
                    id: gridJogador
                    model: dadosJogador
                    width: 500
                    height: 500
                    cellWidth: 50
                    cellHeight: 50
                    delegate: Rectangle{
                        width: 45
                        height: 45
                        color: valor == 0 ? "blue":"grey"
                    }
                }
            }
            Column{
                Text {
                    text: qsTr("Oponente:")
                }

                GridView{
                    id: gridOponente
                    model: dadosOponente
                    width: 500
                    height: 500
                    cellWidth: 50
                    cellHeight: 50
                    delegate: Rectangle{
                        width: 45
                        height: 45
                        color: valor == 0 ? "blue":(valor == 1?"grey":"black")
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                var obj = {}
                                obj.indice = index
                                obj.total = 0
                                for(var i=0;i<dadosOponente.count;i++){
                                    if(dadosOponente.get(i).valor===1)
                                        obj.total++
                                }
                                socket.sendTextMessage(JSON.stringify(obj))
                            }
                        }
                    }
                }
            }
        }
        Text {
            id: venceu
            anchors.centerIn: parent
            text: qsTr("Vencedor!")
            color: "green"
            font.bold: true
            font.pixelSize: 30
            visible: false
        }
    }
}
