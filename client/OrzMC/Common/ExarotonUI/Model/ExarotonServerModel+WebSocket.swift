//
//  ExarotonServerModel+WebSocket.swift
//  OrzMC
//
//  Created by joker on 2024/5/20.
//

import ExarotonWebSocket
import Starscream

extension ExarotonServerModel {
    func startConnect(for serverId: String) {
        if websocket == nil {
            websocket = ExarotonWebSocketAPI(token: token, serverId: serverId, delegate: self)
        }
        websocket?.client.connect()
    }
    func stopConnect() {
        websocket?.client.disconnect()
    }
}

extension ExarotonServerModel: ExarotonServerEventHandlerProtocol {

    func onReady(serverID: String?) {
        readyServerID = serverID
    }

    func onConnected() {
        isConnected = true
        disconnectedReason = nil
    }

    func onDisconnected(reason: String?) {
        isConnected = false
        disconnectedReason = reason
    }

    func onKeepAlive() {
        // Ignore
    }

    func onStatusChanged(_ info: ExarotonWebSocket.Server?) {
        statusChangedServer = info
    }

    func onStreamStarted(_ stream: ExarotonWebSocket.StreamCategory?) {
        streamStarted = stream
    }

    func onConsoleLine(_ line: String?) {
        consoleLine = line
    }

    func onTick(_ tick: ExarotonWebSocket.Tick?) {
        tickChanged = tick
    }

    func onStats(_ stats: ExarotonWebSocket.Stats?) {
        statsChanged = stats
    }

    func onHeap(_ heap: ExarotonWebSocket.Heap?) {
        heapChanged = heap
    }

    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        // Do Nothing
    }
}
