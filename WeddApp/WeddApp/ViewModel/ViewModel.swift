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
    
    func getImageOf(person: String, completion: @escaping (UIImage?, Error?) -> Void) {
        let docRef = db.collection(Constants.IMAGES_COLLECTION).document(id)
        docRef.getDocument { (document, error) in
            if let error = error {
                processWeddingError(error: .documentError(error.localizedDescription))
                completion(nil, error)
                return
            }
            if let document = document, document.exists {
                let imageUrl = document["\(person)Url"] as? String ?? Constants.DEFAULT_IMAGE_URL
                retrieveImage(withURL: imageUrl, completion: { image in
                    if let image = image {
                        completion(image,nil)
                    }
                })
            } else {
                completion(nil,error)
            }
        }
    }
    
    func getGalleryUrls(completion: @escaping ([String], Error?) -> Void) {
        let docRef = db.collection(Constants.GALLERY_COLLECTION).document(id)
        docRef.getDocument { (document, error) in
            if let error = error {
                processWeddingError(error: .documentError(error.localizedDescription))
                completion([], error)
                return
            }
            if let document = document, document.exists {
                var urls: [String] = []
                
                if let data = document.data() {
                    for (key, value) in data {
                        if let keyString = key as? String, keyString.hasPrefix("photo"), let imageUrl = value as? String {
                            urls.append(imageUrl)
                        }
                    }
                }
                completion(urls, nil)
            } else {
                completion([], nil)
            }
        }
    }
    
    func retrieveGallery(completion: @escaping ([UIImage?]) -> Void) {
        getGalleryUrls { urlArray, error in
            if let error = error {
                processWeddingError(error: WeddingError.galleryUrlError(error.localizedDescription))
            } else {
                var galleryPhotos: [UIImage?] = []
                let dispatchGroup = DispatchGroup() // Use dispatch group for synchronization
                
                for url in urlArray {
                    dispatchGroup.enter() // Enter the dispatch group
                    
                    retrieveImage(withURL: url) { image in
                        galleryPhotos.append(image)
                        dispatchGroup.leave() // Leave the dispatch group when image is retrieved
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    DispatchQueue.main.async {
                        completion(galleryPhotos) // Call the completion block once all images are retrieved
                    }
                }
            }
        }
    }
    
    // Fetching wedding from Firebase
    func getWedding() {
        let docRef = db.collection(Constants.WEDDINGS_COLLECTION).document(id)
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
        
        if let id = wedding.id {
            db.collection(Constants.WEDDINGS_COLLECTION).document(id).setData(weddingData) { error in
                if let error = error {
                    processWeddingError(error: WeddingError.firestoreError(error.localizedDescription))
                } else {
                    SuccessOperations.onSuccess(message: SuccessOperations.DOC_SET)
                }
            }
        } else {
            processWeddingError(error: .documentError("Error: Wedding id is nil!"))
        }
        
    }
    
    func isWeddingExist(id: String, completion: @escaping (Bool) -> Void) {
        let docRef = db.collection(Constants.WEDDINGS_COLLECTION).document(id)
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
            
            let docRef = db.collection(Constants.USERS_COLLECTION).document(userID)
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
    
    func uploadWish(wish: Wish) {
        let db = Firestore.firestore()
        let guestsCollection = db.collection(Constants.GUESTS_COLLECTION).document(id).collection(Constants.GUESTS_COLLECTION)
        let newGuestDocument = guestsCollection.document()
        let guestID = newGuestDocument.documentID
        UserDefaults.standard.set(guestID, forKey: "guestID-\(id)")
        
        newGuestDocument.setData(wish.toDictionary()) { error in
            if let error = error {
                // handle pop up
                processWeddingError(error: WeddingError.firestoreError(error.localizedDescription))
            } else {
                SuccessOperations.onSuccess(message: SuccessOperations.WISH_CREATED)
                print(guestID)
            }
        }
        
    }
    
    func getWishes(completion: @escaping ([Wish], Error?) -> Void) {
        let guestsCollection = db.collection(Constants.GUESTS_COLLECTION).document(id).collection(Constants.GUESTS_COLLECTION)
        
        guestsCollection.getDocuments { snapshot, error in
            if let error = error {
                completion([], error)
                return
            }
            
            var wishes: [Wish] = []
            for document in snapshot?.documents ?? [] {
                if let wish = Wish(document: document) {
                    wishes.append(wish)
                }
            }
            completion(wishes, nil)
        }
    }
}

