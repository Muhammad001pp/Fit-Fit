
import Foundation

struct Exercise: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var group: MuscleGroup
    var type: ExerciseType
    var recommendedTimeMin: Int?
    var recommendedReps: Int?
    var recommendedWeight: Double?
    var image: String? // имя картинки в ассетах или SF Symbol
    
    init(id: UUID = UUID(), title: String, group: MuscleGroup, type: ExerciseType, recommendedTimeMin: Int? = nil, recommendedReps: Int? = nil, recommendedWeight: Double? = nil, image: String? = nil) {
        self.id = id
        self.title = title
        self.group = group
        self.type = type
        self.recommendedTimeMin = recommendedTimeMin
        self.recommendedReps = recommendedReps
        self.recommendedWeight = recommendedWeight
        self.image = image
    }
}

struct WorkoutDay: Identifiable, Codable {
    let id: UUID
    var index: Int
    var name: String
    var targetGroups: [MuscleGroup]
    var exercises: [UUID] // ссылки на Exercise.id
    var progress: Int // 0..100
    
    init(id: UUID = UUID(), index: Int, name: String, targetGroups: [MuscleGroup], exercises: [UUID], progress: Int = 0) {
        self.id = id
        self.index = index
        self.name = name
        self.targetGroups = targetGroups
        self.exercises = exercises
        self.progress = progress
    }

    // Совместимость с seed JSON, где поле называется "title"
    enum CodingKeys: String, CodingKey {
        case id, index, name, targetGroups, exercises, progress
        case title // альтернативное имя для name в seed
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.index = try container.decode(Int.self, forKey: .index)
        // Пытаемся декодировать name, если нет — берём title
        if let name = try container.decodeIfPresent(String.self, forKey: .name) {
            self.name = name
        } else if let title = try container.decodeIfPresent(String.self, forKey: .title) {
            self.name = title
        } else {
            self.name = ""
        }
        // В seed targetGroups — это строки, маппим в enum
        if let groups = try container.decodeIfPresent([String].self, forKey: .targetGroups) {
            self.targetGroups = groups.compactMap { MuscleGroup(rawValue: $0) }
        } else {
            self.targetGroups = []
        }
        self.exercises = try container.decode([UUID].self, forKey: .exercises)
        self.progress = try container.decodeIfPresent(Int.self, forKey: .progress) ?? 0
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(index, forKey: .index)
        try container.encode(name, forKey: .name)
        try container.encode(targetGroups.map { $0.rawValue }, forKey: .targetGroups)
        try container.encode(exercises, forKey: .exercises)
        try container.encode(progress, forKey: .progress)
    }
}

struct TrainingProgram: Identifiable, Codable {
    let id: UUID
    var name: String
    var place: String // Зал/Дома
    var level: String // Без опыта/Начинающий/Продвинутый/Опытный/Профи
    var totalDays: Int
    var daysPerWeek: Int
    var description: String
    var days: [WorkoutDay]
    
    var completedWorkoutsCount: Int {
        days.filter { $0.progress == 100 }.count
    }
    
    var lastCompletedDayIndex: Int {
        days.filter { $0.progress == 100 }.map { $0.index }.max() ?? 0
    }
}

struct MeasurementEntry: Identifiable, Codable {
    let id: UUID
    var date: Date
    var weight: Double?
    var height: Double?
    var neck: Double?
    var shoulders: Double?
    var chest: Double?
    var waist: Double?
    var bicepsL: Double?
    var bicepsR: Double?
    var forearmL: Double?
    var forearmR: Double?
    var wristL: Double?
    var wristR: Double?
    var glutes: Double?
    var thighL: Double?
    var thighR: Double?
    var bodyFatPct: Double?
    
    init(id: UUID = UUID(), date: Date, weight: Double? = nil, height: Double? = nil, neck: Double? = nil, shoulders: Double? = nil, chest: Double? = nil, waist: Double? = nil, bicepsL: Double? = nil, bicepsR: Double? = nil, forearmL: Double? = nil, forearmR: Double? = nil, wristL: Double? = nil, wristR: Double? = nil, glutes: Double? = nil, thighL: Double? = nil, thighR: Double? = nil, bodyFatPct: Double? = nil) {
        self.id = id
        self.date = date
        self.weight = weight
        self.height = height
        self.neck = neck
        self.shoulders = shoulders
        self.chest = chest
        self.waist = waist
        self.bicepsL = bicepsL
        self.bicepsR = bicepsR
        self.forearmL = forearmL
        self.forearmR = forearmR
        self.wristL = wristL
        self.wristR = wristR
        self.glutes = glutes
        self.thighL = thighL
        self.thighR = thighR
        self.bodyFatPct = bodyFatPct
    }
}

struct HeartRateSample: Identifiable, Codable {
    var id: UUID = UUID()
    var date: Date
    var bpm: Int
}

struct ReferenceSection: Identifiable, Codable {
    let id: UUID
    var title: String
    var items: [ReferenceItem]
    
    init(id: UUID = UUID(), title: String, items: [ReferenceItem]) {
        self.id = id
        self.title = title
        self.items = items
    }
}

struct ReferenceItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var body: String
    var tags: [String]
}
