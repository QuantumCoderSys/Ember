import SwiftUI

struct ContentView: View {
    let core: CoreStore
    @ViewState private var selection: Destination? = .library

    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selection, version: core.snapshot?.version)
                .navigationSplitViewColumnWidth(min: 190, ideal: 220)
        } detail: {
            Group {
                switch selection ?? .library {
                case .library:
                    LibraryView(core: core)
                case .runtime:
                    RuntimeView(core: core)
                case .profiles:
                    ProfilesView(count: core.snapshot?.profileCount)
                }
            }
            .navigationTitle((selection ?? .library).rawValue)
            .toolbar {
                ToolbarItem {
                    Button("Refresh core status", systemImage: "arrow.clockwise") {
                        core.refresh()
                    }
                    .keyboardShortcut("r", modifiers: .command)
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                if let error = core.errorMessage {
                    Label(error, systemImage: "exclamationmark.triangle")
                        .font(.callout)
                        .foregroundStyle(.red)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.bar)
                }
            }
        }
    }
}
