import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fl_chat_app/services/services.dart';
import 'package:fl_chat_app/models/usuarios.dart';


class UsuariosScreen extends StatefulWidget {
   
  const UsuariosScreen({Key? key}) : super(key: key);

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final usuarioService = UsuariosService();

  List<Usuario> usuarios = [];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final authService   = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text(usuario!.nombre, style: const TextStyle(color: Colors.black54),),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app, color: Colors.black54),
          onPressed: (){
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketService.serverStatus.name == 'Online')
            ?  Icon(Icons.check_circle, color: Colors.blue[400],)
            : Icon(Icons.offline_bolt, color: Colors.red[400],),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[300],),
          waterDropColor: Colors.blue.shade300,
        ),
        child: _listViewUsuarios(),
      )
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
      separatorBuilder: (_, i) => const Divider(),
      itemCount: usuarios.length
      );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
        onTap: () {
          final chatService = Provider.of<ChatService>(context, listen: false);
          chatService.usuarioPara = usuario;
          Navigator.pushNamed(context, 'chat');
        },
        title: Text(usuario.nombre),
        subtitle: Text(usuario.email),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[300],
          child: Text(usuario.nombre.substring(0,2)),
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red[300],
            borderRadius: BorderRadius.circular(100)
          ),
        ),
      );
  }

  _cargarUsuarios() async {

    usuarios = await usuarioService.getUsuarios();

    setState(() {   });

    _refreshController.refreshCompleted();
  }




}


