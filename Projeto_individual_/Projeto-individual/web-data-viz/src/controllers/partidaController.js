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

    partidaModel.registrar(idUsuario, acertos, jogadas, tempo)
        .then(resultado => res.json(resultado))
        .catch(erro => {
            console.log(erro);
            res.status(500).json(erro);
        });
}

function listarPorUsuario(req, res) {
    var idUsuario = req.params.idUsuario;

    partidaModel.listarPorUsuario(idUsuario)
        .then(resultado => res.json(resultado))
        .catch(erro => {
            console.log(erro);
            res.status(500).json(erro);
        });
}

function dashboard(req, res) {
    var idUsuario = req.params.idUsuario;

    partidaModel.dashboard(idUsuario)
        .then(resultado => res.json(resultado))
        .catch(erro => {
            console.log("Erro no dashboard:", erro);
            res.status(500).json(erro);
        });
}

module.exports = {
    registrar,
    listarPorUsuario,
    dashboard
};
