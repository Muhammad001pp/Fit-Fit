
import SwiftUI

struct ReferenceHomeView: View {
    @EnvironmentObject var store: AppStore
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Упражнения") { MusclesList() }
                NavigationLink("Спортивное питание") { ReferenceList(title: "Спортивное питание", items: store.reference.first(where: { $0.title == "Спортивное питание" })?.items ?? []) }
                NavigationLink("Состав и калорийность продуктов") { ReferenceList(title: "Калорийность продуктов", items: store.reference.first(where: { $0.title == "Калорийность продуктов" })?.items ?? []) }
                NavigationLink("Фармакология") { ReferenceList(title: "Фармакология", items: store.reference.first(where: { $0.title == "Фармакология" })?.items ?? []) }
                NavigationLink("Энциклопедия") { ReferenceList(title: "Энциклопедия", items: store.reference.first(where: { $0.title == "Энциклопедия" })?.items ?? []) }
            }.navigationTitle("Справочник")
        }
    }
}

struct MusclesList: View {
    @EnvironmentObject var store: AppStore
    var body: some View {
        List {
            ForEach(MuscleGroup.allCases) { mg in
                NavigationLink(mg.rawValue) { ExerciseLibraryView(group: mg) }
            }
        }.navigationTitle("Упражнения")
    }
}

struct ExerciseLibraryView: View {
    @EnvironmentObject var store: AppStore
    let group: MuscleGroup
    var body: some View {
        List(store.exercises.filter{ $0.group == group }) { ex in
            NavigationLink(ex.title) { ExerciseDetailView(exercise: ex) }
        }.navigationTitle(group.rawValue)
    }
}

struct ReferenceList: View {
    let title: String
    let items: [ReferenceItem]
    var body: some View {
        List(items) { item in
            NavigationLink(item.title) { ScrollView { Text(item.body).padding() }.navigationTitle(item.title) }
        }.navigationTitle(title)
    }
}
