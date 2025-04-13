//
//  ContentView.swift
//  SalaireWidgetApp
//
//  Created by Ilyes on 13/04/2025.
//
import SwiftUI
import WidgetKit

struct ContentView: View {
    @ObservedObject var manager = SalaryManager.shared

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Salaire horaire brut (€)")) {
                    TextField("15.00", value: $manager.hourlyWage, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                }
                Section(header: Text("Heure de début")) {
                    DatePicker("Début", selection: Binding(
                        get: { Calendar.current.date(from: manager.startHour) ?? Date() },
                        set: { manager.startHour = Calendar.current.dateComponents([.hour, .minute], from: $0) }
                    ), displayedComponents: [.hourAndMinute])
                }
                Section(header: Text("Heure de fin")) {
                    DatePicker("Fin", selection: Binding(
                        get: { Calendar.current.date(from: manager.endHour) ?? Date() },
                        set: { manager.endHour = Calendar.current.dateComponents([.hour, .minute], from: $0) }
                    ), displayedComponents: [.hourAndMinute])
                }
                Button("Mettre à jour le widget") {
                    manager.saveSettings()
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
            .navigationTitle("Configuration")
        }
    }
}

