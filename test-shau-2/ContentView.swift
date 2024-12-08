
///
///
///
///
///
//////
////  ContentView.swift
////  test-shau-2
////
////  Created by Shaunak Umarkhedi on 07/11/24.
////
///
///
///
///
///
import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isSignedIn = false

    let firebaseManager = FirebaseManager()

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                Button("Sign In") {
                    AuthenticationService.shared.signIn(email: email, password: password) { result in
                        switch result {
                        case .success(let user):
                            print("User signed in: \(user.uid)")
                            isSignedIn = true
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                        }
                    }
                }
                .buttonStyle(DefaultButtonStyle())
            }
            .padding()
            .navigationTitle("Sign In")
            .navigationDestination(isPresented: $isSignedIn) {
                SettingsView()
            }
        }
    }
}

//struct SettingsView: View {
//    var body: some View {
//        Text("Settings View")
//        .navigationTitle("Settings")
//    }
//}

#Preview {
    ContentView()
}
///
///
///
///
///
//
//import SwiftUI
//import FirebaseAuth
//
//
//struct ContentView: View {
//    @State private var email = "";
//    @State private var password = "";
//    @State private var errorMessage: String?
//    @State private var isSignedIn = false // Add this state variable
//
//
//    let firebaseManager = FirebaseManager()
//
//    var body: some View {
//        VStack {
//            TextField("Email", text: $email)
//            .textFieldStyle(RoundedBorderTextFieldStyle())
//        
//        SecureField("Password", text: $password)
//            .textFieldStyle(RoundedBorderTextFieldStyle())
//        
//        if let errorMessage = errorMessage {
//            Text(errorMessage)
//                .foregroundColor(.red)
//        }
//        
//        Button("Sign In") {
//            AuthenticationService.shared.signIn(email: email, password: password) { result in
//                switch result {
//                case .success(let user):
//                    print("User signed in: \(user.uid)")
//                    // Navigate to next screen or update app state
//                    isSignedIn = true;
//                    
//                case .failure(let error):
//                    errorMessage = error.localizedDescription
//                }
//            }
//        }
//        .buttonStyle(DefaultButtonStyle())
//            
//            
//        NavigationLink(
//            destination: SettingsView(),
//            isActive: $isSignedIn
//        ) {
//            EmptyView()
//        }
//
//        
////            Button("Add Item") {
////               let data = ["name": "Sample Item", "description": "This is a sample item"]
////               firebaseManager.addItem(data: data, collection: "items")
////           }
////            
////            Button("Read Items") {
////                           firebaseManager.readItems(collection: "items") { documents in
////                               documents?.forEach { document in
////                                   print(document.data())
////                               }
////                           }
////                       }
////                       
////                       Button("Update Item") {
////                           let data = ["name": "Updated Item"]
////                           firebaseManager.updateItem(documentId: "your-document-id", data: data, collection: "items")
////                       }
////                       
////                       Button("Delete Item") {
////                           firebaseManager.deleteItem(documentId: "your-document-id", collection: "items")
////                       }
//            
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ContentView()
//}
