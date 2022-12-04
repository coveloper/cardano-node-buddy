//
//  CardanoNodeBuddyApp.swift
//  CardanoNodeBuddy
//
//  Created by Jon Bauer on 12/3/22.
//

import SwiftUI

@main
struct CardanoNodeBuddyApp: App {
    
    var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView(appState: appState)
        }
    }
}
