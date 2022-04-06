import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fl_chat_app/helpers/mostrar_alerta.dart';
import 'package:fl_chat_app/widgets/widgets.dart';
import 'package:fl_chat_app/services/socket_service.dart';
import 'package:fl_chat_app/services/auth_service.dart';


class RegisterScreen extends StatelessWidget {
   
  
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
                const Logo(titulo: 'Registro'),
                _Form(),
                const Labels(ruta: 'login', titulo: 'Ya tienes cuenta?', subtitulo: 'Ingresa ahora',),
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

  final nombreCtrl = TextEditingController();
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
            icon: Icons.person_add,
            placeholder: 'Nombre de usuario',
            keyboardType: TextInputType.text,
            textController: nombreCtrl,
          ),

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
            text:'Crear cuenta',
            onPressed: authService.autenticando ? null : () async {


            final registroOk = await authService.register(nombreCtrl.text.trim(), emailCtrl.text.trim(), pwdCtrl.text.trim());
            
            if (registroOk == true){
              socketService.connect();
              Navigator.pushReplacementNamed(context, 'usuarios');
            } else {
              mostrarAlerta(context, 'Registro incorrecto', registroOk);
            }

          },)

        ],
      ),
    );
  }
}