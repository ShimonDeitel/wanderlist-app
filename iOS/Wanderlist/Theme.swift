import SwiftUI

/// Unique visual identity for Wanderlist.
enum Theme {
    static let background = Color(red: 0.141, green: 0.086, blue: 0.204)
    static let accent = Color(red: 0.780, green: 0.490, blue: 1.000)
    static let secondary = Color(red: 0.616, green: 0.396, blue: 0.710)
    static let cardBackground = background.opacity(0.92)

    static let titleFont = Font.system(.title2, design: .serif).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .serif).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .serif)
    static let captionFont = Font.system(.caption, design: .serif)

    static let cornerRadius: CGFloat = 16
    static let spacing: CGFloat = 12
}
