enum Destination: String, CaseIterable, Identifiable {
    case library = "Library"
    case runtime = "Runtime"
    case profiles = "Game profiles"

    var id: Self { self }

    var symbol: String {
        switch self {
        case .library: "square.grid.2x2"
        case .runtime: "cpu"
        case .profiles: "slider.horizontal.3"
        }
    }
}
