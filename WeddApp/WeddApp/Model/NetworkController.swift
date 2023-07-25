//
//  NetworkController.swift
//  WeddApp
//
//  Created by Erkam Karaca on 25.07.2023.
//

import Foundation
import Combine
import FirebaseFirestore

struct WeddingNetworkController {
    private let db = Firestore.firestore()
    private let collectionRef = Firestore.firestore().collection("Weddings")

    func getWeddingWithID(id: String, completion: @escaping (Result<Wedding, Error>) -> Void) {
        let query = collectionRef.whereField("id", isEqualTo: id)

        query.getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(WeddingError.firestoreError(error.localizedDescription)))
            } else {
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    completion(.failure(WeddingError.documentError(error?.localizedDescription ?? "")))
                    return
                }
                if documents.count != 1 {
                    completion(.failure(WeddingError.documentError("There are multiple documents with this id.")))
                    return
                }
                let weddingDocument = documents[0]
                do {
                    // Use JSONSerialization to convert Firestore data to JSON Data
                    let jsonData = try JSONSerialization.data(withJSONObject: weddingDocument.data(), options: [])
                    // Use JSONDecoder to decode JSON Data to the Wedding object
                    let wedding = try JSONDecoder().decode(Wedding.self, from: jsonData)
                    print(wedding)
                    completion(.success(wedding))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}
