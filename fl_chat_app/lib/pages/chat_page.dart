import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fl_chat_app/widgets/widgets.dart';
import 'package:fl_chat_app/services/services.dart';


class ChatScreen extends StatefulWidget {
   
     
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin{

  final _textCtrl = TextEditingController();
  final _focusNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  final List<ChatMessage> _messages = [ ];

  bool _estaEscribiendo =  false;

  @override
  void initState() {

    super.initState();
    chatService   = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService   = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _escucharMensaje);
  }

  void _escucharMensaje(dynamic payload){
    ChatMessage message = ChatMessage(
      uid: payload['de'], 
      texto: payload['mensaje-personal'], 
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 300))
      );
      setState(() {
        _messages.insert(0, message);
      });

      message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {

    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(usuarioPara.nombre.substring(0,2), style: const TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 15,
            ),
            const SizedBox(height: 2,),
            Text(usuarioPara.nombre, style: const TextStyle(color: Colors.black87, fontSize: 12))
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
                reverse: true,
                )
              ),
              const Divider(height: 1,),
              Container(
                color: Colors.white,
                child: _inputChat(),
              )
          ],
        ),
      )
    );
  }

  Widget _inputChat(){
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textCtrl,
                onSubmitted: _handleSubmit,
                onChanged: (String texto){
                  setState(() {
                    if (texto.trim().length > 1 ){
                      _estaEscribiendo = true;
                    } else {
                      _estaEscribiendo = false;
                    }
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar mensaje'
                ),
                focusNode: _focusNode,
              )
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
              ? CupertinoButton(
                child: const Text('Enviar'),
                onPressed: _estaEscribiendo
                    ? () => _handleSubmit(_textCtrl.text.trim())
                    : null,
                )
              : Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: IconTheme(
                  data: IconThemeData(color: Colors.blue[400]),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: const Icon(Icons.send),
                    onPressed: _estaEscribiendo
                    ? () => _handleSubmit(_textCtrl.text.trim())
                    : null,
                  ),
                ),
              )
            )
          ],
        ),
      )
      );
  }

  _handleSubmit(String texto){

    if (texto.isEmpty) return;

    _textCtrl.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      texto: texto, 
      uid: '123',
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 200)),
      );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() { _estaEscribiendo = false;  });

    socketService.emit('mensaje-personal', {
      'de': authService.usuario!.uid,
      'para': chatService.usuarioPara.uid,
      'mensaje': texto

    });

  }

  @override
  void dispose(){
    for (ChatMessage message in _messages){
      message.animationController.dispose();
    }
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }



}