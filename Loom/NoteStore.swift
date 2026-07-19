//
//  NoteStore.swift
//  Loom
//

import Combine
import Foundation

final class NoteStore: ObservableObject {
    @Published var text: String = "" {
        didSet { scheduleSave() }
    }

    private let directory: URL
    private let currentURL: URL
    private var pendingSave: DispatchWorkItem?

    init() {
        let base = FileManager.default.urls(for: .applicationSupportDirectory,
                                            in: .userDomainMask)[0]
        directory = base.appendingPathComponent("Loom", isDirectory: true)
        try? FileManager.default.createDirectory(at: directory,
                                                 withIntermediateDirectories: true)
        currentURL = directory.appendingPathComponent("current.md")
        text = (try? String(contentsOf: currentURL, encoding: .utf8)) ?? ""
    }

    private func scheduleSave() {
        pendingSave?.cancel()
        let item = DispatchWorkItem { [weak self] in self?.flush() }
        pendingSave = item
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: item)
    }

    func flush() {
        pendingSave?.cancel()
        pendingSave = nil
        try? text.write(to: currentURL, atomically: true, encoding: .utf8)
    }

    func saveSnapshot() {
        flush()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HHmmss"
        let url = directory.appendingPathComponent("Note \(formatter.string(from: Date())).md")
        try? text.write(to: url, atomically: true, encoding: .utf8)
    }
}
