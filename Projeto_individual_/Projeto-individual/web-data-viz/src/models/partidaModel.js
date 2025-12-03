var database = require("../database/config");

function registrarResultado(idUsuario, acertos, jogadas, tempo) {
    var instrucaoInserirPartida = `
        INSERT INTO partida (descricao) VALUES ('Jogo da Memória');
    `;

    return database.executar(instrucaoInserirPartida)
    .then(function(resultadoInsertPartida) {
        var idPartida = resultadoInsertPartida.insertId || (resultadoInsertPartida && resultadoInsertPartida[0] && resultadoInsertPartida[0].insertId) || null;

        var instrucaoUsuarioPartida = `
            INSERT INTO resultado (fkUsuario, fkPartida, acertos, jogadas, tempo)
            VALUES (${idUsuario}, ${idPartida}, ${acertos}, ${jogadas}, ${tempo});
        `;
        return database.executar(instrucaoUsuarioPartida);
    });
}

function listarPorUsuario(idUsuario) {
    var instrucaoSql = `
        SELECT 
            r.idUsuarioPartida,
            p.idPartida,
            p.dtHora AS data_partida,
            r.acertos,
            r.jogadas,
            r.tempo
        FROM resultado r
        JOIN partida p ON p.idPartida = r.fkPartida
        WHERE r.fkUsuario = ${idUsuario}
        ORDER BY r.dataRegistro DESC;
    `;
    return database.executar(instrucaoSql);
}

function dashboard(idUsuario) {
    var instrucaoSql = `
        SELECT 
            COUNT(r.fkPartida) AS total_partidas,
            COALESCE(SUM(r.acertos),0) AS total_acertos,
            COALESCE(SUM(r.jogadas),0) AS total_jogadas,
            ROUND( (COALESCE(SUM(r.acertos),0) / NULLIF(COALESCE(SUM(r.jogadas),0),0)) * 100, 1) AS aproveitamento_percent,
            MIN(r.tempo) AS melhor_tempo,
            AVG(r.tempo) AS tempo_medio
        FROM resultado r
        WHERE r.fkUsuario = ${idUsuario};
    `;
    return database.executar(instrucaoSql);
}

module.exports = {
    registrarResultado,
    listarPorUsuario,
    dashboard
};