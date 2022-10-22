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
                            VStack(alignment: .leading) {
                                HStack {
                                    Picker(selection: $appModel.selectedVersion, label: Text("游戏版本").bold()) {
                                        ForEach(appModel.versions, id: \.self) {
                                            Text($0).tag($0)
                                        }
                                    }
                                    LauncherUIButton(imageSystemName: "arrow.clockwise") {
                                        Task {
                                            await appModel.fetchGameVersions()
                                        }
                                    }
                                }
                                if appModel.profileItems.count > 1 {
                                    Picker(selection: $appModel.selectedProfileItem, label: Text("启动方式").bold()) {
                                        ForEach(appModel.profileItems, id: \.self) {
                                            Text($0).tag($0)
                                        }
                                    }
                                    .onReceive(appModel.$selectedVersion) { selectedVersion in
                                        Task {
                                            try await appModel.refreshProfileItems(for: selectedVersion)
                                        }
                                    }
                                    .onChange(of: appModel.selectedProfileItem) { selectedProfileItem in
                                        appModel.chooseProfileItem(selectedProfileItem)
                                    }
                                }
                            }
                            .frame(maxWidth: 200)
                        }
                    }
                    LauncherUIButton(title:"设置", imageSystemName: "gearshape")
                }
            }
            
            if appModel.launcherProgress == 1 {
                Text("资源已下载完成，游戏启动中，请稍等......")
            }
            else if !appModel.launcherProgress.isZero {
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
            .environmentObject(mockModel)
    }
}
