
import Foundation

enum MuscleGroup: String, CaseIterable, Codable, Identifiable {
    case chest = "Грудь"
    case back = "Спина"
    case legs = "Ноги"
    case glutes = "Ягодичные"
    case delts = "Дельты"
    case biceps = "Руки Бицепс"
    case triceps = "Руки Трицепс"
    var id: String { rawValue }
}

enum ExerciseType: String, Codable {
    case warmup = "Разминка"
    case strength = "Силовые"
    case functional = "Функциональные"
    case cardio = "Кардио"
}
