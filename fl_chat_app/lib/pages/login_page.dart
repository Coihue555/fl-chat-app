import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chat_app/widgets/widgets.dart';
import 'package:fl_chat_app/services/auth_service.dart';
import 'package:fl_chat_app/services/socket_service.dart';
import 'package:fl_chat_app/helpers/mostrar_alerta.dart';


class LoginScreen extends StatelessWidget {
   
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff2f2f2),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height*0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Logo(titulo: 'Messenger',),
                _Form(),
                const Labels(ruta: 'register', titulo: 'No tienes cuenta?', subtitulo: 'Crea una ahora!',),
                const Text('Terminos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200))
              ],
            ),
          ),
        )
      ),
    );
  }
}


class _Form extends StatefulWidget {

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService   = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.email_outlined,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),

          CustomInput(
            icon: Icons.lock_outlined,
            placeholder: 'Password',
            textController: pwdCtrl,
            isPassword: true,
          ),

          BotonAzul(
            text:'Ingresar',
            onPressed: authService.autenticando ? null : () async {
              FocusScope.of(context).unfocus();
              final loginOk = await authService.login( emailCtrl.text.trim(), pwdCtrl.text.trim() );

              if (loginOk){
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'usuarios');
              } else {
                mostrarAlerta(context, 'Login incorrecto', 'Revise sus credenciales');
              }
            },
          )

        ],
      ),
    );
  }
}