
import SwiftUI
import Charts

struct AnalyticsView: View {
    @EnvironmentObject var store: AppStore
    @State private var tab = 0
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("", selection: $tab) { Text("Статистика").tag(0); Text("Замеры").tag(1) }.pickerStyle(.segmented).padding()
                if tab == 0 { StatsTab() } else { MeasurementsTab() }
            }.navigationTitle("Аналитика")
        }
    }
}

struct StatsTab: View {
    @EnvironmentObject var store: AppStore
    var body: some View {
        ScrollView {
            GroupBox("Средняя частота пульса") {
                Chart(store.heartRate) { BarMark(x: .value("Дата", $0.date), y: .value("BPM", $0.bpm)) }.frame(height:220)
            }.padding([.horizontal,.bottom])
            GroupBox("Расход калорий, ккал") {
                Chart(sampleCalories) { BarMark(x: .value("Дата", $0.date), y: .value("ккал", $0.kcal)) }.frame(height:220)
            }.padding([.horizontal,.bottom])
            GroupBox("Поднятый вес, кг") {
                Chart(sampleLifted) { BarMark(x:.value("Дата", $0.date), y:.value("кг", $0.kg)) }.frame(height:220)
            }.padding([.horizontal,.bottom])
        }
    }
    private struct CaloriePoint: Identifiable { let id = UUID(); let date: Date; let kcal: Int }
    private struct LiftPoint: Identifiable { let id = UUID(); let date: Date; let kg: Int }
    private var sampleCalories:[CaloriePoint] { (0..<7).map{ i in .init(date: Calendar.current.date(byAdding: .day, value: -i, to: Date())!, kcal: Int.random(in: 100...600)) } }
    private var sampleLifted:[LiftPoint] { (0..<7).map{ i in .init(date: Calendar.current.date(byAdding: .day, value: -i, to: Date())!, kg: Int.random(in: 0...20000)) } }
}

struct MeasurementsTab: View {
    @EnvironmentObject var store: AppStore
    @State private var showAdd = false
    var body: some View {
        List {
            ForEach(store.measurements.sorted{ $0.date > $1.date }) { m in
                NavigationLink { MeasurementDetail(entry: m) } label: { HStack { Text(m.date, style: .date); Spacer(); Text("Вес: \(m.weight?.formatted() ?? "-") кг") } }
            }
        }
        .toolbar { ToolbarItem(placement: .topBarTrailing) { Button(action: { showAdd = true }) { Image(systemName: "plus.circle.fill") } } }
        .sheet(isPresented: $showAdd) { EditMeasurement(entry: MeasurementEntry(date: Date())) }
    }
}

struct MeasurementDetail: View {
    @EnvironmentObject var store: AppStore
    let entry: MeasurementEntry
    var body: some View {
        ScrollView { VStack(alignment:.leading, spacing: 16) {
            ValueRow("Вес, кг", entry.weight)
            ValueRow("Рост, см", entry.height)
            ValueRow("Шея, см", entry.neck)
            ValueRow("Плечевой пояс, см", entry.shoulders)
            ValueRow("Грудь, см", entry.chest)
            ValueRow("Талия, см", entry.waist)
            ValueRow("Бицепс левый, см", entry.bicepsL)
            ValueRow("Бицепс правый, см", entry.bicepsR)
            ValueRow("% жира", entry.bodyFatPct)
            GroupBox("Мой вес") {
                Chart(store.measurements.sorted{ $0.date < $1.date }) {
                    if let w = $0.weight {
                        LineMark(x:.value("Дата", $0.date), y:.value("Вес", w))
                    }
                }.frame(height:220)
            }
        }.padding() }
        .navigationTitle("Подробные данные")
    }
    @ViewBuilder private func ValueRow(_ title:String,_ val: Double?) -> some View { HStack { Text(title); Spacer(); Text(val?.formatted() ?? "-") } }
}

struct EditMeasurement: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) private var dismiss
    @State var entry: MeasurementEntry
    var body: some View {
        NavigationStack { Form {
            DatePicker("Дата замеров", selection: $entry.date, displayedComponents: .date)
            Section("Замеры") {
                StepperField(title: "Вес, кг", value: $entry.weight)
                StepperField(title: "Рост, см", value: $entry.height)
                StepperField(title: "% жира", value: $entry.bodyFatPct)
                StepperField(title: "Шея, см", value: $entry.neck)
                StepperField(title: "Плечевой пояс, см", value: $entry.shoulders)
                StepperField(title: "Грудь, см", value: $entry.chest)
                StepperField(title: "Талия, см", value: $entry.waist)
                StepperField(title: "Бицепс левый, см", value: $entry.bicepsL)
                StepperField(title: "Бицепс правый, см", value: $entry.bicepsR)
            }
        }
        .navigationTitle("Изменить замеры")
        .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Сохранить") { store.measurements.append(entry); store.saveAll(); dismiss() } }; ToolbarItem(placement: .cancellationAction) { Button("Отмена") { dismiss() } } }
        }
    }
}

struct StepperField: View { let title: String; @Binding var value: Double?; var body: some View { HStack { Text(title); Spacer(); Stepper(value: Binding(get: { value ?? 0 }, set: { value = $0 }), in: 0...999, step: 0.1) { Text(value.map { String(format: "%.1f", $0) } ?? "-") }.fixedSize() } }
}
