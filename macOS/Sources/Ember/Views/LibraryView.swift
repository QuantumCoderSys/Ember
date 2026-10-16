import SwiftUI

struct LibraryView: View {
    let core: CoreStore

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Your next session starts here.")
                    .font(.largeTitle.weight(.semibold))
                Text("A Mac-first home for your Windows Steam games.")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            ContentUnavailableView {
                Label("A fresh library", systemImage: "gamecontroller")
            } description: {
                Text("Steam installation and game launching are not available in this build.\nEmber's native app and Rust core are connected and ready for development.")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            GroupBox {
                HStack(spacing: 12) {
                    Image(systemName: core.snapshot == nil ? "exclamationmark.circle" : "checkmark.circle.fill")
                        .foregroundStyle(core.snapshot == nil ? .red : .green)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(core.snapshot == nil ? "Core unavailable" : "Rust core connected")
                            .font(.headline)
                        Text(core.snapshot?.platformDescription ?? "Use Refresh to retry the connection.")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("Runtime not installed")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .padding(8)
            }
        }
        .padding(32)
    }
}
