//
//  GameView.swift
//  OrzMC
//
//  Created by joker on 4/26/24.
//

import SwiftUI
import Mojang

struct GameView: View {
    
    @State private var searchContent: String = ""
    
    @State private var filteredVersions = [Version]()
    
    @State private var showOnlyRelease: Bool = true
    
    @FocusState private var usernameTextFieldFocused: Bool
    
    @State private var enableStartGameButton: Bool = false
    
    @Environment(GameModel.self) private var model
    
    var body: some View {
        @Bindable var model = model
        VStack(alignment: .leading) {
            List(filteredVersions, selection: $model.selectedVersion) { version in
                HStack() {
                    Text(version.id)
                        .font(.system(size: 14))
                        .bold()
                        .padding([.vertical, .leading], 5)
                    
                    Spacer()
                    
                    if !showOnlyRelease {
                        Text(version.type)
                            .bold()
                            .foregroundStyle(version.typeTagColor)
                            .padding([.horizontal], 5)
                            .offset(x: -5)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    guard !model.isLaunchingGame else { return }
                    model.selectedVersion = version
                    usernameTextFieldFocused = model.isClient
                }
                .background(model.selectedVersion == version ? Color.accentColor : .clear)
                .cornerRadius(5)
            }
            .searchable(text: $searchContent, placement: .sidebar)
            .onChange(of: searchContent) {
                refreshList()
            }
            .onChange(of: showOnlyRelease) {
                refreshList()
            }
            .onAppear {
                guard model.versions.isEmpty
                else {
                    return
                }
                reloadList()
            }
            .toolbar {
                ToolbarItemGroup {
                    Toggle(isOn: $showOnlyRelease) {
                        Text("Release Only")
                            .padding(4)
                            .foregroundStyle(showOnlyRelease ? Color.accentColor : Color.gray)
                            .fontWeight(showOnlyRelease ? .medium : .regular)
                    }
                    .toggleStyle(.button)
                    
                    Button(action: {
                        reloadList()
                    }, label: {
                        if model.isFetchingGameVersions {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .controlSize(.small)
                        } else {
                            Image(systemName: "arrow.clockwise")
                        }
                    })
                    .disabled(model.isFetchingGameVersions)
                }
            }
            
            if let selectedVersion = model.selectedVersion {
                VStack(alignment: .leading, spacing: 10) {
                    
                    if model.showJavaVersionArea {
                        Divider()
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Spacer()
                                Text("Java Version")
                                    .foregroundStyle(model.javaVersionTextColor)
                                Spacer()
                            }
                            
                            HStack {
                                Text("Current:")
                                if let currentJavaMajorVersion = model.currentJavaMajorVersion {
                                    Text("\(currentJavaMajorVersion)")
                                }
                                Spacer()
                                Button {
                                    model.fetchCurrentJavaMajorVersion()
                                } label: {
                                    Image(systemName: "arrow.clockwise")
                                }
                            }
                            .foregroundStyle(Color.orange)
                            
                            HStack {
                                Text("Required:")
                                if let requiredJavaMajorVersion = model.selectedGameJavaMajorVersionRequired {
                                    Text("\(requiredJavaMajorVersion)")
                                }
                                if model.javaRuntimeStatus == .invalid {
                                    Spacer()
                                    Link(destination: model.javaInstallationLinkURL) {
                                        Text("Install Java")
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                            }
                            .foregroundStyle(Color.teal)
                            
                        }
                        .font(.headline)
                        .bold()
                    }
                    
                    Divider()
                    HStack() {
                        Text("Game Version:")
                            .font(.headline)
                        
                        Text(selectedVersion.id)
                            .foregroundStyle(Color.accentColor)
                        
                        Spacer()
                        
                        Picker("", selection: $model.gameType) {
                            ForEach(GameModel.GameType.allCases, id: \.self.rawValue) { type in
                                Text(type.rawValue)
                                    .tag(type)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: model.gameType) {
                            usernameTextFieldFocused = model.isClient
                        }
                        .onChange(of: usernameTextFieldFocused) {
                            refreshStartGameButton()
                        }
                        .disabled(model.isLaunchingGame)
                    }
                    .bold()
                    
                    if model.isClient {
                        HStack() {
                            Text("User Name:")
                                .font(.headline)
                                .bold()
                            TextField("Input User Name", text: $model.username)
                                .foregroundStyle(Color.accentColor)
                                .bold()
                                .textFieldStyle(.plain)
                                .textContentType(.username)
                                .autocorrectionDisabled()
                                .textSelection(.disabled)
                                .focused($usernameTextFieldFocused)
                                .onChange(of: model.username) {
                                    refreshStartGameButton()
                                }
                                .onSubmit {
                                    startGame()
                                }
                                .disabled(model.isLaunchingGame)
                        }
                    }
                    
                    HStack() {
                        Spacer()
                        Button {
                            startGame()
                        } label: {
                            Text("Start \(model.gameType.rawValue.capitalized)")
                                .font(.headline)
                                .bold()
                                .padding([.horizontal], 4)
                                .padding([.vertical], 4)
                            
                            if (model.progress > 0 && model.progress < 1) {
                                ProgressView(value: model.progress, total: 1)
                                    .progressViewStyle(.circular)
                                    .controlSize(.small)
                                Text(model.progressDesc)
                            } else if model.progress >= 1 {
                                Image(systemName: "checkmark.seal.fill")
                                    .controlSize(.regular)
                            }
                        }
                        .tint(enableStartGameButton ? Color.accentColor : .gray)
                        .controlSize(.regular)
                        .buttonStyle(.borderedProminent)
                        .disabled(!enableStartGameButton)
                        .keyboardShortcut(.init(.init("b")), modifiers: .command)
                        Spacer()
                    }
                }
                .padding([.horizontal], 10)
                .padding([.bottom], 20)
                .onChange(of: model.isLaunchingGame) {
                    refreshStartGameButton()
                }
            }
        }
    }
}

extension GameView {
    
    func startGame() {
        usernameTextFieldFocused = false
        model.startGame()
    }
    
    func refreshStartGameButton() {
        guard model.selectedVersion != nil
        else {
            enableStartGameButton = false
            return
        }
        enableStartGameButton = !model.isFetchingGameVersions && !model.isLaunchingGame
        if model.isClient {
            enableStartGameButton = !model.username.isEmpty && enableStartGameButton
        }
    }
    
    func reloadList() {
        Task {
            model.isFetchingGameVersions = true
            try await model.fetchGameVersions()
            model.isFetchingGameVersions = false
            await refreshList()
        }
    }
    
    @MainActor
    func refreshList() {
        if searchContent.isEmpty {
            filteredVersions = model.versions
        } else {
            filteredVersions = model.versions.filter { $0.id.contains(searchContent)}
        }
        
        if showOnlyRelease {
            filteredVersions = filteredVersions.filter { $0.type == "release" }
        }
    }
}

#Preview {
    NavigationSplitView {
        GameView()
            .environment(GameModel())
    } detail: {
        Text("Detail")
    }
}

