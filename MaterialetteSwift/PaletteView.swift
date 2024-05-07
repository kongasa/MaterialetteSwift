import SwiftUI

struct PaletteView: View {
  @Environment(\.self) var environment
  @State var hoverColor: Color?
  @State var hoverColorName: String?
  @State var hoverColorLevel: String?
  @State var copyTextVisible = false
  @State var copyTextFormat: CopyTextFormat = .Hex
  @State var hoverOffset: (CGFloat, CGFloat)?
  @State var hoverOverLongBlock: Bool?
  static let c14 = [
    "red", "pink", "purple", "deepPurple", "indigo", "blue", "lightBlue", "teal", "cyan", "green",
    "lightGreen", "lime", "yellow", "amber", "orange", "deepOrange",
  ]
  static let c10 = ["gray", "blueGray", "brown"]
  static let baw = [true, false, nil]
  static let paletteOffset: (CGFloat, CGFloat) = (0, 21)

  func formatColor(c: Color?) -> String? {
    if c == nil {
      return nil
    } else {
      return copyTextFormat == .Hex
        ? getAssetColorHex(color: c!, environment: environment)
        : getAssetColorRgb(color: c!, environment: environment)
    }
  }

  func getComputedOffset() -> (CGFloat, CGFloat) {
    var x: CGFloat =
      PaletteView.paletteOffset.0
      + ((hoverOverLongBlock ?? false) ? offsetInlineLong : offsetInlineShort)
      + (hoverOffset?.0 ?? 0)
    var y: CGFloat = PaletteView.paletteOffset.1 + offsetToTop + (hoverOffset?.1 ?? 0)
    if x < 0 {
      x = 0
    } else if x > (paletteL - popoverRect.0) {
      x = paletteL - popoverRect.0
    }
    if y < PaletteView.paletteOffset.1 {
      y = y - offsetToTop + offsetToBottom
    }
    return (x, y)
  }

  var body: some View {
    ZStack(alignment: .topLeading) {

      VStack(alignment: .leading, spacing: 0) {
        HStack {
          Text(copyTextFormat.rawValue).padding(.leading, 5).frame(width: 40)
          Button(action: {
            copyTextFormat = ((copyTextFormat == .Hex) ? CopyTextFormat.Rgb : CopyTextFormat.Hex)
          }) {
            Image(systemName: "repeat")
          }.keyboardShortcut(.tab, modifiers: [])
          if hoverColor != nil && hoverColorName != nil {
            Rectangle()
              .fill(hoverColor!)
              .frame(width: rectL, height: rectL)
              .contentShape(Rectangle())
            Text(formatColor(c: hoverColor) ?? "")
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
              rowIndex: i, hoverColor: $hoverColor, hoverColorName: $hoverColorName,
              hoverColorLevel: $hoverColorLevel, hoverColorCoor: $hoverOffset,
              hoverOverLongBlock: $hoverOverLongBlock,
              copyTextVisible: $copyTextVisible, copyTextFormat: $copyTextFormat)
          }
          ForEach(0..<3) { i in
            ColorRowView(
              color: PaletteView.c10[i], mainColor: "500", showAColor: false,
              pendingBAW: PaletteView.baw[i], rowIndex: 16 + i, hoverColor: $hoverColor,
              hoverColorName: $hoverColorName, hoverColorLevel: $hoverColorLevel,
              hoverColorCoor: $hoverOffset, hoverOverLongBlock: $hoverOverLongBlock,
              copyTextVisible: $copyTextVisible, copyTextFormat: $copyTextFormat)
          }
        }
      }
      .background(.white)
      if hoverColor != nil {
        let o = getComputedOffset()

        VStack {
          Text(getAssetColorHex(color: hoverColor!, environment: environment))
          Text(getAssetColorRgb(color: hoverColor!, environment: environment))
          Text(hoverColorLevel ?? "?")
        }
        .frame(width: popoverRect.0, height: popoverRect.1)
        .background(hoverColor!)
        .foregroundStyle(getForeColor(color: hoverColor!, environment: environment))
        .offset(x: o.0, y: o.1)
      }

    }

  }
}

#Preview {
  PaletteView()
}
