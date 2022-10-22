//
//  LauncherGameVersionPickerView.swift
//  OrzMC
//
//  Created by joker on 2022/10/21.
//

import SwiftUI

struct LauncherGameVersionPickerView: View {
    
    @EnvironmentObject private var appModel: LauncherModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading){
                    if !appModel.versions.isEmpty {
                        HStack {
                            Picker(selection: $appModel.selectedVersion, label: Text("游戏版本").bold()) {
                                ForEach(appModel.versions, id: \.self) {
                                    Text($0).tag($0)
                                }
                            }
                            .frame(maxWidth: 200)
                            LauncherUIButton(imageSystemName: "arrow.clockwise") {
                                Task {
                                    await appModel.fetchGameVersions()
                                }
                            }
                        }
                    }
                    LauncherUIButton(title:"设置", imageSystemName: "gearshape")
                }
            }
            
            if !appModel.launcherProgress.isZero {
                Divider().frame(height: 10)
                LauncherProgressView()
            }
        }
        .padding()
        .task {
            await appModel.fetchGameVersions()
        }
    }
}

struct GameVersionPickerView_Previews: PreviewProvider {
    static var previews: some View {
        LauncherGameVersionPickerView()
            .environmentObject(mockAppModel)
    }
}
