//
//  aram_mayhemApp.swift
//  aram_mayhem
//
//  Created by Sergio Gelves on 3/10/26.
//

import SwiftUI

enum AppTab {
    case anvils
    case augments
}

@MainActor
final class Router: ObservableObject {
    @Published var selection: AppTab = .anvils
    @Published var anvilsPath = NavigationPath()
    @Published var augmentsPath = NavigationPath()
}

@main
struct aram_mayhemApp: App {

    @StateObject private var router = Router()

    private var tabSelection: Binding<AppTab> {
        Binding(
            get: { router.selection },
            set: { newValue in
                if newValue == router.selection {
                    switch newValue {
                    case .anvils: router.anvilsPath = NavigationPath()
                    case .augments: router.augmentsPath = NavigationPath()
                    }
                }
                router.selection = newValue
            }
        )
    }

    var body: some Scene {

        WindowGroup {

            TabView(selection: $router.selection) {

                NavigationStack(path: $router.anvilsPath) {
                    AnvilsView()
                }
                .navigationTitle("Anvils")
                .tabItem {
                    Label("Anvils", systemImage: "hammer")
                }
                .tag(AppTab.anvils)

                NavigationStack(path: $router.augmentsPath) {
                    AugnmentsView()
                }
                .navigationTitle("Augments")
                .tabItem {
                    Label("Augments", systemImage: "wand.and.stars.inverse")
                }
                .tag(AppTab.augments)
            }
            .toolbarBackground(.clear, for: .tabBar)

        }
    }
}
