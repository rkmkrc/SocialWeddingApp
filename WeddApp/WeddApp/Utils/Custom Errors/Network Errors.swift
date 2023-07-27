//
//  Network Errors.swift
//  WeddApp
//
//  Created by Erkam Karaca on 25.07.2023.
//

import Foundation

enum WeddingError: Error {
    case invalidData
    case networkError(String)
    case firestoreError(String)
    case documentError(String)
}

func processWeddingError(error: WeddingError) {
    switch error {
       case .invalidData:
           print("Invalid data received.")
       case .networkError(let message):
           print("Network error occurred: \(message)")
       case .firestoreError(let message):
           print("Firestore error occurred: \(message)")
       case .documentError(let message):
           print("Document error occurred: \(message)")
       }
}
  
