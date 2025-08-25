
import Foundation

struct UserProfile: Codable {
    var firstName: String = "Mukhumaev"
    var lastName: String = "Magomed"
    var birthDate: Date = Date(timeIntervalSince1970: 547488000) // 1987-05-21
    var country: String = "Россия"
    var city: String = "Махачкала, Дагестан"
    var gender: String = "Мужчина"
}
