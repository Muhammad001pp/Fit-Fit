
import SwiftUI

struct MoreView: View {
    @EnvironmentObject var store: AppStore
    @State private var editing = false
    var body: some View {
        NavigationStack {
            List {
                Section("Аккаунт") {
                    NavigationLink("Аналитика") { AnalyticsView() }
                    NavigationLink("Замеры") { MeasurementsTab() }
                    NavigationLink("Мой профиль") { ProfileView() }
                }
                Section {
                    Button("Вы авторизованы через Apple ID") {}
                    Button("Выйти из аккаунта") {}
                }
            }.navigationTitle("Ещё")
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var store: AppStore
    @State private var editing = false
    var body: some View {
        VStack(spacing: 16) {
            Circle().fill(Color(.systemGray5)).frame(width: 96,height:96).overlay(Image(systemName:"plus"))
            Text("\(store.profile.firstName) \(store.profile.lastName)").font(.title3.bold())
            Text("38 лет, Махачкала, Дагестан, Россия").foregroundStyle(.secondary)
            HStack { Button("Фото"){}; Button("Обо мне"){}; Button("Лента"){} }.buttonStyle(.bordered)
            Spacer()
        }
        .padding()
        .navigationTitle("Мой профиль")
        .toolbar { ToolbarItem(placement: .topBarTrailing) { Button { editing = true } label: { Image(systemName:"pencil") } } }
        .sheet(isPresented: $editing) { EditProfileSheet() }
    }
}

struct EditProfileSheet: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) private var dismiss
    @State private var first = ""
    @State private var last = ""
    @State private var birth = Date(timeIntervalSince1970: 547488000)
    @State private var country = "Россия"
    @State private var city = "Махачкала, Дагестан"
    @State private var gender = "Мужчина"
    var body: some View {
        NavigationStack {
            Form {
                Section("Личные данные") {
                    TextField("Имя", text: $first)
                    TextField("Фамилия", text: $last)
                    DatePicker("Дата рождения", selection: $birth, displayedComponents: .date)
                    Picker("Пол", selection: $gender) { Text("Мужчина").tag("Мужчина"); Text("Женщина").tag("Женщина") }
                }
                Section {
                    TextField("Страна", text: $country)
                    TextField("Город", text: $city)
                }
            }
            .navigationTitle("Редактирование профиля")
            .toolbar {
                ToolbarItem(placement:.cancellationAction){ Button("Очистить"){ first=""; last="" } }
                ToolbarItem(placement:.confirmationAction){ Button("Сохранить"){ store.profile.firstName = first.isEmpty ? store.profile.firstName : first; store.profile.lastName = last.isEmpty ? store.profile.lastName : last; store.profile.birthDate = birth; store.profile.country=country; store.profile.city=city; store.profile.gender=gender; store.saveAll(); dismiss() } }
            }
        }
        .onAppear{ first=store.profile.firstName; last=store.profile.lastName; birth=store.profile.birthDate; country=store.profile.country; city=store.profile.city; gender=store.profile.gender }
    }
}
