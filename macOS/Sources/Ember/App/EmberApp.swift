import SwiftUI

@main
struct EmberApp: App {
    @ViewState private var core = CoreStore()
    @AppStorage("appearance") private var appearance = "system"

    var body: some Scene {
        WindowGroup {
            ContentView(core: core)
                .frame(minWidth: 820, minHeight: 560)
                .tint(.orange)
                .preferredColorScheme(colorScheme)
        }
        .defaultSize(width: 1080, height: 720)

        Settings {
            SettingsView()
        }
    }

    private var colorScheme: ColorScheme? {
        switch appearance {
        case "light": .light
        case "dark": .dark
        default: nil
        }
    }
}
