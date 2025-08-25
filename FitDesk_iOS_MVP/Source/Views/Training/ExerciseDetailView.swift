
import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise
    @State private var running = false
    @State private var remaining: Int = 0
    @State private var total: Int = 0
    @State private var history: [Date:Int] = [:] // дата → минуты
    @State private var timer: Timer?
    
    var body: some View {
        ScrollView {
            VStack(alignment:.leading, spacing: 16) {
                HStack { Image(systemName: exercise.image ?? "dumbbell").font(.largeTitle); VStack(alignment:.leading){ Text(exercise.title).font(.title3.bold()); Text(recommendation).foregroundStyle(.secondary) } }
                HStack(spacing: 16) {
                    StatBadge(title: "Повторений", value: exercise.recommendedReps.map(String.init) ?? "Нет")
                    StatBadge(title: "Отдых", value: "02:00")
                    StatBadge(title: "Минут", value: exercise.recommendedTimeMin.map(String.init) ?? "0")
                }
                timerSection
                historySection
            }.padding()
        }
        .onDisappear { timer?.invalidate() }
        .navigationTitle(exercise.group.rawValue)
        .onAppear {
            total = (exercise.recommendedTimeMin ?? 8) * 60
            remaining = total
        }
    }
    
    private var recommendation: String {
        if let w = exercise.recommendedWeight { return "Реком. вес: \(Int(w)) кг" }
        if let m = exercise.recommendedTimeMin { return "Реком. время: \(m) мин" }
        return "Нет рекомендаций"
    }
    
    @ViewBuilder private var timerSection: some View {
        VStack(spacing: 12) {
            HStack { Text(running ? "ИДЁТ" : "СТОП").font(.headline); Spacer(); Text(format(remaining)).monospacedDigit() }
            HStack { Button(running ? "ПАУЗА" : "СТАРТ") { toggleTimer() }.buttonStyle(.borderedProminent); Button("СБРОС") { stopTimer(reset: true) }.buttonStyle(.bordered) }
        }.padding().background(RoundedRectangle(cornerRadius: 14).fill(Color(.systemGray6)))
    }
    
    @ViewBuilder private var historySection: some View {
        VStack(alignment:.leading, spacing: 8) {
            HStack { Text("История выполнения").font(.headline); Spacer() }
            ForEach(history.sorted(by: { $0.key > $1.key }), id: \.key) { k,v in
                HStack { Text(k, style: .date); Spacer(); Text("\(v/60) мин") }
            }
        }
    }
    
    private func toggleTimer() { running ? pauseTimer() : startTimer() }
    private func startTimer() { running = true; timer?.invalidate(); timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in if remaining>0 { remaining -= 1 } else { stopTimer(reset:false) } } }
    private func pauseTimer() { running = false; timer?.invalidate() }
    private func stopTimer(reset: Bool) { running=false; timer?.invalidate(); if !reset { let minutes = (total-remaining)/60; history[Date()] = max(minutes,1) }; total = (exercise.recommendedTimeMin ?? 8)*60; remaining = reset ? total : total }
    private func format(_ s:Int) -> String { String(format: "%02d:%02d", s/60, s%60) }
}

struct StatBadge: View { let title: String; let value: String; var body: some View { VStack { Text(value).font(.headline); Text(title).font(.caption).foregroundStyle(.secondary) }.padding().background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6))) } }
