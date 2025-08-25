import SwiftUI

struct AllWorkoutsView: View {
    @EnvironmentObject var store: AppStore
    @State private var selectedWorkout: WorkoutDay?
    
    var body: some View {
        Group {
            if let program = store.activeProgram {
                ScrollView {
                    VStack(spacing: 16) {
                        // Карточка выбранной программы сверху
                        ActiveProgramCard(program: program)
                            .frame(maxWidth: .infinity)

                        LazyVStack(spacing: 12) {
                        ForEach(Array(program.days.enumerated()), id: \.element.id) { index, day in
                            WorkoutDayRow(
                                day: day,
                                dayNumber: index + 1,
                                isUnlocked: isWorkoutUnlocked(index: index),
                                isNext: isNextWorkout(index: index),
                                onTap: {
                                    if isWorkoutUnlocked(index: index) {
                                        selectedWorkout = day
                                    }
                                }
                            )
                        }
                        }
                    }
                    .padding(.horizontal)
                }
                .background(Color(.systemGroupedBackground))
            } else {
                NavigationStack {
                    VStack(spacing: 20) {
                        Text("Нет активной программы")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        NavigationLink("Выбрать программу") { MyProgramsView() }
                            .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .background(Color(.systemGroupedBackground))
                }
            }
        }
        .sheet(item: $selectedWorkout) { workout in
            WorkoutDetailView(workout: workout)
        }
    }
    
    private func isWorkoutUnlocked(index: Int) -> Bool {
        // First workout is always unlocked
        if index == 0 { return true }
        
        // Check if previous workouts are completed
        guard let program = store.activeProgram else { return false }
        
        for i in 0..<index {
            if program.days[i].progress < 100 {
                return false
            }
        }
        return true
    }
    
    private func isNextWorkout(index: Int) -> Bool {
        guard let program = store.activeProgram else { return false }
        
        // Find first incomplete workout
        for (i, day) in program.days.enumerated() {
            if day.progress < 100 {
                return i == index
            }
        }
        return false
    }
}

struct WorkoutDayRow: View {
    let day: WorkoutDay
    let dayNumber: Int
    let isUnlocked: Bool
    let isNext: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Progress circle or lock icon
                if isUnlocked {
                    ProgressCircle(value: day.progress, tint: progressColor)
                } else {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(Color(UIColor.tertiarySystemGroupedBackground))
                        )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(dayNumber) тренировка")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(day.name)
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundColor(isUnlocked ? .primary : .gray)
                }
                
                Spacer()
                
                // Skip button for next workout
                if isNext && day.progress == 0 {
                    Button("Пропустить") {
                        // TODO: Skip workout
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.blue, lineWidth: 1)
                    )
                }
                
                if isUnlocked {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(.tertiaryLabel))
                }
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isUnlocked)
    }
    
    private var progressColor: Color {
        if day.progress == 0 { return .gray }
        if day.progress < 50 { return .red }
        if day.progress < 100 { return .orange }
        return .green
    }
}
