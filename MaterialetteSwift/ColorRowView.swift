import SwiftUI

enum CopyTextFormat: String {
  case Hex = "HEX"
  case Rgb = "RGB"
}

struct ColorRowView: View {
  @Environment(\.self) var environment
  let color: String
  let mainColor: String
  let showAColor: Bool
  let pendingBAW: Bool?
  let rowIndex: Int?
  @Binding var hoverColor: Color?
  @Binding var hoverColorName: String?
  @Binding var hoverColorLevel: String?
  @Binding var hoverColorCoor: (CGFloat, CGFloat)?
  @Binding var hoverOverLongBlock: Bool?
  @Binding var copyTextVisible: Bool
  @Binding var copyTextFormat: CopyTextFormat
  @State var leadingTextHovering = false
  @State var leadingBlockHovering = false

  func getColorName(color: Color) -> String {
    return copyTextFormat == .Hex
      ? getAssetColorHex(color: color, environment: environment)
      : getAssetColorRgb(color: color, environment: environment)
  }

  func tinyBox(color: Color, level: String?, colIndex: Int?) -> some View {
    let colorName = getColorName(color: color)
    return Rectangle()
      .fill(color)
      .frame(width: rectL, height: rectL)
      .contentShape(Rectangle())
      .onTapGesture {
        copyColorText(color: color)
      }.onHover(perform: { hovering in
        if hovering {
          hoverColor = color
          hoverColorName = colorName
          hoverColorLevel = level
          hoverColorCoor = (CGFloat((colIndex ?? 0)) * rectL, CGFloat((rowIndex ?? 0)) * rectL)
          hoverOverLongBlock = false
        } else if hoverColor == color && hoverColorName == colorName {
          hoverColor = nil
          hoverColorName = nil
          hoverColorLevel = nil
          hoverColorCoor = nil
          hoverOverLongBlock = nil
        }
      })
  }

  func copyColorText(color: Color) {
    let c: String = getColorName(color: color)
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
      let mainColorC = Color("Material2Color/\(color.lowercased())/\(mainColor)")
      let mainColorName = getColorName(color: mainColorC)
      Text(color)
        .foregroundStyle(getForeColor(color: mainColorC, environment: environment))
        .onTapGesture {
          copyColorText(color: mainColorC)
        }
        .onHover(perform: { hovering in
          if hovering {
            leadingTextHovering = true
            hoverColor = mainColorC
            hoverColorName = mainColorName
            hoverColorLevel = mainColor
            hoverColorCoor = (0, CGFloat((rowIndex ?? 0)) * rectL)
            hoverOverLongBlock = true
          } else if hoverColor == mainColorC && hoverColorName == mainColorName {
            leadingTextHovering = false
            if !leadingBlockHovering {
              hoverColor = nil
              hoverColorName = nil
              hoverColorLevel = nil
              hoverColorCoor = nil
              hoverOverLongBlock = nil
            }

          }
        })
        .frame(width: 4 * rectL, height: rectL)
        .background(
          Rectangle()
            .fill(mainColorC)
            .contentShape(Rectangle())
            .onTapGesture {
              copyColorText(color: mainColorC)
            }
            .onHover(perform: { hovering in
              if hovering {
                leadingBlockHovering = true
                hoverColor = mainColorC
                hoverColorName = mainColorName
                hoverColorLevel = mainColor
                hoverColorCoor = (0, CGFloat((rowIndex ?? 0)) * rectL)
                hoverOverLongBlock = true
              } else if hoverColor == mainColorC && hoverColorName == mainColorName {
                leadingBlockHovering = false
                if !leadingTextHovering {
                  hoverColor = nil
                  hoverColorName = nil
                  hoverColorLevel = nil
                  hoverColorCoor = nil
                  hoverOverLongBlock = nil
                }
              }
            })
        )

      ForEach(0..<10) { i in
        let boxColorName = "Material2Color/\(color.lowercased())/\(v[i])"
        tinyBox(color: Color(boxColorName), level: v[i], colIndex: 4 + i)

      }
      if showAColor {
        ForEach(0..<4) { i in
          let boxColorName = "Material2Color/\(color.lowercased())/\(vA[i])"
          tinyBox(color: Color(boxColorName), level: vA[i], colIndex: 14 + i)
        }
      } else if pendingBAW != nil {
        let c = Color("Material2Color/\(pendingBAW! ? "white" : "black")")
        let cn = getColorName(color: c)
        Rectangle()
          .fill(c)
          .frame(width: 4 * rectL, height: rectL)
          .contentShape(Rectangle())
          .gridCellColumns(4)
          .onTapGesture {
            copyColorText(color: c)
          }.onHover(perform: { hovering in
            if hovering {
              hoverColor = c
              hoverColorName = cn
              hoverColorLevel = pendingBAW! ? "white" : "black"
              hoverColorCoor = (14 * rectL, CGFloat((rowIndex ?? 0)) * rectL)
              hoverOverLongBlock = true
            } else if hoverColor == c && hoverColorName == cn {
              hoverColor = nil
              hoverColorName = nil
              hoverColorLevel = nil
              hoverColorCoor = nil
              hoverOverLongBlock = nil
            }
          })
      }
    }
  }
}

#Preview {
  Grid(horizontalSpacing: 0, verticalSpacing: 0) {
    ColorRowView(
      color: "red", mainColor: "500", showAColor: true, pendingBAW: nil, rowIndex: nil,
      hoverColor: .constant(nil),
      hoverColorName: .constant(nil), hoverColorLevel: .constant(nil),
      hoverColorCoor: .constant(nil), hoverOverLongBlock: .constant(nil),
      copyTextVisible: .constant(false), copyTextFormat: .constant(.Hex))
    ColorRowView(
      color: "deepPurple", mainColor: "500", showAColor: false, pendingBAW: nil,
      rowIndex: nil, hoverColor: .constant(nil), hoverColorName: .constant(nil),
      hoverColorLevel: .constant(nil), hoverColorCoor: .constant(nil),
      hoverOverLongBlock: .constant(nil), copyTextVisible: .constant(false),
      copyTextFormat: .constant(.Rgb))
  }
}
