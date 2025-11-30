var database = require("../database/config");

function registrar(idUsuario, acertos, jogadas, tempo) {
    var instrucaoSql = `
        INSERT INTO partida (fkUsuario, acertos, jogadas, tempo)
        VALUES (${idUsuario}, ${acertos}, ${jogadas}, ${tempo});
    `;
    return database.executar(instrucaoSql);
}

function listarPorUsuario(idUsuario) {
    var instrucaoSql = `
        SELECT 
            idPartida, acertos, jogadas, tempo,
            DATE_FORMAT(dataHora, '%d/%m/%Y %H:%i') AS dataHora
        FROM partida
        WHERE fkUsuario = ${idUsuario}
        ORDER BY dataHora DESC;
    `;
    return database.executar(instrucaoSql);
}

function dashboard(idUsuario) {
    var instrucaoSql = `
        SELECT 
            COUNT(*) AS total_partidas,
            AVG(acertos) AS media_acertos,
            AVG(jogadas) AS media_jogadas,
            MIN(tempo) AS melhor_tempo
        FROM partida
        WHERE fkUsuario = ${idUsuario};
    `;
    return database.executar(instrucaoSql);
}

module.exports = {
    registrar,
    listarPorUsuario,
    dashboard
};
