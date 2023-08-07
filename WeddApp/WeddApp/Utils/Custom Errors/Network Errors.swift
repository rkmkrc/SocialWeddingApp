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
    case imageGettingError(String)
    case urlError(String)
    case dataToImageError(String)
    case generatingIDError(String)
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
       case .imageGettingError(let message):
          print("Error while getting url of image: \(message)")
       case .urlError(let message):
          print("URL Error: \(message)")
       case .dataToImageError(let message):
          print("Error while converting data to image: \(message)")
       case .generatingIDError(let message):
          print("Error generating unique ID: \(message)")
    }
}
  
