const { WebSocketServer } = require('ws');

const PORT = Number(process.env.PORT) || 8080;
const server = new WebSocketServer({ port: PORT });

server.on('connection', (ws) => {
    ws.on('message', (message) => {
        server.clients.forEach((client) => {
            if (client !== ws && client.readyState === client.OPEN) {
                client.send(message);
            }
        });
    });
});

console.log(`RIBsTreeViewer WebSocket relay listening on ws://0.0.0.0:${PORT}`);
