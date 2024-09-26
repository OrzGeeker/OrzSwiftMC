//
//  SettingsView.swift
//  OrzMC
//
//  Created by wangzhizhou on 2024/9/26.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(SettingsModel.self) private var model
        
    var body: some View {
        @Bindable var model = model
        
        VStack(spacing: 20) {
            GroupBox {
                VStack(alignment: .leading) {
                    HStack {
                        Toggle(isOn: $model.enableJVMDebugger) {
                            Text("远程 JVM 调试")
                        }
                        .onChange(of: model.enableJVMDebugger) {
                            if model.enableJVMDebugger, model.jvmDebuggerArgs.isEmpty {
                                model.jvmDebuggerArgs = Constants.defaultJVMDebuggerArgs
                            }
                        }
                        Spacer()
                    }
                    
                    TextField(text: $model.jvmDebuggerArgs, prompt: Text(Constants.defaultJVMDebuggerArgs)) {
                    }
                    .textFieldStyle(.roundedBorder)
                    .disabled(!model.enableJVMDebugger)
                }
            } label: {
                Label("Server", systemImage: "xserve")
                    .font(.title)
            }
            
//            GroupBox {
//                HStack {
//                    Spacer()
//                }
//            } label: {
//                Label("Client", systemImage: "macbook")
//                    .font(.title)
//            }

            Spacer()
        }
        .padding()
        .frame(width: 600, height: 400)
    }
}

#Preview {
    SettingsView()
        .environment(SettingsModel())
}
