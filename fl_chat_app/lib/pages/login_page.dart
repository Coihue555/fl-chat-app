import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
   
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff2f2f2),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _Logo(),
            _Form(),
            _Labels(),
            const Text('Terminos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200))
          ],
        )
      ),
    );
  }
}

class _Logo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170,
        margin: EdgeInsets.only(top:50),
        child: Column(
          children: const [
            Image(image: AssetImage('./assets/tag-logo.png')),
            SizedBox(height: 20,),
            Text('Messenger', style: TextStyle(fontSize: 30))
          ],
        ),
      ),
    );
  }
}


class _Form extends StatefulWidget {

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0,5),
                  blurRadius: 5
                )
              ]
            ),
            child: const TextField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              //obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.mail_outline),
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
               ),
            )
            ),

          ElevatedButton(
            onPressed: (){},
            child: Text('Ingresar')
          )
        ],
      ),
    );
  }
}

class _Labels extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('No tienes cuenta?', style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300)),
          SizedBox(height: 10,),
          Text('Crea una cuenta', style: TextStyle(color: Colors.blue[600], fontSize: 18, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}