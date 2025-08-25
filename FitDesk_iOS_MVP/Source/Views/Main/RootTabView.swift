
import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            TrainingHostView()
                .tabItem { Label("Тренировки", systemImage: "dumbbell") }
            ReferenceHomeView()
                .tabItem { Label("Справочник", systemImage: "book") }
            AnalyticsView()
                .tabItem { Label("Аналитика", systemImage: "chart.pie") }
            MoreView()
                .tabItem { Label("Ещё", systemImage: "ellipsis.circle") }
        }
    }
}
