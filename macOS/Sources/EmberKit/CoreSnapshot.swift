import Foundation

public enum RuntimeStatus: String, Decodable, Sendable {
    case notInstalled
}

public struct CoreSnapshot: Decodable, Sendable {
    public let bridgeApiVersion: UInt32
    public let version: String
    public let operatingSystem: String
    public let architecture: String
    public let runtimeStatus: RuntimeStatus
    public let profileCount: Int

    public var platformDescription: String {
        let chip = architecture == "aarch64" ? "Apple silicon" : architecture
        return "\(operatingSystem == "macos" ? "macOS" : operatingSystem) · \(chip)"
    }
}
