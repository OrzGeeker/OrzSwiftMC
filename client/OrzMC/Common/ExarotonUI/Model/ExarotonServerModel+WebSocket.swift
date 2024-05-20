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
        tickChanged = nil
        statsChanged = nil
        heapChanged = nil
        statusChangedServer = nil
    }

    func startStream(_ stream: StreamCategory, data: AnyCodable? = nil)  {
        websocket?.send(message: ExarotonMessage(stream: stream, type: StreamType.start, data: data))
    }

    func sendConsoleCmd(_ cmd: String) {
//        let cmdStringData = cmd.data(using: .utf8)
//        websocket?.send(message: ExarotonMessage(stream: .console, type: StreamType.command, data: cmdStringData))
    }

    func stopStream(_ stream: StreamCategory) {
        websocket?.send(message: ExarotonMessage(stream: stream, type: StreamType.stop, data: nil))
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

    func onStreamStopped(_ stream: StreamCategory?) {
        streamStopped = stream
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