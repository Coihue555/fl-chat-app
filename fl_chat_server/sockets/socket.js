const { io }= require('../index');
const { comprobarJWT } = require('../helpers/jwt');
const { usuarioConectado, usuarioDesconectado } = require('../controllers/socket')

//Mensajes de sockets
io.on('connection', (client) => {
    console.log('Cliente conectado');
    const [valido, uid] = comprobarJWT(client.handshake.headers['x-token']);
    //Verificar autenticacion
    if(!valido){return client.disconnect();}

    //Cliente autenticado
    usuarioConectado(uid);

    //Ingresar el usuario a una sala especifica
    client.join(uid);

    //Escuchar del cliente el mensaje-personal
    client.on('mensaje-personal', (payload) => { 
        console.log(payload);

        io.to( payload.para ).emit('mensaje-personal', payload);
    });

    
    
    client.on('disconnect', () => { 
        usuarioDesconectado(uid);
    });

  });