var partidaModel = require("../models/partidaModel");

function registrar(req, res) {
    var idUsuario = req.body.idUsuario;
    var acertos = req.body.acertos;
    var jogadas = req.body.jogadas;
    var tempo = req.body.tempo;

    if (!idUsuario || acertos == null || jogadas == null || tempo == null) {
        res.status(400).send("Dados incompletos para registrar partida.");
        return;
    }

    partidaModel.registrarResultado(idUsuario, acertos, jogadas, tempo)
        .then(function (resultado) {
            res.status(201).json({ message: "Resultado registrado", resultado: resultado });
        })
        .catch(function (erro) {
            console.log("Erro ao registrar partida:", erro);
            res.status(500).json(erro);
        });
}

function listarPorUsuario(req, res) {
    var idUsuario = req.params.idUsuario;

    partidaModel.listarPorUsuario(idUsuario)
        .then(function (resultado) {
            res.json(resultado);
        })
        .catch(function (erro) {
            console.log("Erro ao listar partidas:", erro);
            res.status(500).json(erro);
        });
}

function dashboard(req, res) {
    var idUsuario = req.params.idUsuario;

    partidaModel.dashboard(idUsuario)
        .then(function (resultado) {
            res.json(resultado);
        })
        .catch(function (erro) {
            console.log("Erro no dashboard:", erro);
            res.status(500).json(erro);
        });
}

module.exports = {
    registrar,
    listarPorUsuario,
    dashboard
};