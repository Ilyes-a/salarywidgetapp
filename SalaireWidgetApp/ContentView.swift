import SwiftUI
import WidgetKit
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
struct ContentView: View {
    @ObservedObject var manager = SalaryManager.shared
    let daysOfWeek = [
        (2, "Lundi"), (3, "Mardi"), (4, "Mercredi"),
        (5, "Jeudi"), (6, "Vendredi"), (7, "Samedi"), (1, "Dimanche")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // HEADER
                Text("Configuration du Salaire")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                // SALAIRE
                VStack(alignment: .leading, spacing: 8) {
                    Text("Salaire horaire brut (€)")
                        .font(.headline)

                    TextField("Salaire en €/h", value: $manager.hourlyWage, format: .number)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.system(size: 20))
                }
               
                //  HEURES
                VStack(alignment: .leading, spacing: 8) {
                    Text("Heures de travail")
                        .font(.headline)

                    HStack {
                        DatePicker("Début", selection: Binding(
                            get: { Calendar.current.date(from: manager.startHour) ?? Date() },
                            set: { manager.startHour = Calendar.current.dateComponents([.hour, .minute], from: $0) }
                        ), displayedComponents: [.hourAndMinute])
                        .labelsHidden()

                        DatePicker("Fin", selection: Binding(
                            get: { Calendar.current.date(from: manager.endHour) ?? Date() },
                            set: { manager.endHour = Calendar.current.dateComponents([.hour, .minute], from: $0) }
                        ), displayedComponents: [.hourAndMinute])
                        .labelsHidden()
                    }
                }
                //  ESTIMATION
                VStack(alignment: .leading, spacing: 8) {
                    Text("Salaire NET estimé par jour")
                        .font(.headline)

                    Text("≈ \(String(format: "%.2f", manager.estimatedDailySalary())) €")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }

                // JOURS
                VStack(alignment: .leading, spacing: 8) {
                    Text("Jours travaillés")
                        .font(.headline)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 12) {
                        ForEach(daysOfWeek, id: \.0) { day in
                            Button(action: {
                                manager.toggleDay(day.0)
                            }) {
                                Text(day.1.prefix(3).uppercased())
                                    .frame(maxWidth: .infinity)
                                    .padding(8)
                                    .background(manager.workingDays.contains(day.0) ? Color.accentColor : Color.gray.opacity(0.2))
                                    .foregroundColor(manager.workingDays.contains(day.0) ? .white : .primary)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                //ESTIMATION SEMAINE
                VStack(alignment: .leading, spacing: 8) {
                    Text("Salaire estimé hebdo (net)")
                        .font(.headline)
                    Text("≈ \(String(format: "%.2f", manager.estimatedWeeklySalary())) €")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                }
                //ESTIMATION MOIS
                VStack(alignment: .leading, spacing: 8) {
                    Text("Salaire estimé mensuel (net)")
                        .font(.headline)
                    Text("≈ \(String(format: "%.2f", manager.estimatedmonthlysalary())) €")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                }
                

                //  BOUTON MAJ
                Button(action: {
                    manager.saveSettings()
                    WidgetCenter.shared.reloadAllTimelines()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise.circle.fill")
                        Text("Mettre à jour le widget")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }

                Spacer()
            }
            .padding(.horizontal)
        }
        .background(Color(.systemGroupedBackground))
        .dynamicTypeSize(.medium)
        .onTapGesture {
                UIApplication.shared.endEditing()
            }
    }
}
