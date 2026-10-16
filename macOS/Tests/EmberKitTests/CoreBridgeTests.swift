import EmberKit
import Testing

@Test("Swift decodes and releases real Rust snapshots")
func swiftDecodesAndReleasesRealRustSnapshots() throws {
    for _ in 0..<32 {
        let snapshot = try CoreBridge.snapshot()
        #expect(snapshot.bridgeApiVersion == 1)
        #expect(snapshot.operatingSystem == "macos")
        #expect(!snapshot.architecture.isEmpty)
        #expect(snapshot.runtimeStatus == .notInstalled)
        #expect(snapshot.profileCount >= 0)
    }
}
