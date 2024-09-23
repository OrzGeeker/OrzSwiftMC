//
//  ExarotonServerStatusView.swift
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
            return .init("play.circle", mainColor)
        case .STOPPING:
            return .init("stop.circle", dangerColor)
        case .RESTARTING:
            return .init("play.circle", mainColor)
        case .SAVING:
            return .init("stop.circle", dangerColor)
        case .LOADING:
            return .init("play.circle", mainColor)
        case .CRASHED:
            return .init("exclamationmark.transmission", dangerColor, false)
        case .PENDING:
            return .init("play.circle", mainColor)
        case .PREPARING:
            return .init("play.circle", mainColor)
        }
    }
}

struct ExarotonServerStatusView: View {
    let status: ServerStatus
    @State private var opacity: Double = 1
    var body: some View {
        let config = status.displayConfig
        Image(systemName: config.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(config.foregroundColor)
            .opacity(opacity)
            .animation(
                config.animate ? .easeInOut(duration: 0.8).repeatForever() : nil,
                value: opacity
            )
            .onChange(of: status, initial: false) {
                opacity = config.animate ? 0 : 1
            }
    }
}

#Preview {
    
    VStack(spacing: 10) {
        
        ForEach(ServerStatus.allCases, id: \.self) { status in
            
            HStack {
                
                Text("\(status)")
                
                Spacer()
                
                ExarotonServerStatusView(status: status)
                    .frame(width: 24, height: 24)
            }
        }
    }
    .padding()
}
