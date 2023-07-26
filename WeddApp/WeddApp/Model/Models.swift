//
//  Models.swift
//  WeddApp
//
//  Created by Erkam Karaca on 8.07.2023.
//

import Foundation

struct NetworkBride: Person {
    var name: String?
    var surname: String?
    let image: String?
}
struct NetworkGroom: Person {
    var name: String?
    var surname: String?
    let image: String?
}
struct Bride: Codable {
    var name: String
    var surname: String
    let image: String
}
struct Groom: Codable {
    var name: String
    var surname: String
    let image: String
}
struct Wedding: Codable, Identifiable {
    let id: String
    let groom: Groom
    let bride: Bride
    let date: String
    let location: String?
    let welcomeMessage: String
    var title: String {
        return "\(self.groom.name) \u{2764} \(self.bride.name)"
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
            "id": id,
            "groom": [
                "name": groom.name,
                "surname": groom.surname,
                "image": groom.image
            ],
            "bride": [
                "name": bride.name,
                "surname": bride.surname,
                "image": bride.image
            ],
            "date": date,
            "location": location ?? "x",
            "welcomeMessage": welcomeMessage
        ]
    }
}

protocol Person {
    var name: String?{get}
    var surname: String?{get}
    var image: String?{get}
}

