import SwiftUI

func getAssetColorHex(color: Color, environment: EnvironmentValues) -> String {
  let c: String = "\(color.resolve(in: environment))"
  return String(c[c.startIndex..<c.index(c.startIndex, offsetBy: 7)])
}

func getAssetColorRgb(color: Color, environment: EnvironmentValues) -> String {
  let c: String = "\(color.resolve(in: environment))"
  let r = String(c[c.index(c.startIndex, offsetBy: 1)..<c.index(c.startIndex, offsetBy: 3)])
  let g = String(c[c.index(c.startIndex, offsetBy: 3)..<c.index(c.startIndex, offsetBy: 5)])
  let b = String(c[c.index(c.startIndex, offsetBy: 5)..<c.index(c.startIndex, offsetBy: 7)])
  return
    "rgb(\(UInt32(r, radix: 16) ?? 0), \(UInt32(g, radix: 16) ?? 0), \(UInt32(b, radix: 16) ?? 0))"
}

func getForeColor(color: Color, environment: EnvironmentValues) -> Color {
  let c = color.resolve(in: environment)
  return (c.red * 0.299 + c.green * 0.587 + c.blue * 0.114) > 0.5 ? Color.black : Color.white
}

let rectL: CGFloat = 20
let longRectL: CGFloat = 4 * rectL

let paletteL: CGFloat = 18 * rectL

let popoverRect: (CGFloat, CGFloat) = (150, 80)
let offsetToTop: CGFloat = -(popoverRect.1 + rectL / 2)
let offsetToBottom: CGFloat = rectL + rectL / 2
let offsetInlineShort: CGFloat = rectL / 2 - popoverRect.0 / 2
let offsetInlineLong: CGFloat = longRectL / 2 - popoverRect.0 / 2
