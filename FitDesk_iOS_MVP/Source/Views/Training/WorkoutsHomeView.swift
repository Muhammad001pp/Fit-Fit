import SwiftUI

struct WorkoutsHomeView: View {
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        DashboardView()
                        .background(Color(.systemGroupedBackground))
    }
}