import Foundation

struct SalarySettings: Codable {
    var hourlyWage: Double
    var startHour: DateComponents
    var endHour: DateComponents
    var workingDays: [Int] // 1 = Sunday, 2 = Monday, ... 7 = Saturday
}

class SalaryManager: ObservableObject {
    static let shared = SalaryManager()
    let userDefaults = UserDefaults(suiteName: "group.com.tonnomdev.salairewidget")!

    @Published var hourlyWage: Double = 15.0
    @Published var startHour = DateComponents(hour: 9, minute: 0)
    @Published var endHour = DateComponents(hour: 17, minute: 0)
    @Published var workingDays: [Int] = [2, 3, 4, 5, 6] // Lundi à vendredi

    private init() {
        loadSettings()
    }

    func loadSettings() {
        if let data = userDefaults.data(forKey: "settings"),
           let settings = try? JSONDecoder().decode(SalarySettings.self, from: data) {
            self.hourlyWage = settings.hourlyWage
            self.startHour = settings.startHour
            self.endHour = settings.endHour
            self.workingDays = settings.workingDays
        }
    }

    func saveSettings() {
        let settings = SalarySettings(
            hourlyWage: hourlyWage,
            startHour: startHour,
            endHour: endHour,
            workingDays: workingDays
        )
        if let data = try? JSONEncoder().encode(settings) {
            userDefaults.set(data, forKey: "settings")
        }
    }

    func estimatedDailySalary() -> Double {
        let calendar = Calendar.current
        guard let start = calendar.date(from: startHour),
              let end = calendar.date(from: endHour) else { return 0.0 }
        let duration = end.timeIntervalSince(start) / 3600.0
        return hourlyWage * duration * 0.77
    }
    func estimatedWeeklySalary() -> Double {
        let daily = estimatedDailySalary()
        return daily * Double(workingDays.count)
    }
    func estimatedmonthlysalary() -> Double {
        let weekly = estimatedWeeklySalary()
        return weekly * 4
    }

    func toggleDay(_ day: Int) {
        if workingDays.contains(day) {
            workingDays.removeAll { $0 == day }
        } else {
            workingDays.append(day)
        }
    }
}
