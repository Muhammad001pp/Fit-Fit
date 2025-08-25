import Foundation
import SwiftUI

final class AppStore: ObservableObject {
    // Каталоги
    @Published var exercises: [Exercise] = []
    @Published var programs: [TrainingProgram] = []
    @Published var activeProgram: TrainingProgram? = nil
    @Published var measurements: [MeasurementEntry] = []
    @Published var heartRate: [HeartRateSample] = []
    @Published var reference: [ReferenceSection] = []
    @Published var profile: UserProfile = .init()
    
    private let fm = FileManager.default
    private var docs: URL { fm.urls(for: .documentDirectory, in: .userDomainMask)[0] }
    
    init() {
        firstRunSeedIfNeeded()
        loadAll()
    }
    
    // MARK: Persistence JSON (просто и прозрачно)
    func saveAll() {
        save(exercises, "exercises.json")
        save(programs, "programs.json")
        save(activeProgram, "activeProgram.json")
        save(measurements, "measurements.json")
        save(heartRate, "heartRate.json")
        save(reference, "reference.json")
        save(profile, "profile.json")
    }
    
    func loadAll() {
        exercises = load("exercises.json") ?? []
        programs = load("programs.json") ?? []
        activeProgram = load("activeProgram.json") ?? programs.first
        measurements = load("measurements.json") ?? []
        heartRate = load("heartRate.json") ?? []
        reference = load("reference.json") ?? []
        profile = load("profile.json") ?? .init()
    }
    
    private func path(_ name: String) -> URL { docs.appendingPathComponent(name) }
    
    private func save<T: Encodable>(_ value: T?, _ name: String) {
        guard let value else { return }
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(value)
            try data.write(to: path(name), options: [.atomic])
        } catch {
            print("save error", name, error)
        }
    }
    private func load<T: Decodable>(_ name: String) -> T? {
        do {
            let data = try Data(contentsOf: path(name))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch { return nil }
    }
    
    // MARK: - Seeding
    private func firstRunSeedIfNeeded() {
        let flag = path(".seed_done")
        if fm.fileExists(atPath: flag.path) { return }
        do {
            try fm.createDirectory(at: docs, withIntermediateDirectories: true)
        } catch {}
        // Copy seeds from bundle
        func bundleJSON(_ name: String) -> Data? {
            // Try common locations: "seed", "Data/seed", or bundle root
            let candidates: [String?] = ["seed", "Data/seed", nil]
            for subdir in candidates {
                if let url = Bundle.main.url(forResource: name, withExtension: "json", subdirectory: subdir) {
                    return try? Data(contentsOf: url)
                }
            }
            return nil
        }
        let seeds = ["exercises", "programs", "reference", "measurements", "heartRate"]
        for s in seeds {
            if let data = bundleJSON(s) {
                try? data.write(to: path("\(s).json"))
            }
        }
        try? "ok".data(using: .utf8)?.write(to: flag)
    }
}

extension AppStore {
    func exercises(for day: WorkoutDay) -> [Exercise] {
        day.exercises.compactMap { id in
            self.exercises.first { $0.id == id }
        }
    }
    
    var allPrograms: [TrainingProgram] {
        return programs
    }
    
    func setActiveProgram(_ program: TrainingProgram) {
        activeProgram = program
        saveAll()
    }

    func activateOrAdd(_ program: TrainingProgram) {
        if !programs.contains(where: { $0.id == program.id }) {
            programs.append(program)
        }
        activeProgram = program
        saveAll()
    }
}
