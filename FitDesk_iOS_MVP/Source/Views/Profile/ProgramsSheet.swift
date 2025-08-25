
import SwiftUI

struct MyProgramsSheet: View {
    @EnvironmentObject var store: AppStore
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button("ВЫБРАТЬ ГОТОВУЮ ТРЕНИРОВКУ") { }
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                ForEach(store.programs) { p in
                    Button {
                        store.activeProgram = p
                        store.saveAll()
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(p.name).font(.headline)
                            Text("\(p.totalDays) тренировочных дня (\(p.daysPerWeek) тренировки в неделю)").font(.caption).foregroundStyle(.secondary)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .navigationTitle("Мои программы")
        }
    }
}
