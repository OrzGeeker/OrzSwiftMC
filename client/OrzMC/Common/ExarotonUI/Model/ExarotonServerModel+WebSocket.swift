//
//  ExarotonServerModel+WebSocket.swift
//  OrzMC
//
//  Created by joker on 2024/5/20.
//

import Foundation
import ExarotonWebSocket
import Starscream
import AnyCodable

extension ExarotonServerModel {
    func startConnect(for serverId: String) {
        if websocket == nil {
            websocket = ExarotonWebSocketAPI(token: token, serverId: serverId, delegate: self)
        }
        websocket?.connect()
    }
    func stopConnect() {
        websocket?.disconnect()
        reset()
    }
    func reset() {
        readyServerID = nil
        isConnected = false
        disconnectedReason = nil
        streamStarted = nil
        streamStopped = nil
        consoleLine = nil
        consoleLines = [String]()
        tickChanged = nil
        statsChanged = nil
        heapChanged = nil
        statusChangedServer = nil
    }

    func startStream(_ stream: StreamCategory, data: AnyCodable? = nil)  {
        try? websocket?.send(message: ExarotonMessage(stream: stream, type: StreamType.start, data: data))
    }

    func sendConsoleCmd(_ cmd: AnyCodable) {
        try? websocket?.send(message: ExarotonMessage(stream: .console, type: StreamType.command, data: cmd))
    }

    func stopStream(_ stream: StreamCategory) {
        try? websocket?.send(message: ExarotonMessage(stream: stream, type: StreamType.stop, data: nil))
    }
}

extension ExarotonServerModel: @preconcurrency ExarotonServerEventHandlerProtocol {

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

    func onStreamStopped(_ stream: StreamCategory?) {
        streamStopped = stream
    }

    func onConsoleLine(_ line: String?) {
        guard let line
        else {
            return
        }
        consoleLine = line
        consoleLines.append(line)
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

    nonisolated func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        // Do Nothing
    }
}
