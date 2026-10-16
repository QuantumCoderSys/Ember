import SwiftUI

struct SidebarView: View {
    @Binding var selection: Destination?
    let version: String?

    var body: some View {
        List(selection: $selection) {
            Section("Workspace") {
                ForEach(Destination.allCases) { destination in
                    Label(destination.rawValue, systemImage: destination.symbol)
                        .tag(destination)
                }
            }
        }
        .listStyle(.sidebar)
        .safeAreaInset(edge: .top) {
            HStack(spacing: 10) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 26))
                    .foregroundStyle(.orange)
                    .accessibilityHidden(true)
                Text("Ember")
                    .font(.title2.weight(.semibold))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Development build")
                    .font(.caption.weight(.medium))
                Text("v\(version ?? "—") · Rust + SwiftUI")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
    }
}
