import SwiftUI

struct TrainingHostView: View {
    @EnvironmentObject var store: AppStore
    @State private var selectedTab: Int = 0
    @State private var showPrograms = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Раздел", selection: $selectedTab) {
                    Text("Рабочий стол").tag(0)
                    Text("Тренировки").tag(1)
                    Text("Диета").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom, 8)

                TabView(selection: $selectedTab) {
                    DashboardView()
                        .tag(0)
                    
                    AllWorkoutsView()
                        .tag(1)

                    Text("Раздел 'Диета' в разработке")
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle("Тренировки")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "clock")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showPrograms = true }) {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            }
            .sheet(isPresented: $showPrograms) {
                MyProgramsView()
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}
