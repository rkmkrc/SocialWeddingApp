//
//  Utilities.swift
//  WeddApp
//
//  Created by Erkam Karaca on 8.07.2023.
//
import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore

extension Notification.Name {
    static let correctPINEntered = Notification.Name("correctPINEntered")
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

func uploadPhoto(image: UIImage?) {
    print("UPLOAD PHOTO \(image?.description)")
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
    let path = "images/\(UUID().uuidString).png"
    let fileRef = storageRef.child(path)
    
    // Upload data
    fileRef.putData(imageData!) { metadata, error in
        
        if error == nil && metadata != nil {
            // Save a referace to Firestore DB
            print("----------")
            let db = Firestore.firestore()
            db.collection("Images").document().setData(["url": path])
            
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
