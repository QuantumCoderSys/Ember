import CEmberCore
import Foundation

public enum CoreBridgeError: LocalizedError {
    case unavailable
    case unsupportedAPI(UInt32)

    public var errorDescription: String? {
        switch self {
        case .unavailable:
            "Ember could not read the Rust core status."
        case .unsupportedAPI(let version):
            "The Rust core uses an unsupported bridge version (\(version)). Rebuild both components."
        }
    }
}

public enum CoreBridge {
    public static func snapshot() throws -> CoreSnapshot {
        guard let pointer = ember_core_snapshot_json() else {
            throw CoreBridgeError.unavailable
        }
        defer { ember_core_string_free(pointer) }
        let data = Data(String(cString: pointer).utf8)
        let snapshot = try JSONDecoder().decode(CoreSnapshot.self, from: data)
        guard snapshot.bridgeApiVersion == 1 else {
            throw CoreBridgeError.unsupportedAPI(snapshot.bridgeApiVersion)
        }
        return snapshot
    }
}
