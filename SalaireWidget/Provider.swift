//
//  Provider.swift
//  SalaireWidgetApp
//
//  Created by Ilyes on 13/04/2025.
//

import WidgetKit
import SwiftUI
import Foundation

struct SalarySettings: Codable {
    var hourlyWage: Double
    var startHour: DateComponents
    var endHour: DateComponents
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SalaryEntry {
        SalaryEntry(date: Date(), earned: 0.0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SalaryEntry) -> Void) {
        completion(SalaryEntry(date: Date(), earned: 0.0))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SalaryEntry>) -> Void) {
        let userDefaults = UserDefaults(suiteName: "group.com.tonnomdev.salairewidget")!
        guard let data = userDefaults.data(forKey: "settings"),
              let settings = try? JSONDecoder().decode(SalarySettings.self, from: data) else {
            completion(Timeline(entries: [SalaryEntry(date: Date(), earned: 0.0)], policy: .never))
            return
        }

        var entries: [SalaryEntry] = []
        let calendar = Calendar.current

        guard let startDate = calendar.date(from: settings.startHour),
              let endDate = calendar.date(from: settings.endHour) else {
            return
        }

        var currentDate = startDate
        while currentDate <= endDate {
            let minutesWorked = currentDate.timeIntervalSince(startDate) / 60.0
            let earned = settings.hourlyWage * (minutesWorked / 60.0)
            entries.append(SalaryEntry(date: currentDate, earned: earned))
            currentDate = calendar.date(byAdding: .minute, value: 1, to: currentDate) ?? currentDate
        }

        completion(Timeline(entries: entries, policy: .atEnd))
    }
}
