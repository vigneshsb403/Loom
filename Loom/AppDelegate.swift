//
//  AppDelegate.swift
//  Loom
//

import AppKit
import ServiceManagement

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var panelController: PanelController!
    private let hotKey = HotKeyManager()
    private let store = NoteStore()

    func applicationDidFinishLaunching(_ notification: Notification) {
        panelController = PanelController(store: store)

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.button?.image = NSImage(systemSymbolName: "scribble.variable",
                                           accessibilityDescription: "Loom")
        statusItem.button?.action = #selector(togglePanel)
        statusItem.button?.target = self

        hotKey.onHotKey = { [weak self] in self?.togglePanel() }
        hotKey.register()

        registerLoginItem()
    }

    private func registerLoginItem() {
        // Only register the installed copy, not debug builds run from DerivedData.
        guard Bundle.main.bundlePath.hasPrefix("/Applications/") else { return }
        if SMAppService.mainApp.status != .enabled {
            try? SMAppService.mainApp.register()
        }
    }

    @objc private func togglePanel() {
        panelController.toggle(relativeTo: statusItem.button)
    }

    func applicationWillTerminate(_ notification: Notification) {
        store.flush()
    }
}
