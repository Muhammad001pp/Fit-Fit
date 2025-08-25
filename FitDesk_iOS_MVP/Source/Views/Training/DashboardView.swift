import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // "Update Body Parameters" Banner
                UpdateParamsBanner()

                if let program = store.activeProgram {
                    ActiveProgramCard(program: program)
                    
                    SectionHeader(title: "Следующие тренировки") {
                        // Empty for now
                    }
                    
                    TrainingDaysProgressList(days: program.days)
                    
                    SectionHeader(title: "График тренировок") {
                        Button("Ещё") {}.foregroundStyle(.cyan)
                    }
                    
                    TrainingCalendarView()
                    
                    // Placeholder for recommendations
                    RecommendationCard()

                } else {
                    Text("Нет активной программы")
                        .padding()
                }
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
        .background(Color(.systemGroupedBackground))
    }
}

struct UpdateParamsBanner: View {
    var body: some View {
        HStack {
            Image(systemName: "arrow.triangle.2.circlepath")
            Text("Пора обновить параметры тела")
            Spacer()
        }
        .padding()
        .background(Color.red.opacity(0.8))
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ActiveProgramCard: View {
    let program: TrainingProgram
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Spacer()
            Text(program.name.uppercased())
                .font(.headline)
                .foregroundStyle(.white)
                .shadow(radius: 5)
            
            Text("Для зала • ★★★☆☆ Профи")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.9))
                .shadow(radius: 5)
            
            Text("\(program.days.count) тренировочных дня (\(program.daysPerWeek) тренировки в неделю)")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
                .shadow(radius: 5)
            
            Text("Выполнено занятий: \(program.completedWorkoutsCount)")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
                .shadow(radius: 5)
        }
        .padding()
        .frame(height: 180)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Image(systemName: "figure.strengthtraining.traditional") // Placeholder
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay(LinearGradient(colors: [.black.opacity(0.8), .clear], startPoint: .leading, endPoint: .center))
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct TrainingDaysProgressList: View {
    let days: [WorkoutDay]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(days.sorted { $0.index < $1.index }) { day in
                NavigationLink(destination: ExercisesListView(day: day)) {
                    WorkoutDayProgressRow(day: day)
                }
            }
        }
    }
}

struct WorkoutDayProgressRow: View {
    let day: WorkoutDay
    // Dummy progress
    private var progress: Int { day.progress }
    
    var body: some View {
        HStack(spacing: 16) {
            ProgressCircle(value: progress, tint: .cyan)
            
            VStack(alignment: .leading) {
                Text("\(day.index) тренировка")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(day.name)
                    .font(.headline)
                    .lineLimit(1)
            }
            
            Spacer()
            
            if progress > 0 && progress < 100 {
                Circle()
                    .fill(Color.cyan)
                    .frame(width: 8, height: 8)
            }
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ProgressCircle: View {
    var value: Int
    var tint: Color = .orange
    var body: some View {
        ZStack {
            Circle().stroke(Color(.systemGray5), lineWidth: 6)
            Circle()
                .trim(from: 0, to: CGFloat(value)/100)
                .stroke(value == 100 ? .green : tint, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("\(value)%").font(.footnote).monospacedDigit()
        }
        .frame(width: 44, height: 44)
    }
}

struct SectionHeader<Trailing: View>: View {
    let title: String
    let trailing: () -> Trailing
    
    init(title: String, @ViewBuilder trailing: @escaping () -> Trailing) {
        self.title = title
        self.trailing = trailing
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2.bold())
            Spacer()
            trailing()
        }
        .padding(.vertical, 4)
    }
}

struct RecommendationCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.bubble.fill")
                    .font(.title)
                    .foregroundStyle(.orange)
                Text("Рекомендации")
                    .font(.headline)
                Spacer()
                Button("Ещё") {}
                    .foregroundStyle(.cyan)
            }
            Text("Вы закончили тренировку с результатом менее 10%. Если не разобрались, как забивать результаты в дневник, мы подскажем!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
