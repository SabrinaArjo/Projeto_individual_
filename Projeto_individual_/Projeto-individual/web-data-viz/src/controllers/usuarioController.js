var usuarioModel = require("../models/usuarioModel");

function autenticar(req, res) {
    var email = req.body.emailServer;
    var senha = req.body.senhaServer;

    if (!email || !senha) {
        res.status(400).send("Email ou senha indefinidos!");
        return;
    }

    usuarioModel.autenticar(email, senha)
        .then(resultado => {
            if (resultado.length == 1) {
                res.json(resultado[0]);
            } else {
                res.status(403).send("Email e/ou senha inválidos");
            }
        })
        .catch(erro => {
            console.log("Erro no login:", erro);
            res.status(500).json(erro);
        });
}

function cadastrar(req, res) {
    var nome = req.body.nomeServer;
    var email = req.body.emailServer;
    var senha = req.body.senhaServer;

    if (!nome || !email || !senha) {
        res.status(400).send("Campos incompletos!");
        return;
    }

    usuarioModel.cadastrar(nome, email, senha)
        .then(resultado => res.json(resultado))
        .catch(erro => {
            console.log("Erro no cadastro:", erro);
            res.status(500).json(erro);
        });
}

module.exports = {
    autenticar,
    cadastrar
}