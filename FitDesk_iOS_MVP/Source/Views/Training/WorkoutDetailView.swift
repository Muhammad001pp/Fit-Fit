import SwiftUI

struct WorkoutDetailView: View {
    @EnvironmentObject var store: AppStore
    let workout: WorkoutDay
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Header with workout info
                    WorkoutDetailHeader(workout: workout)
                    
                    // Exercises list
                    VStack(spacing: 12) {
                        ForEach(workout.exercises, id: \.self) { exerciseId in
                            if let exercise = store.exercises.first(where: { $0.id == exerciseId }) {
                                NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                                    ExercisePerformanceRow(
                                        exercise: exercise,
                                        workout: workout
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Start workout button (if not completed)
                    if workout.progress < 100 {
                        Button(action: {
                            // Start workout
                        }) {
                            Text("НАЧАТЬ ТРЕНИРОВКУ")
                                .font(.system(.body, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color.cyan)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Упражнения")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct WorkoutDetailHeader: View {
    let workout: WorkoutDay
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                // Progress circle
                ZStack {
                    Circle()
                        .stroke(Color(.systemGray5), lineWidth: 3)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(workout.progress) / 100)
                        .stroke(Color.cyan, lineWidth: 3)
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(workout.progress)%")
                        .font(.system(.caption, weight: .semibold))
                        .foregroundColor(.cyan)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(workout.index) тренировка")
                        .font(.system(.body, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(workout.targetGroups.map { $0.rawValue }.joined(separator: "/"))
                        .font(.system(.subheadline))
                        .foregroundColor(.secondary)
                    
                    Text("~ 1 ч 24 мин")
                        .font(.system(.caption))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

struct ExercisePerformanceRow: View {
    let exercise: Exercise
    let workout: WorkoutDay
    
    // Mock completion percentage - в реальном приложении это должно браться из данных
    private var completionPercentage: Int {
        // Для демонстрации используем случайные проценты
        switch workout.progress {
        case 100: return [100, 100, 100, 100, 100].randomElement() ?? 100
        case let progress where progress > 50: return [0, 100, 100].randomElement() ?? 50
        default: return 0
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
                // Exercise image placeholder
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "dumbbell")
                            .foregroundColor(.gray)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.title)
                        .font(.system(.body, weight: .medium))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    if let reps = exercise.recommendedReps, let weight = exercise.recommendedWeight {
                        Text("\(reps)x\(Int(weight)) кг")
                            .font(.system(.caption))
                            .foregroundColor(.secondary)
                    } else if let time = exercise.recommendedTimeMin {
                        Text("\(time) мин, 110 - 140 уд./мин.")
                            .font(.system(.caption))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Completion percentage
                Text("\(completionPercentage)%")
                    .font(.system(.body, weight: .semibold))
                    .foregroundColor(completionPercentage == 100 ? .cyan : (completionPercentage > 0 ? .orange : .red))
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    WorkoutDetailView(workout: WorkoutDay(
        index: 1,
        name: "грудные/трицепс/передняя дельта",
        targetGroups: [.chest, .triceps],
        exercises: [],
        progress: 88
    ))
    .environmentObject(AppStore())
}
