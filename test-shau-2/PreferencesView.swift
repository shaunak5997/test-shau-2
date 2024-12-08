import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct PreferencesView: View {
    @State private var airQualityPriority: String = "High"
    @State private var physicalActivityPriority: String = "Low"
    @State private var timePriority: String = "Medium"
    @State private var distancePriority: String = "Medium"
    @State private var trafficPriority: String = "High"
    @State private var publicTransitPriority: String = "Low"
    
    @State private var optimalSensitivity: String = "[Min val] - [Max val]"
    @State private var optimalAirFactors: Bool = true
    
    @State private var dailyStepGoal: String = "10000"
    @State private var calorieBurnGoal: String = "500"
    
    @State private var avoidTolls: Bool = true
    @State private var avoidHighways: Bool = false
    @State private var avoidFerries: Bool = false
    
    @State private var errorMessage: String? = nil
    @State private var isLoading = false
    @State private var isSuccessMessageShown = false
    
    // For the picker sheet
    @State private var isPickerPresented = false
    @State private var selectedField: String? = nil
    @State private var tempPriorityValue: String = "Medium"
    
    let priorityLevels = ["High", "Medium", "Low"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("PRIORITY SCORING MODEL")) {
                    selectableRow(title: "Air quality", value: $airQualityPriority)
                    selectableRow(title: "Physical activity", value: $physicalActivityPriority)
                    selectableRow(title: "Time", value: $timePriority)
                    selectableRow(title: "Distance", value: $distancePriority)
                    selectableRow(title: "Traffic", value: $trafficPriority)
                    selectableRow(title: "Public transit transfers", value: $publicTransitPriority)
                }
                
                Section(header: Text("AIR QUALITY")) {
                    editableRow(title: "Optimal sensitivity", value: $optimalSensitivity)
                    Toggle("Optimal air factors", isOn: $optimalAirFactors)
                }
                
                Section(header: Text("PHYSICAL ACTIVITY")) {
                    editableRow(title: "Daily step goal", value: $dailyStepGoal)
                    editableRow(title: "Calorie burn goal", value: $calorieBurnGoal)
                }
                
                Section(header: Text("CAR NAVIGATION")) {
                    Toggle("Avoid tolls", isOn: $avoidTolls)
                    Toggle("Avoid highways", isOn: $avoidHighways)
                }
                
                Section(header: Text("PUBLIC TRANSIT NAVIGATION")) {
                    Toggle("Avoid ferries", isOn: $avoidFerries)
                }
            }
            .navigationTitle("Preferences")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: savePreferences) {
                        Text("Save")
                            .fontWeight(.bold)
                    }
                }
            }
            // Sheet for selecting priority levels
            .sheet(isPresented: $isPickerPresented) {
                VStack {
                    Text("Select Priority")
                        .font(.headline)
                        .padding()
                    
                    Picker("Priority", selection: $tempPriorityValue) {
                        ForEach(priorityLevels, id: \.self) { level in
                            Text(level).tag(level)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 150)
                    
                    HStack {
                        Button("Cancel") {
                            isPickerPresented = false
                        }
                        .padding()
                        
                        Spacer()
                        
                        Button("Done") {
                            // Update the selected field with the chosen value
                            if let field = selectedField {
                                switch field {
                                case "Air quality":
                                    airQualityPriority = tempPriorityValue
                                case "Physical activity":
                                    physicalActivityPriority = tempPriorityValue
                                case "Time":
                                    timePriority = tempPriorityValue
                                case "Distance":
                                    distancePriority = tempPriorityValue
                                case "Traffic":
                                    trafficPriority = tempPriorityValue
                                case "Public transit transfers":
                                    publicTransitPriority = tempPriorityValue
                                default:
                                    break
                                }
                            }
                            isPickerPresented = false
                        }
                        .padding()
                    }
                }
                .padding()
            }
        }
    }
    
    func savePreferences() {
        isLoading = true
        guard let currentUser = Auth.auth().currentUser else {
            errorMessage = "User not logged in"
            isLoading = false
            return
        }
        
        let db = Firestore.firestore()
        let preferencesRef = db.collection("preferences").document(currentUser.uid)
        
        let preferencesData: [String: Any] = [
            "airQualityPriority": airQualityPriority,
            "physicalActivityPriority": physicalActivityPriority,
            "timePriority": timePriority,
            "distancePriority": distancePriority,
            "trafficPriority": trafficPriority,
            "publicTransitPriority": publicTransitPriority,
            "optimalSensitivity": optimalSensitivity,
            "optimalAirFactors": optimalAirFactors,
            "dailyStepGoal": dailyStepGoal,
            "calorieBurnGoal": calorieBurnGoal,
            "avoidTolls": avoidTolls,
            "avoidHighways": avoidHighways,
            "avoidFerries": avoidFerries
        ]
        
        preferencesRef.setData(preferencesData) { error in
            isLoading = false
            if let error = error {
                errorMessage = "Failed to save preferences: \(error.localizedDescription)"
            } else {
                isSuccessMessageShown = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isSuccessMessageShown = false
                }
            }
        }
    }
    
    // Helper view for editable rows
    private func editableRow(title: String, value: Binding<String>) -> some View {
        NavigationLink(destination: TextField(title, text: value)
                        .padding()
                        .navigationTitle(title)
        ) {
            HStack {
                Text(title)
                Spacer()
                Text(value.wrappedValue)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // Helper view for selectable rows with a sheet-based picker
    private func selectableRow(title: String, value: Binding<String>) -> some View {
        Button(action: {
            selectedField = title
            tempPriorityValue = value.wrappedValue
            isPickerPresented = true
        }) {
            HStack {
                Text(title)
                Spacer()
                Text(value.wrappedValue)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}

