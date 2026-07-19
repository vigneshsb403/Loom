//
//  LoomApp.swift
//  Loom
//
//  Created by Vignesh on 18/07/26.
//

import SwiftUI

@main
struct LoomApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
