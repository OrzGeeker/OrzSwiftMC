//
//  BasicInfo.swift
//  OrzMC
//
//  Created by joker on 2024/4/28.
//

import SwiftUI
import Mojang

struct BasicInfo: View {

    @Environment(GameModel.self) private var model

    var body: some View {
        
        Form {
            
            
            
        }
        .navigationTitle(model.detailTitle)
        .task {
            model.checkRunningServer()
        }
        .toolbar {
            if model.isShowKillAllServerButton {
                ToolbarItem {
                    Button {
                        model.killAllRunningServer()
                    } label: {
                        Text("Kill Running Servers")
                            .foregroundStyle(Color.accentColor)
                            .padding(4)
                            .bold()
                    }
                }
            }
        }
    }
}
