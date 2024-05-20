//
//  ServerStatusView.swift
//  OrzMC
//
//  Created by joker on 5/17/24.
//

import SwiftUI
struct DisplayConfig {
    let imageName: String
    let foregroundColor: Color
    let animate: Bool
    init(
        _ imageName: String,
        _ foregroundColor: Color,
        _ animate: Bool = true
    ) {
        self.imageName = imageName
        self.foregroundColor = foregroundColor
        self.animate = animate
    }
}
extension ServerStatus {
    var displayConfig: DisplayConfig {
        switch self {
        case .OFFLINE:
            return .init("stop.circle", dangerColor, false)
        case .ONLINE:
            return .init("play.circle", mainColor, false)
        case .STARTING:
            return .init("circle.fill", mainColor)
        case .STOPPING:
            return .init("circle.fill", dangerColor)
        case .RESTARTING:
            return .init("circle.fill", mainColor)
        case .SAVING:
            return .init("circle.fill", dangerColor)
        case .LOADING:
            return .init("circle.fill", mainColor)
        case .CRASHED:
            return .init("exclamationmark.transmission", dangerColor, false)
        case .PENDING:
            return .init("circle.fill", mainColor)
        case .PREPARING:
            return .init("circle.fill", mainColor)
        }
    }
}

struct ServerStatusView: View {
    let status: ServerStatus
    @State private var opacity: Double = 1
    var body: some View {
        let config = status.displayConfig
        Button {

        } label: {
            Image(systemName: config.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .foregroundStyle(config.foregroundColor)
                .opacity(opacity)
                .animation(
                    config.animate ? .easeInOut(duration: 1).repeatForever() : nil,
                    value: opacity
                )
        }
        .onChange(of: status, { oldValue, newValue in
            opacity = status.displayConfig.animate ? 0 : 1
        })
    }
}
