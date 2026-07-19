//
//  NoteView.swift
//  Loom
//

import SwiftUI

extension Notification.Name {
    static let loomPanelDidShow = Notification.Name("loomPanelDidShow")
}

struct NoteView: View {
    @ObservedObject var store: NoteStore
    @ObservedObject var state: PanelState
    @FocusState private var editorFocused: Bool
    @State private var justSaved = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            TextEditor(text: $store.text)
                .font(.custom("Monaco", size: 14))
                .scrollContentBackground(.hidden)
                .focusEffectDisabled()
                .focused($editorFocused)
                .padding(.top, 34)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)

            HStack(spacing: 12) {
                Button {
                    store.saveSnapshot()
                    withAnimation { justSaved = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation { justSaved = false }
                    }
                } label: {
                    Image(systemName: justSaved ? "checkmark" : "square.and.arrow.down")
                        .contentTransition(.symbolEffect(.replace))
                        .foregroundStyle(justSaved ? AnyShapeStyle(.green) : AnyShapeStyle(.secondary))
                }
                .help("Save note")

                Button {
                    state.isPinned.toggle()
                } label: {
                    Image(systemName: state.isPinned ? "pin.fill" : "pin")
                }
                .help("Stay on screen")
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
            .padding(12)
        }
        .frame(width: 400, height: 300)
        .onReceive(NotificationCenter.default.publisher(for: .loomPanelDidShow)) { _ in
            editorFocused = true
        }
        .onAppear { editorFocused = true }
    }
}
