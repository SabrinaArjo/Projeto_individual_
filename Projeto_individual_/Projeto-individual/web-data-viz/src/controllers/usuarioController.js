var usuarioModel = require("../models/usuarioModel");

function autenticar(req, res) {
    var email = req.body.email;
    var senha = req.body.senha;

    if (email == undefined || senha == undefined) {
        res.status(400).send("Email ou senha indefinidos!");
        return;
    }

    usuarioModel.autenticar(email, senha)
        .then(function (resultado) {
            if (resultado.length == 1) {
                res.json(resultado[0]);
            } else {
                res.status(403).send("Email e/ou senha inválidos");
            }
        })
        .catch(function (erro) {
            console.log("Erro no login:", erro);
            res.status(500).json(erro);
        });
}

function cadastrar(req, res) {
    var nome = req.body.nome;
    var email = req.body.email;
    var senha = req.body.senha;

    if (!nome || !email || !senha) {
        res.status(400).send("Campos incompletos!");
        return;
    }

    usuarioModel.cadastrar(nome, email, senha)
        .then(function (resultado) {
            res.json(resultado);
        })
        .catch(function (erro) {
            console.log("Erro no cadastro:", erro);
            res.status(500).json(erro);
        });
}

module.exports = {
    autenticar,
    cadastrar
};