
import SwiftUI

@main
struct FitDeskApp: App {
    @StateObject private var store = AppStore()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        TabView {
            TrainingHostView()
                .tabItem {
                    Label("Тренировки", systemImage: "figure.strengthtraining.traditional")
                }

            Text("Лента")
                .tabItem {
                    Label("Лента", systemImage: "list.bullet")
                }

            Text("Сообщения")
                .tabItem {
                    Label("Сообщения", systemImage: "message")
                }

            ReferenceHomeView()
                .tabItem {
                    Label("Справочник", systemImage: "book")
                }

            MoreView()
                .tabItem {
                    Label("Ещё", systemImage: "ellipsis")
                }
        }
        .tint(.cyan) // Основной цвет для активных элементов
    }
}
