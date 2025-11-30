var express = require("express");
var router = express.Router();

var partidaController = require("../controllers/partidaController");

router.post("/registrar", partidaController.registrar);
router.get("/listar/:idUsuario", partidaController.listarPorUsuario);
router.get("/dashboard/:idUsuario", partidaController.dashboard);

module.exports = router;
