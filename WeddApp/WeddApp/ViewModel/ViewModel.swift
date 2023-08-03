//
//  ViewModel.swift
//  WeddApp
//
//  Created by Erkam Karaca on 26.07.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ViewModel: ObservableObject {
    var id: String = ""
    @Published var wed: Wedding?
    private let db = Firestore.firestore()
    
    // Wedding pin value
    init(id: String) {
        self.id = id
    }
    
    func getImageUrlOf(person: String, completion: @escaping (String?, Error?) -> Void) {
        let docRef = db.collection("Images").document(id)
        docRef.getDocument { (document, error) in
            if let error = error {
                processWeddingError(error: .documentError(error.localizedDescription))
                completion(nil, error)
                return
            }
            
            if let document = document, document.exists {
                let imageUrl = document["\(person)Url"] as? String ?? Constants.DEFAULT_IMAGE_URL
                completion(imageUrl, nil)
            } else {
                completion(Constants.DEFAULT_IMAGE_URL, nil)
            }
        }
    }

    // Fetching wedding from Firebase
    func getWedding() {
        let docRef = db.collection("Weddings").document(id)
        docRef.getDocument { (document, error) in
            if let error = error {
                processWeddingError(error: .documentError(error.localizedDescription))
                return
            }
            
            if let document = document, document.exists {
                DispatchQueue.main.async {
                    // Extract groom and bride data from the document
                    let groomData = document["groom"] as? [String: Any] ?? [:]
                    let brideData = document["bride"] as? [String: Any] ?? [:]
                    
                    // Create Groom and Bride objects
                    let groom = Groom(
                        name: groomData["name"] as? String ?? Constants.DEFAULT_NAME,
                        surname: groomData["surname"] as? String ?? Constants.DEFAULT_SURNAME,
                        image: groomData["image"] as? String ?? Constants.PLACEHOLDER_BRIDE_IMAGE
                    )
                    
                    let bride = Bride(
                        name: brideData["name"] as? String ?? Constants.DEFAULT_NAME,
                        surname: brideData["surname"] as? String ?? Constants.DEFAULT_SURNAME,
                        image: brideData["image"] as? String ?? Constants.PLACEHOLDER_BRIDE_IMAGE
                    )
                    
                    self.wed = Wedding(
                        id: document.documentID,
                        groom: groom,
                        bride: bride,
                        date: String(describing: document["date"] ?? Constants.DEFAULT_DATE),
                        location: String(describing: document["location"] ?? Constants.DEFAULT_LOCATION),
                        welcomeMessage: String(describing: document["welcomeMessage"] ?? Constants.DEFAULT_WELCOME_MESSAGE),
                        album: []
                    )
                }
            } else {
                processWeddingError(error: .documentError("There is no wedding with this id."))
            }
        }
    }

    func uploadWedding(groom: Groom, bride: Bride, wedding: Wedding) {
        let weddingData = wedding.toDictionary()
        
            // Use the user's UID as the document ID for the wedding
        if let id = wedding.id {
            db.collection("Weddings").document(id).setData(weddingData) { error in
                if let error = error {
                    processWeddingError(error: WeddingError.firestoreError(error.localizedDescription))
                } else {
                    SuccessOperations.onSuccess(message: SuccessOperations.DOC_SET)
                }
            }
        } else {
            print("Error - wedding id is nil!!!")
        }
        
    }

    
    func isWeddingExist(id: String, completion: @escaping (Bool) -> Void) {
        let docRef = db.collection("Weddings").document(id)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func getWeddingIDFromUser(completion: @escaping (String?, Error?) -> Void) {
        if let user = Auth.auth().currentUser {
            let userID = user.uid
            
            let docRef = db.collection("Users").document(userID)
            docRef.getDocument { (document, error) in
                if let error = error {
                    completion(nil, error) // Call the completion closure with the error
                    return
                }
                
                if let document = document, document.exists {
                    // Extract groom and bride data from the document
                    if let weddingID = document["weddingID"] as? String {
                        DispatchQueue.main.async {
                            completion(weddingID, nil) // Call the completion closure with the retrieved weddingID
                        }
                    } else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No weddingID found in the document."])
                        completion(nil, error) // Call the completion closure with the error
                    }
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "There is no wedding ID associated with this user ID."])
                    completion(nil, error) // Call the completion closure with the error
                }
            }
        }
    }

        
}
