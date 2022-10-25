//
//  LauncherUI.swift
//  OrzMC
//
//  Created by joker on 2022/10/19.
//

import SwiftUI

struct LauncherUI: View {
    
    @EnvironmentObject private var appModel: LauncherModel
    
    @Environment(\.scenePhase) var scenePhase
    
    static var appFirstLaunched = true
    
    var body: some View {
        LauncherUIBackground()
            .overlay {
                Rectangle()
                    .foregroundColor(.black)
                    .blur(radius: 10)
                    .opacity(0.2)
            }
            .overlay(alignment: .topTrailing) {
                LauncherUIButton(title:"关闭", imageSystemName: "power.circle") {
                    exit(0)
                }
                .padding()
            }
            .overlay(alignment: .topLeading) {
                LauncherUserLoginArea()
            }
            .overlay(alignment: .bottomLeading) {
                LauncherGameVersionPickerView()
            }
            .frame(width: appModel.windowSize.width, height: appModel.windowSize.height)
            .alert(appModel.alertMessage ?? "", isPresented: $appModel.showAlert) {
                Button(appModel.alertActionTip) {
                    
                }
            }
            .onChange(of: scenePhase) { phase in
                if phase == .active && Self.appFirstLaunched {
                    appModel.loadDbClientInfoItem()
                    Self.appFirstLaunched = false
                }
            }
    }
}

struct LauncherUI_Previews: PreviewProvider {
    static var previews: some View {
        LauncherUI()
            .environmentObject(LauncherModel.mockModel)
    }
}

