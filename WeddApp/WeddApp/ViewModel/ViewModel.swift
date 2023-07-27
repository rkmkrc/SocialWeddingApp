//
//  ViewModel.swift
//  WeddApp
//
//  Created by Erkam Karaca on 26.07.2023.
//

import Foundation
import FirebaseFirestore

class ViewModel: ObservableObject {
    var id: String = ""
    @Published var wed: Wedding?
    private let db = Firestore.firestore()
    
    // Wedding pin value
    init(id: String) {
        self.id = id
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
    
    
    func createWedding(id: String, groom: Groom, bride: Bride, date: String, location: String, welcomeMessage: String) {
        let wedding = Wedding(id: id,
                              groom: groom,
                              bride: bride,
                              date: date,
                              location: location,
                              welcomeMessage: welcomeMessage,
                              album: [])
        let weddingData = wedding.toDictionary()
        db.collection("Weddings").document("\(wedding.id)").setData(weddingData) { error in
            if let error = error {
                processWeddingError(error: WeddingError.firestoreError(error.localizedDescription))
            } else {
                SuccessOperations.onSuccess(message: SuccessOperations.DOC_SET)
            }
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
}
