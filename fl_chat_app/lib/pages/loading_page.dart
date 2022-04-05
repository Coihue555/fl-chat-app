import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chat_app/pages/pages.dart';
import 'package:fl_chat_app/services/auth_service.dart';

class LoadingScreen extends StatelessWidget {
   
  const LoadingScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: ( context,  snapshot) { 
          return const Center(
            child: Text('Espere...')
          );
        },
      ),
    );
  }

  Future checkLoginState( BuildContext context ) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    if (autenticado){
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(pageBuilder: (_, __, ___) => const UsuariosScreen(),
          transitionDuration: const Duration(milliseconds: 0)
        )
      );
    } else {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionDuration: const Duration(milliseconds: 0)
          )
        );
      }
  }
}