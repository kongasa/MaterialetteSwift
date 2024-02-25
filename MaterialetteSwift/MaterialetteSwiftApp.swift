import SwiftUI

@main
struct MaterialetteSwiftApp: App {
  var body: some Scene {
    MenuBarExtra("MaterialetteS", systemImage: "paintpalette") {
      PaletteView()
    }
    .menuBarExtraStyle(.window)
  }
}
