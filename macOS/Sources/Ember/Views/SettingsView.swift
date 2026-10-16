import SwiftUI

struct SettingsView: View {
    @AppStorage("appearance") private var appearance = "system"

    var body: some View {
        Form {
            Picker("Appearance", selection: $appearance) {
                Text("System").tag("system")
                Text("Light").tag("light")
                Text("Dark").tag("dark")
            }
            .pickerStyle(.segmented)

            Text("Ember is an independent, open-source project for Windows Steam gaming on macOS.")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .formStyle(.grouped)
        .frame(width: 460, height: 170)
        .padding()
    }
}
