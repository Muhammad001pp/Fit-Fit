import SwiftUI

struct ProgramSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var store: AppStore
    @State private var selectedCategory = "СГРУППИРОВАНО, МУЖЧИНЫ"
    @State private var previewProgram: TrainingProgram? = nil
    
    let categories = [
        "СГРУППИРОВАНО, МУЖЧИНЫ",
        "СГРУППИРОВАНО, ЖЕНЩИНЫ",
        "ПО ГРУППАМ МЫШЦ",
        "СПЕЦИАЛЬНЫЕ ПРОГРАММЫ"
    ]
    
    let programs = [
        ProgramTemplate(name: "Общий набор мышечной массы", imageName: "bodybuilding1"),
        ProgramTemplate(name: "Объемные руки", imageName: "arms"),
        ProgramTemplate(name: "Мощные грудные мышцы", imageName: "chest"),
        ProgramTemplate(name: "Широкая спина", imageName: "back"),
        ProgramTemplate(name: "Большие плечи", imageName: "shoulders"),
        ProgramTemplate(name: "Массивные ноги", imageName: "legs"),
        ProgramTemplate(name: "Похудение", imageName: "cardio"),
        ProgramTemplate(name: "Рельефное тело", imageName: "definition"),
        ProgramTemplate(name: "Пресс кубиками", imageName: "abs"),
        ProgramTemplate(name: "Развитие силы powerlifting", imageName: "powerlifting"),
        ProgramTemplate(name: "Выносливость crossfit", imageName: "crossfit"),
        ProgramTemplate(name: "Все тело за 45 минут", imageName: "fullbody")
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category selector
                Menu {
                    ForEach(categories, id: \.self) { category in
                        Button(category) {
                            selectedCategory = category
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedCategory)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Programs grid
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(programs, id: \.name) { template in
                            ProgramTemplateCard(program: template) {
                                // Берём любой существующий seed как основу структуры
                                let seed = store.allPrograms.first
                                let days = seed?.days ?? []
                                let program = TrainingProgram(
                                    id: UUID(),
                                    name: template.name,
                                    place: "Зал",
                                    level: "Профи",
                                    totalDays: max(days.count, seed?.totalDays ?? days.count),
                                    daysPerWeek: seed?.daysPerWeek ?? 3,
                                    description: "",
                                    days: days
                                )
                                previewProgram = program
                            }
                        }
                    }
                    .padding()
                }
                
                // Create custom workout button
                Button(action: {
                    // TODO: Create custom workout
                    dismiss()
                }) {
                    HStack {
                        Text("СОЗДАТЬ СВОЮ ТРЕНИРОВКУ")
                            .font(.system(.body, weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Выберите программу")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Назад") { dismiss() }
                }
            }
                        .background(Color(.systemGroupedBackground))
        }
    .sheet(item: $previewProgram) { (p: TrainingProgram) in
            ProgramPreviewInlineView(program: p)
                .environmentObject(store)
        }
    }
}

// Локальный предпросмотр программы, чтобы показать порядок дней и упражнения
private struct ProgramPreviewInlineView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) var dismiss
    let program: TrainingProgram
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ActiveProgramCard(program: program)
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Тренировочные дни") { EmptyView() }
                        ForEach(program.days.sorted { $0.index < $1.index }) { day in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 12) {
                                    ProgressCircle(value: day.progress, tint: .cyan)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("\(day.index) тренировка")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        Text(day.name)
                                            .font(.headline)
                                    }
                                    Spacer()
                                }
                                VStack(alignment: .leading, spacing: 6) {
                                    ForEach(store.exercises(for: day)) { ex in
                                        HStack(spacing: 8) {
                                            Circle().fill(Color(.systemGray5)).frame(width: 6, height: 6)
                                            Text(ex.title)
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            }
                            .padding(12)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .padding(.horizontal)
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    store.activateOrAdd(program)
                    dismiss()
                } label: {
                    Text("ВЫБРАТЬ ПРОГРАММУ")
                        .font(.system(.body, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.cyan)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                }
                .background(Color(.systemGroupedBackground))
            }
            .navigationTitle("Структура программы")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct ProgramTemplate {
    let name: String
    let imageName: String
}

struct ProgramTemplateCard: View {
    let program: ProgramTemplate
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            ZStack(alignment: .bottomLeading) {
                // Background image placeholder
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.black.opacity(0.3), .black.opacity(0.7)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 120)
                
                // Program name
                Text(program.name)
                    .font(.system(.body, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }
}
