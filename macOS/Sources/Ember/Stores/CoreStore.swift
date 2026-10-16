import EmberKit
import Observation

@MainActor
@Observable
final class CoreStore {
    private(set) var snapshot: CoreSnapshot?
    private(set) var errorMessage: String?

    init() {
        refresh()
    }

    func refresh() {
        do {
            snapshot = try CoreBridge.snapshot()
            errorMessage = nil
        } catch {
            snapshot = nil
            errorMessage = error.localizedDescription
        }
    }
}
