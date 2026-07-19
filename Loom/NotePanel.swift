//
//  NotePanel.swift
//  Loom
//

import AppKit

final class NotePanel: NSPanel {
    var onCancel: (() -> Void)?

    init(contentRect: NSRect) {
        super.init(contentRect: contentRect,
                   styleMask: [.borderless, .nonactivatingPanel, .fullSizeContentView],
                   backing: .buffered, defer: false)
        isFloatingPanel = true
        level = .floating
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        backgroundColor = .clear
        isOpaque = false
        hasShadow = true
        hidesOnDeactivate = false
        isReleasedWhenClosed = false
        isMovableByWindowBackground = true
        animationBehavior = .utilityWindow
    }

    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }

    override func becomeKey() {
        super.becomeKey()
        // Recompute the window shape/shadow so the key-window hairline
        // follows the rounded glass instead of the square frame.
        DispatchQueue.main.async { [weak self] in self?.invalidateShadow() }
    }

    override func cancelOperation(_ sender: Any?) {
        onCancel?()
    }
}
