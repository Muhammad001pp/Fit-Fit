
import SwiftUI

struct ExercisesListView: View {
    @EnvironmentObject var store: AppStore
    var day: WorkoutDay

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    WorkoutDayHeader(day: day)
                    
                    Text("Упражнения")
                        .font(.title2).bold()
                        .padding(.horizontal)

                    ExerciseTimeline(exercises: store.exercises(for: day))
                }
            }
            
            startTrainingButton
                .padding()
                .background(.bar)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(day.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var startTrainingButton: some View {
        Button(action: {
            // TODO: Start workout
        }) {
            Text("НАЧАТЬ ТРЕНИРОВКУ")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.cyan)
                .foregroundStyle(.white)
                .clipShape(Capsule())
        }
    }
}

struct WorkoutDayHeader: View {
    var day: WorkoutDay
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("СПЛИТ")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(day.name)
                .font(.title).bold()
            
            HStack {
                Label("30-40 мин", systemImage: "clock")
                Spacer()
                Label("350 ккал", systemImage: "flame")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            
            ProgressView(value: Double(day.progress) / 100.0)
                .tint(.cyan)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

struct ExerciseTimeline: View {
    let exercises: [Exercise]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(exercises.enumerated()), id: \.element.id) { index, exercise in
                NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                    ExerciseTimelineRow(
                        exercise: exercise,
                        isFirst: index == 0,
                        isLast: index == exercises.count - 1
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }
}

struct ExerciseTimelineRow: View {
    let exercise: Exercise
    let isFirst: Bool
    let isLast: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Timeline line and circle
            VStack(spacing: 0) {
                Rectangle()
                    .fill(isFirst ? Color.clear : Color.gray.opacity(0.5))
                    .frame(width: 2)
                    .frame(height: 20)
                
                Circle()
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: 14, height: 14)
                
                Rectangle()
                    .fill(isLast ? Color.clear : Color.gray.opacity(0.5))
                    .frame(width: 2)
            }
            
            // Exercise content
            VStack(alignment: .leading) {
                Text(exercise.title)
                    .font(.headline)
                
                Text(subtitle(for: exercise))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer(minLength: 20)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
        }
    }
    
    private func subtitle(for ex: Exercise) -> String {
        if let m = ex.recommendedTimeMin { return "\(m) мин" }
        if let r = ex.recommendedReps, let w = ex.recommendedWeight { return "4x\(r)x\(Int(w)) кг" }
        return ex.type.rawValue
    }
}


