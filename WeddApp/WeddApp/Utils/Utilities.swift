//
//  Utilities.swift
//  WeddApp
//
//  Created by Erkam Karaca on 8.07.2023.
//
import Foundation
import UIKit
import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore


extension Notification.Name {
    static let correctPINEntered = Notification.Name("correctPINEntered")
}
// An extension to limit text field inputs.
extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}

struct SuccessOperations {
    static let DOC_SET = "Wedding document successfully set!"
    static let USER_CREATED = "User created successfully!"
    
    static func onSuccess(message: String) {
        print(message)
    }
}

func formatDateToString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    return dateFormatter.string(from: date)
}


func uploadPhoto(image: UIImage?, weddingID: String, subfolder: String) {
    print("UPLOAD PHOTO \(String(describing: image?.description ?? ""))")
    guard image != nil else {
        print("image nil")
        return
    }
    // Create storage reference
    let storageRef = Storage.storage().reference()
    
    // Turn image to data
    let imageData = image!.pngData()
    
    guard imageData != nil else {
        print("turned data nil")
        return
    }
    
    // Specify the file path
    let path = "images/\(weddingID)/\(subfolder)/\(UUID().uuidString).png"
    let fileRef = storageRef.child(path)
    
    // Upload data
    fileRef.putData(imageData!) { metadata, error in
        
        if error == nil && metadata != nil {
            // Save a referace to Firestore DB
            print("Image of \(weddingID)'s \(subfolder) succesfully uploaded.")
            let db = Firestore.firestore()
            let collectionName = "Images"
            let subfolderField = "\(subfolder)Url"
            
            let documentReference = db.collection(collectionName).document(weddingID)

            // Create a dictionary with the new field to add (subfolderUrl)
            let data = [
                subfolderField: path
            ]

            // Use updateData to add the new field to the document
            documentReference.setData(data, merge: true) { error in
                if let error = error {
                    print("Error setting URL: \(error.localizedDescription)")
                } else {
                    print("Image of \(weddingID)'s \(subfolder) URL successfully set to DB.")
                }
            }
        }
    }
}

func retrieveImage(withURL imageURL: String, completion: @escaping (UIImage?) -> Void) {
    let storageReference = Storage.storage().reference()
    let fileRef = storageReference.child(imageURL)
    
    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
        if let error = error {
            // Handle the error if there is any
            print("Error retrieving image: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        if let data = data, let image = UIImage(data: data) {
            // Image retrieved successfully
            DispatchQueue.main.async {
                completion(image)
            }
        } else {
            // Failed to convert data to image
            completion(nil)
        }
    }
}

func generateUniqueID(completion: @escaping (String?, Error?) -> Void) {
    let db = Firestore.firestore()
    let usedIDsCollection = db.collection("UsedIDs")
    
    let randomID = String(format: "%04d", Int.random(in: 0..<10000))
    
    // Check if the generated ID is already in use
    usedIDsCollection.document(randomID).getDocument { snapshot, error in
        if let error = error {
            completion(nil, error)
            return
        }
        
        if snapshot?.exists == true {
            // The generated ID is already in use, try again
            generateUniqueID(completion: completion)
        } else {
            // The generated ID is unique, add it to the "UsedIDs" collection and return it
            usedIDsCollection.document(randomID).setData([:]) { error in
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(randomID, nil)
                }
            }
        }
    }
}
