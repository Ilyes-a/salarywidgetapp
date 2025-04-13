//
//  SalaryManager.swift
//  SalaireWidgetApp
//
//  Created by Ilyes on 13/04/2025.
//
import Foundation

struct SalarySettings: Codable {
    var hourlyWage: Double
    var startHour: DateComponents
    var endHour: DateComponents
}

class SalaryManager: ObservableObject {
    static let shared = SalaryManager()
    let userDefaults = UserDefaults(suiteName: "group.com.tonnomdev.salairewidget")!

    @Published var hourlyWage: Double = 15.0
    @Published var startHour = DateComponents(hour: 9, minute: 0)
    @Published var endHour = DateComponents(hour: 17, minute: 0)

    private init() {
        loadSettings()
    }

    func loadSettings() {
        if let data = userDefaults.data(forKey: "settings"),
           let settings = try? JSONDecoder().decode(SalarySettings.self, from: data) {
            self.hourlyWage = settings.hourlyWage
            self.startHour = settings.startHour
            self.endHour = settings.endHour
        }
    }

    func saveSettings() {
        let settings = SalarySettings(hourlyWage: hourlyWage, startHour: startHour, endHour: endHour)
        if let data = try? JSONEncoder().encode(settings) {
            userDefaults.set(data, forKey: "settings")
        }
    }
}

