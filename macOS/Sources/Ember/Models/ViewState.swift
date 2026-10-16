import SwiftUI

// Explicitly select the property wrapper: SDK 27 also exports a State macro,
// whose SwiftUIMacros plugin is absent in some Command Line Tools installations.
// This alias uses the public wrapper and remains compatible with older SDKs.
typealias ViewState<Value> = SwiftUI.State<Value>
