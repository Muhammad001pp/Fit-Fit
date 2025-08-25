import SwiftUI

struct ProgramPreviewView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) var dismiss
    let program: TrainingProgram
    let allowSelect: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header card similar to dashboard
                ActiveProgramCard(program: program)
                    .frame(maxWidth: .infinity)

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Тренировочные дни") { EmptyView() }
                    ForEach(
                        Array(program.days.sorted { $0.index < $1.index }.enumerated()),
                        id: \.element.id
                    ) { idx, day in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 12) {
                                ProgressCircle(value: day.progress, tint: .cyan)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("\(idx + 1) тренировка")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Text(day.name)
                                        .font(.headline)
                                        .lineLimit(2)
                                }
                                Spacer()
                            }

                            // Exercises preview list
                            VStack(spacing: 6) {
                                ForEach(store.exercisesForIds(day.exercises)) { ex in
                                    HStack(spacing: 8) {
                                        Circle().fill(Color(.systemGray5)).frame(width: 8, height: 8)
                                        Text(ex.title)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                        Spacer()
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
            if allowSelect {
                Button(action: {
                    store.setActiveProgram(program)
                    dismiss()
                }) {
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
        }
        .navigationTitle("Структура программы")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
}

private extension AppStore {
    func exercisesForIds(_ ids: [UUID]) -> [Exercise] {
        exercises.filter { ids.contains($0.id) }
    }
}
