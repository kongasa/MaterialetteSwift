import SwiftUI

struct ColorRowView: View {
  @Environment(\.self) var environment
  let color: String
  let mainColor: String
  let showAColor: Bool
  let pendingBAW: Bool?
  @Binding var hoverColor: Color?
  @Binding var hoverColorName: String?
  @Binding var copyTextVisible: Bool

  func getAssetColorHex(color: Color) -> String {
    let c: String = "\(color.resolve(in: environment))"
    return String(c[c.startIndex..<c.index(c.startIndex, offsetBy: 7)])
  }

  func copyHex(color: Color) {
    let c: String = getAssetColorHex(color: color)
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.setString(c, forType: .string)
    withAnimation(.linear(duration: 0)) {
      copyTextVisible = true
    } completion: {
      withAnimation(.easeOut(duration: 2)) {
        copyTextVisible = false
      }
    }
  }
  var body: some View {
    let v: [String] = ["50", "100", "200", "300", "400", "500", "600", "700", "800", "900"]
    let vA: [String] = ["A100", "A200", "A400", "A700"]
    GridRow {
      Button(action: {}) {
        Text(color).frame(minWidth: 80, maxWidth: 80)
      }.buttonStyle(.borderedProminent)
        .tint(Color("Material2Color/\(color.lowercased())/\(mainColor)"))
      ForEach(0..<10) { i in
        let boxColor = Color("Material2Color/\(color.lowercased())/\(v[i])")
        let boxColorHex = getAssetColorHex(color: boxColor)
        Rectangle()
          .fill(Color("Material2Color/\(color.lowercased())/\(v[i])"))
          .frame(width: 20, height: 20)
          .contentShape(Rectangle())
          .onTapGesture {
            copyHex(color: boxColor)
          }.onHover(perform: { hovering in
            if hovering {
              hoverColor = boxColor
              hoverColorName = boxColorHex
            } else if hoverColor == boxColor && hoverColorName == boxColorHex {
              hoverColor = nil
              hoverColorName = nil
            }
          })
      }
      if showAColor {
        ForEach(0..<4) { i in
          let boxColor = Color("Material2Color/\(color.lowercased())/\(vA[i])")
          let boxColorHex = getAssetColorHex(color: boxColor)
          Rectangle()
            .fill(boxColor)
            .frame(width: 20, height: 20)
            .contentShape(Rectangle())
            .onTapGesture {
              copyHex(color: boxColor)
            }.onHover(perform: { hovering in
              if hovering {
                hoverColor = boxColor
                hoverColorName = boxColorHex
              } else if hoverColor == boxColor && hoverColorName == boxColorHex {
                hoverColor = nil
                hoverColorName = nil
              }
            })
        }
      } else if pendingBAW != nil {
        let c = pendingBAW == true ? Color.white : Color.black
        let cn = pendingBAW == true ? "#FFFFFF" : "#000000"
        Rectangle()
          .fill(c)
          .frame(width: 80, height: 20)
          .contentShape(Rectangle())
          .gridCellColumns(4)
          .onTapGesture {
            copyHex(color: c)
          }.onHover(perform: { hovering in
            if hovering {
              hoverColor = c
              hoverColorName = cn
            } else if hoverColor == c && hoverColorName == cn {
              hoverColor = nil
              hoverColorName = nil
            }
          })
      }
    }
  }
}

#Preview {
  Grid(horizontalSpacing: 0, verticalSpacing: 0) {
    ColorRowView(
      color: "red", mainColor: "500", showAColor: true, pendingBAW: nil, hoverColor: .constant(nil),
      hoverColorName: .constant(nil), copyTextVisible: .constant(false))
    ColorRowView(
      color: "deepPurple", mainColor: "500", showAColor: false, pendingBAW: nil,
      hoverColor: .constant(nil), hoverColorName: .constant(nil), copyTextVisible: .constant(false))
  }
}
