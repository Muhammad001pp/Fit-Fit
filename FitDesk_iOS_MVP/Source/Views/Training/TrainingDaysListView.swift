import SwiftUI

struct TrainingDaysListView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        ScrollView {
            if let program = store.activeProgram {
                VStack(spacing: 12) {
                    ForEach(program.days.sorted { $0.index < $1.index }) { day in
                        // Logic to lock/unlock days
                        let isLocked = day.index > (program.lastCompletedDayIndex + 1)
                        
                        NavigationLink(destination: ExercisesListView(day: day)) {
                            LockedWorkoutDayRow(day: day, isLocked: isLocked)
                        }
                        .disabled(isLocked)
                    }
                }
                .padding(.horizontal)
            } else {
                Text("Нет активной программы")
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct LockedWorkoutDayRow: View {
    let day: WorkoutDay
    let isLocked: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: isLocked ? "lock.fill" : "circle.dashed")
                .font(.title2)
                .foregroundStyle(isLocked ? Color.secondary : Color.cyan)
                .frame(width: 44)

            VStack(alignment: .leading) {
                Text("\(day.index) тренировка")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(day.name)
                    .font(.headline)
            }
            .opacity(isLocked ? 0.5 : 1.0)
            
            Spacer()
            
            if !isLocked {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
