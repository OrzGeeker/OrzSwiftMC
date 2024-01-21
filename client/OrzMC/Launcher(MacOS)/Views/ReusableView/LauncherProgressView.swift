//
//  LauncherProgressView.swift
//  OrzMC
//
//  Created by joker on 2022/10/22.
//

import SwiftUI

struct LauncherProgressView: View {
    
    let title: String
    
    let progress: Double
    
    var body: some View {
        HStack {
            if title.isEmpty {
                Text("\(Int(progress * 100))%")
            } else {
                Text("\(title)(\(Int(progress * 100))%)")
            }
            ProgressView(value: progress)
                .progressViewStyle(LauncherProgressViewStyle())
        }
    }
}

struct LauncherProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .tint(.yellow)
    }
}

#Preview {
    Group {
        LauncherProgressView(title: "进度条", progress: 0.2)
        LauncherProgressView(title: "", progress: 0.5)
    }.padding()
}
