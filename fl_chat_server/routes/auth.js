const { Router, response } = require('express');
const router = Router();

router.post('/new', (req, res = response)=>{
    res.json({
        ok: true,
        msg: 'Crear usuario'
    })
})


module.exports = router;