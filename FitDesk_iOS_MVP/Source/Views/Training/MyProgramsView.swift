import SwiftUI

struct MyProgramsView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) var dismiss
    @State private var showProgramSelection = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Buttons at top
                VStack(spacing: 12) {
                    Button(action: { showProgramSelection = true }) {
                        HStack {
                            Text("ВЫБРАТЬ ГОТОВУЮ ТРЕНИРОВКУ")
                                .font(.system(.body, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                    }
                    
                    Button(action: {
                        // TODO: Create custom workout
                    }) {
                        HStack {
                            Text("СОЗДАТЬ СВОЮ ТРЕНИРОВКУ")
                                .font(.system(.body, weight: .semibold))
                                .foregroundColor(.green)
                            Spacer()
                        }
                        .padding()
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.green, lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal)
                
                // Programs list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(store.allPrograms) { program in
                            ProgramCard(
                                program: program,
                                isActive: program.id == store.activeProgram?.id,
                                onSelect: {
                                    store.setActiveProgram(program)
                                    dismiss()
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Мои программы")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Закрыть") { dismiss() }
                }
            }
                        .background(Color(.systemGroupedBackground))
        }
        .sheet(isPresented: $showProgramSelection) {
            ProgramSelectionView()
                .environmentObject(store)
        }
        // Закрываем модалку, когда выбранная программа изменилась
        .onChange(of: store.activeProgram?.id) { _ in
            dismiss()
        }
    }
}

struct ProgramCard: View {
    let program: TrainingProgram
    let isActive: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            ZStack(alignment: .topTrailing) {
                // Program card content
                VStack(alignment: .leading, spacing: 8) {
                    Spacer()
                    
                    Text(program.name.uppercased())
                        .font(.system(.headline, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Image(systemName: "dumbbell")
                        Text("Для зала")
                        Spacer()
                        // Уровень сложности
                        Text(program.level)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color(.systemGray6))
                            .cornerRadius(6)
                    }
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
                    
                    Text("\(program.days.count) тренировочных дня (\(program.daysPerWeek) тренировки в неделю)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("Выполнено занятий: \(program.completedWorkoutsCount)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding()
                .frame(height: 120)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    // Placeholder background with gradient
                    ZStack {
                        Color.black
                        LinearGradient(
                            colors: [.black.opacity(0.7), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Active indicator
                if isActive {
                    Text("АКТИВНАЯ")
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .padding(8)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
