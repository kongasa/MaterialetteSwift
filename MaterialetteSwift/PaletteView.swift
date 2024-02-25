import SwiftUI

struct PaletteView: View {
  @State var hoverColor: Color?
  @State var hoverColorName: String?
  @State var copyTextVisible = false
  static let c14 = [
    "red", "pink", "purple", "deepPurple", "indigo", "blue", "lightBlue", "teal", "cyan", "green",
    "lightGreen", "lime", "yellow", "amber", "orange", "deepOrange",
  ]
  static let c10 = ["gray", "blueGray", "brown"]
  static let baw = [true, false, nil]
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack {
        Text("Hex").padding(.leading, 5)
        if hoverColor != nil && hoverColorName != nil {
          Rectangle()
            .fill(hoverColor!)
            .frame(width: 20, height: 20)
            .contentShape(Rectangle())
          Text(hoverColorName ?? "")
        }
        Spacer()
        Text("copied!")
          .opacity(copyTextVisible ? 1 : 0)
        Button(action: { NSApplication.shared.terminate(nil) }) {
          Image(systemName: "power")
        }
      }
      Divider()
      Grid(alignment: .top, horizontalSpacing: 0, verticalSpacing: 0) {
        ForEach(0..<16) { i in
          ColorRowView(
            color: PaletteView.c14[i], mainColor: "500", showAColor: true, pendingBAW: nil,
            hoverColor: $hoverColor, hoverColorName: $hoverColorName,
            copyTextVisible: $copyTextVisible)
        }
        ForEach(0..<3) { i in
          ColorRowView(
            color: PaletteView.c10[i], mainColor: "500", showAColor: false,
            pendingBAW: PaletteView.baw[i], hoverColor: $hoverColor,
            hoverColorName: $hoverColorName, copyTextVisible: $copyTextVisible)
        }
      }
    }
    .background(.white)

  }
}

#Preview {
  PaletteView()
}
