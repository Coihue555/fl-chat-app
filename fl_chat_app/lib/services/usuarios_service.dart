import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:fl_chat_app/global/enviroment.dart';
import 'package:fl_chat_app/services/auth_service.dart';
import 'package:fl_chat_app/models/usuarios_response.dart';
import 'package:fl_chat_app/models/usuarios.dart';

class UsuariosService{

  Future<List<Usuario>> getUsuarios() async {

    try {
      final url = Uri.parse('${ Environment.apiUrl }/usuarios');

      final resp = await http.get(
        url,
        //body: jsonEncode(resp),
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        }
      );

      final usuariosResponse = usuariosResponseFromJson(resp.body);
      return usuariosResponse.usuarios;

    } catch (e) {
      return [];
    }

  }
}