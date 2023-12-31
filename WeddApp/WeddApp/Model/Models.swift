//
//  Models.swift
//  WeddApp
//
//  Created by Erkam Karaca on 8.07.2023.
//

import Foundation
import FirebaseFirestore

struct Bride: Codable {
    var name: String?
    var surname: String?
    let image: String?
}
struct Groom: Codable {
    var name: String?
    var surname: String?
    let image: String?
}
struct Wedding: Codable, Identifiable {
    let id: String?
    let groom: Groom?
    let bride: Bride?
    let date: String?
    let location: String?
    let welcomeMessage: String?
    var title: String {
        return "\(self.groom?.name ?? Constants.DEFAULT_NAME) \n \u{2764} \n \(self.bride?.name ?? Constants.DEFAULT_NAME)"
    }
    
    init(id: String, groom: Groom, bride: Bride, date: String, location: String, welcomeMessage: String, album: [Photo]) {
        self.id = id
        self.groom = groom
        self.bride = bride
        self.date = date
        self.location = location
        self.welcomeMessage = welcomeMessage
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id ?? "0",
            "groom": [
                "name": groom?.name ?? Constants.DEFAULT_NAME,
                "surname": groom?.surname ?? Constants.DEFAULT_SURNAME,
                "image": groom?.image ?? Constants.PLACEHOLDER_GROOM_IMAGE
            ],
            "bride": [
                "name": bride?.name ?? Constants.DEFAULT_NAME,
                "surname": bride?.surname ?? Constants.DEFAULT_SURNAME,
                "image": bride?.image ?? Constants.PLACEHOLDER_BRIDE_IMAGE
            ],
            "date": date ?? Constants.DEFAULT_DATE,
            "location": location ?? Constants.DEFAULT_LOCATION,
            "welcomeMessage": welcomeMessage ?? Constants.DEFAULT_WELCOME_MESSAGE
        ]
    }
}

struct Wish: Identifiable {
    let id = UUID()
    let guestName: String
    let wish: String
    let date: String
    
    init(guestName: String, wish: String, date: Date) {
        self.guestName = guestName
        self.wish = wish
        self.date = formatDateToString(date: date)
    }
    
    init?(document: QueryDocumentSnapshot) {
        guard
            let guestName = document.data()["guestName"] as? String,
            let wish = document.data()["wish"] as? String,
            let date = document.data()["date"] as? String
        else {
            return nil
        }
        
        self.guestName = guestName
        self.wish = wish
        self.date = date
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "guestName": guestName,
            "wish": wish,
            "date": date,
        ]
    }
}
