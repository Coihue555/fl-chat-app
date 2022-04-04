

class Usuario {
  final bool online;
  final String email;
  final String nombre;
  final String uid;

  Usuario({
    this.online = false,
    required this.email,
    required this.nombre,
    required this.uid,
  });

}