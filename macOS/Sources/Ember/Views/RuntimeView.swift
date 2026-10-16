import SwiftUI

struct RuntimeView: View {
    let core: CoreStore

    var body: some View {
        Form {
            Section("Rust core") {
                LabeledContent("Connection", value: core.snapshot == nil ? "Unavailable" : "Connected")
                if let snapshot = core.snapshot {
                    LabeledContent("Core version", value: snapshot.version)
                    LabeledContent("Bridge API", value: String(snapshot.bridgeApiVersion))
                    LabeledContent("Platform", value: snapshot.platformDescription)
                }
            }

            Section("Compatibility runtime") {
                LabeledContent("Installation", value: "Not installed")
                Text("This build does not bundle or download Wine, graphics translators, or Steam. Runtime installation and integrity verification are the next milestone.")
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
    }
}
