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
struct Wedding: Codable {
    let id: Int
    let groom: Groom
    let bride: Bride
    let date: String
    let location: String
    let welcomeMessage: String
    var title: String {
        return "\(groom.name) \u{2764} \(bride.name)"
    }
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            // Decode the properties using the appropriate keys from CodingKeys
            id = try container.decode(Int.self, forKey: .id)
            groom = try container.decode(Groom.self, forKey: .groom)
            bride = try container.decode(Bride.self, forKey: .bride)
            date = try container.decode(String.self, forKey: .date)
            location = try container.decode(String.self, forKey: .location)
            welcomeMessage = try container.decode(String.self, forKey: .welcomeMessage)
        }
    init(id: Int, groom: Groom, bride: Bride, date: String, location: String, welcomeMessage: String, album: [Photo]) {
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
            "location": location,
            "welcomeMessage": welcomeMessage
        ]
    }
}

protocol Person {
    var name: String?{get}
    var surname: String?{get}
    var image: String?{get}
}

