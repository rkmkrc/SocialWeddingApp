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
    static let SIGNED_IN = "Signed In"
    static let SIGNED_UP = "Signed Up"
    static let IMAGE_FETCHED = "Image fetched successfully."
    static let IMAGE_UPLOADED = "Image uploaded successfully."
    static let IMAGE_URL_UPLOADED_TO_DB = "Image URL successfully set to DB."
    
    static func onSuccess(message: String) {
        print(message)
    }
}

struct OngoingOperations {
    static let PHOTO_UPLOADING = "Uploading photo."
    static let IMAGE_NIL = "Image is nil."
    static let IMAGE_DATA_NIL = "Image data is nil."
    
    static func inProgress(message: String) {
        print(message)
    }
}

func formatDateToString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    return dateFormatter.string(from: date)
}

func uploadGallery(selectedImages: [UIImage]?, weddingID: String, subfolder: String) {
    if let selectedImages = selectedImages {
        for (index, image) in selectedImages.enumerated() {
            uploadPhoto(image: image, weddingID: weddingID, subfolder: subfolder, isGallery: true, photoIndex: index + 1)
        }
    } else {
        print("Gallery images are nil.")
    }
}

func uploadPhoto(image: UIImage?, weddingID: String, subfolder: String, isGallery: Bool = false, photoIndex: Int = 0) {
    OngoingOperations.inProgress(message: OngoingOperations.PHOTO_UPLOADING)
    guard let image = image else {
        OngoingOperations.inProgress(message: OngoingOperations.IMAGE_NIL)
        return
    }
    
    // Create storage reference
    let storageRef = Storage.storage().reference()
    
    // Turn image to data
    guard let imageData = image.pngData() else {
        OngoingOperations.inProgress(message: OngoingOperations.IMAGE_DATA_NIL)
        return
    }
    
    // Specify the file path
    let path = "images/\(weddingID)/\(subfolder)/\(UUID().uuidString).png"
    let fileRef = storageRef.child(path)
    
    // Upload data
    fileRef.putData(imageData) { metadata, error in
        if error == nil && metadata != nil {
            SuccessOperations.onSuccess(message: SuccessOperations.IMAGE_UPLOADED)
            print("Image of \(weddingID)'s \(subfolder) successfully uploaded.")
            let db = Firestore.firestore()
            if isGallery {
                let galleryCollectionName = "Gallery"
                let photoDocumentName = "photo\(photoIndex)"
                let galleryDocumentReference = db.collection(galleryCollectionName).document(weddingID)

                let galleryData = [
                    photoDocumentName: path
                ]

                galleryDocumentReference.setData(galleryData, merge: true) { error in
                    if let error = error {
                        processWeddingError(error: WeddingError.urlError(error.localizedDescription))
                    } else {
                        SuccessOperations.onSuccess(message: SuccessOperations.IMAGE_URL_UPLOADED_TO_DB)
                    }
                }
            } else {
                let collectionName = "Images"
                let subfolderField = "\(subfolder)Url"
                
                let documentReference = db.collection(collectionName).document(weddingID)
                
                let data = [
                    subfolderField: path
                ]
                
                documentReference.setData(data, merge: true) { error in
                    if let error = error {
                        processWeddingError(error: WeddingError.urlError(error.localizedDescription))
                    } else {
                        SuccessOperations.onSuccess(message: SuccessOperations.IMAGE_URL_UPLOADED_TO_DB)
                    }
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
            processWeddingError(error: WeddingError.imageGettingError(error.localizedDescription))
            completion(nil)
            return
        }
        
        if let data = data, let image = UIImage(data: data) {
            // Image retrieved successfully
            DispatchQueue.main.async {
                completion(image)
                SuccessOperations.onSuccess(message: SuccessOperations.IMAGE_FETCHED)
            }
        } else {
            // Failed to convert data to image
            processWeddingError(error: WeddingError.dataToImageError(error?.localizedDescription ?? ""))
            completion(nil)
        }
    }
}

func generateUniqueID(completion: @escaping (String?, Error?) -> Void) {
    let db = Firestore.firestore()
    let usedIDsCollection = db.collection(Constants.USED_IDS_COLLECTION)
    
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
