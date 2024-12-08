import FirebaseFirestore

class FirebaseManager {
    let db = Firestore.firestore()
    
    func addItem(data: [String: Any], collection: String) {
        db.collection(collection).addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
            }
        }
    }
    
    func readItems(collection: String, completion: @escaping ([DocumentSnapshot]?) -> Void) {
        db.collection(collection).getDocuments { snapshot, error in
            if let error = error {
                print("Error reading documents: \(error)")
                completion(nil)
            } else {
                completion(snapshot?.documents)
            }
        }
    }
    
    func updateItem(documentId: String, data: [String: Any], collection: String) {
        db.collection(collection).document(documentId).updateData(data) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document updated successfully")
            }
        }
    }
    
    func deleteItem(documentId: String, collection: String) {
        db.collection(collection).document(documentId).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document deleted successfully")
            }
        }
    }
}

