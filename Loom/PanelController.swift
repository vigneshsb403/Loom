//
//  PanelController.swift
//  Loom
//

import AppKit
import Combine
import SwiftUI

final class PanelState: ObservableObject {
    @Published var isPinned = false
}

final class PanelController {
    private let panel: NotePanel
    private let state = PanelState()
    private let store: NoteStore
    private var clickMonitor: Any?

    init(store: NoteStore) {
        self.store = store
        panel = NotePanel(contentRect: NSRect(x: 0, y: 0, width: 400, height: 300))
        let root = NoteView(store: store, state: state)
        // AppKit-native glass so the system knows the window's rounded shape.
        let glass = NSGlassEffectView()
        glass.cornerRadius = 16
        glass.contentView = NSHostingView(rootView: root)
        panel.contentView = glass

        // The window's frame view draws the square key-window outline at the
        // frame bounds; rounding its layer clips that outline to the glass shape.
        if let frameView = panel.contentView?.superview {
            frameView.wantsLayer = true
            frameView.layer?.cornerRadius = 16
            frameView.layer?.cornerCurve = .continuous
            frameView.layer?.masksToBounds = true
        }
        panel.onCancel = { [weak self] in self?.hide() }
    }

    func toggle(relativeTo button: NSStatusBarButton?) {
        if panel.isVisible {
            hide()
        } else {
            show(relativeTo: button)
        }
    }

    private func show(relativeTo button: NSStatusBarButton?) {
        if let buttonWindow = button?.window {
            let buttonFrame = buttonWindow.frame
            var x = buttonFrame.midX - panel.frame.width / 2
            let y = buttonFrame.minY - panel.frame.height - 6
            if let screen = buttonWindow.screen {
                let visible = screen.visibleFrame
                x = min(max(x, visible.minX + 8), visible.maxX - panel.frame.width - 8)
            }
            panel.setFrameOrigin(NSPoint(x: x, y: y))
        }
        panel.makeKeyAndOrderFront(nil)
        panel.invalidateShadow()
        disableFocusRings()
        installClickMonitor()
        NotificationCenter.default.post(name: .loomPanelDidShow, object: nil)
    }

    private func hide() {
        removeClickMonitor()
        panel.orderOut(nil)
        store.flush()
    }

    private func disableFocusRings() {
        func walk(_ view: NSView) {
            view.focusRingType = .none
            view.subviews.forEach(walk)
        }
        if let content = panel.contentView { walk(content) }
        // SwiftUI can create the editor's AppKit views lazily; sweep again next runloop.
        DispatchQueue.main.async { [weak self] in
            if let content = self?.panel.contentView { walk(content) }
        }
    }

    private func installClickMonitor() {
        guard clickMonitor == nil else { return }
        // Global monitors never see own-app events, so clicks inside the panel
        // or on the status item can't trigger this.
        clickMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
            guard let self, !self.state.isPinned else { return }
            self.hide()
        }
    }

    private func removeClickMonitor() {
        if let monitor = clickMonitor {
            NSEvent.removeMonitor(monitor)
            clickMonitor = nil
        }
    }
}
