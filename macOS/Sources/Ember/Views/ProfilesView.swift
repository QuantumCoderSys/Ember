import SwiftUI

struct ProfilesView: View {
    let count: Int?

    var body: some View {
        ContentUnavailableView {
            Label("Build a tested catalog", systemImage: "slider.horizontal.3")
        } description: {
            Text("\(count.map(String.init) ?? "—") profiles in the bundled catalog.\nGame profiles will capture tested runtime versions, settings, and benchmark evidence. No games have been validated yet.")
        }
        .padding(32)
    }
}
