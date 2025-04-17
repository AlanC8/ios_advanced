import SwiftUI
import UIKit
import Combine

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension Color {
    static var systemBackground: Color {
        Color(UIColor.systemBackground)
    }
    
    static var systemGray6: Color {
        Color(UIColor.systemGray6)
    }
    
    static var label: Color {
        Color(UIColor.label)
    }
    
    static var secondaryLabel: Color {
        Color(UIColor.secondaryLabel)
    }
}

extension TextField {
    func autocapitalization(_ style: UITextAutocapitalizationType) -> TextField {
        self
    }
}
