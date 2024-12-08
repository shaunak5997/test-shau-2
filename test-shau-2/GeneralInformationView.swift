import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct GeneralInformationView: View {
    // User information state variables
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var emergencyContact: String = ""
    
    // Error message and loading state
    @State private var errorMessage: String? = nil
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            if isLoading {
                ProgressView("Loading...")
            } else if let error = errorMessage {
                VStack {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Button(action: fetchUserData) {
                        Text("Retry")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            } else {
                Form {
                    Section(header: Text("PROFILE")) {
                        NavigationLink(destination: Text("Username")) {
                            Text("Username")
                            Spacer()
                            Text(username)
                                .foregroundColor(.secondary)
                        }
                        NavigationLink(destination: Text("Email")) {
                            Text("Email")
                            Spacer()
                            Text(email)
                                .foregroundColor(.secondary)
                        }
                        NavigationLink(destination: Text("Phone number")) {
                            Text("Phone number")
                            Spacer()
                            Text(phoneNumber)
                                .foregroundColor(.secondary)
                        }
                    }

                    Section(header: Text("SAFETY")) {
                        NavigationLink(destination: Text("Emergency contact")) {
                            Text("Emergency contact")
                            Spacer()
                            Text(emergencyContact)
                                .foregroundColor(.secondary)
                        }
                    }

                    Section(header: Text("ACCOUNT MANAGEMENT")) {
                        NavigationLink(destination: Text("Login and security")) {
                            Text("Login and security")
                        }
                        NavigationLink(destination: Text("Data export")) {
                            Text("Data export")
                        }
                        NavigationLink(destination: Text("Deactivate account")) {
                            Text("Deactivate account")
                        }
                    }
                }
                .navigationBarTitle("General Information", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: fetchUserData) {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
            }
        }
        .onAppear {
            fetchUserData()
        }
    }
    
    /// Fetches the user data from Firestore for the currently logged-in user
    func fetchUserData() {
        // Show loading spinner and reset any prior errors
        isLoading = true
        errorMessage = nil
        
        // Ensure user is logged in
        guard let currentUser = Auth.auth().currentUser else {
            errorMessage = "User not logged in"
            isLoading = false
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUser.uid)
        
        userRef.getDocument { (document, error) in
            // Stop loading indicator
            isLoading = false
            
            if let error = error {
                errorMessage = "Error fetching user data: \(error.localizedDescription)"
                return
            }
            
            guard let document = document, document.exists, let data = document.data() else {
                errorMessage = "User document not found"
                return
            }
            
            // Populate fields from Firestore document
            username = data["username"] as? String ?? "No username"
            email = currentUser.email ?? "No email"
            phoneNumber = data["phoneNumber"] as? String ?? "No phone number"
            emergencyContact = data["emergencyContact"] as? String ?? "No emergency contact"
        }
    }
}

struct GeneralInformationView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralInformationView()
    }
}

