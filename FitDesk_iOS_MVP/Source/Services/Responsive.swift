import SwiftUI

extension View {
    /// Expands view to fill and applies a safe full-screen background.
    func fullScreenBackground(_ color: Color = Color(white: 0.97)) -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(color)
            .ignoresSafeArea()
    }
}
