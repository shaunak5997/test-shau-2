import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthenticationService {
    static let shared = AuthenticationService()
    
    private init() {}
    
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = authResult?.user else {
                completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user found"])))
                return
            }
            
            // Create a user document in Firestore
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "uid": user.uid,
                "email": email,
                "createdAt": FieldValue.serverTimestamp()
            ]
            
            db.collection("users").document(user.uid).setData(userData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(user))
                }
            }
            
            
            completion(.success(user))
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = authResult?.user else {
                completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user created"])))
                return
            }
            
            completion(.success(user))
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
