import 'package:flutter/material.dart';

import 'package:fl_chat_app/pages/chat_page.dart';
import 'package:fl_chat_app/pages/loading_page.dart';
import 'package:fl_chat_app/pages/login_page.dart';
import 'package:fl_chat_app/pages/register_page.dart';
import 'package:fl_chat_app/pages/usuarios_page.dart';


final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios' : (_) => const UsuariosScreen(),
  'chat'     : (_) => const ChatScreen(),
  'loading'  : (_) => const LoadingScreen(),
  'register' : (_) => const RegisterScreen(),
  'login'    : (_) => const LoginScreen(),
};