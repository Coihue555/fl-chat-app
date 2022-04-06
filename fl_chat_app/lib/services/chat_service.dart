import 'dart:convert';

import 'package:fl_chat_app/models/mensajes_response.dart';
import 'package:fl_chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chat_app/models/usuarios.dart';
import 'package:fl_chat_app/global/enviroment.dart';

class ChatService with ChangeNotifier{
  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat( String usuarioID) async {
    final url = Uri.parse('${ Environment.apiUrl }/mensajes/$usuarioID');

    final resp = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      }
    );

    final mensajesResp = mensajesResponseFromJson(resp.body);
    return mensajesResp.mensajes;
  }

}