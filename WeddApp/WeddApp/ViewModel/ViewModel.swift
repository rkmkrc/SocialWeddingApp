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
    @Published var weddings = [Wedding]()
    @Published var wed: Wedding?
    private let db = Firestore.firestore()
    
    init(id: String) {
        self.id = id // Initialize the pin value
    }
    
    func getWedding() {
        print("----------------------------------- Get Wedd \(id) -----------------------------------")
        // Reference for db
        let docRef = db.collection("Weddings").document(id)
        docRef.getDocument { (document, error) in
            if let error = error {
                // Error Handling
                print("Error getting document: \(error)")
                return
            }

            if let document = document, document.exists {
                DispatchQueue.main.async {
                    // Extract groom and bride data from the document
                    let groomData = document["groom"] as? [String: Any] ?? [:]
                    let brideData = document["bride"] as? [String: Any] ?? [:]

                    // Create Groom and Bride objects
                    let groom = Groom(
                        name: groomData["name"] as? String ?? "",
                        surname: groomData["surname"] as? String ?? "",
                        image: groomData["image"] as? String ?? ""
                    )

                    let bride = Bride(
                        name: brideData["name"] as? String ?? "",
                        surname: brideData["surname"] as? String ?? "",
                        image: brideData["image"] as? String ?? ""
                    )

                    // Create Wedding object
                    self.wed = Wedding(
                        id: document.documentID,
                        groom: groom,
                        bride: bride,
                        date: String(describing: document["date"] ?? "1990"),
                        location: String(describing: document["location"] ?? "location"),
                        welcomeMessage: String(describing: document["welcomeMessage"] ?? "welcome"),
                        album: []
                    )
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    
    func createWedding(id: String) {
        let wedding = Wedding(id: id,
                              groom: Groom(name: "Hasan", surname: "Brown", image: "groom"),
                              bride: Bride(name: "Emma", surname: "Watson", image: "bride"),
                              date: "12.12.2012",
                              location: "Uvacuh",
                              welcomeMessage: "Niye Geldiniz?",
                              album: [])
        let weddingData = wedding.toDictionary()
        db.collection("Weddings").document("\(wedding.id)").setData(weddingData) { error in
            if let error = error {
                print("Error writing wedding to Firestore: \(error)")
            } else {
                print("Wedding document successfully set!")
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
