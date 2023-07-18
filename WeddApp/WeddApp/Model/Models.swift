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
struct Bride {
    var name: String
    var surname: String
    let image: String
}
struct Groom {
    var name: String
    var surname: String
    let image: String
}
struct Wedding {
    let id: Int
    let groom: Groom
    let bride: Bride
    let date: String
    let location: String
    let welcomeMessage: String
    let album: [Photo]
    var title: String {
        

        return "\(groom.name) \u{2764} \(bride.name)"
    }
    
    init(id: Int, groom: Groom, bride: Bride, date: String, location: String, welcomeMessage: String, album: [Photo]) {
        self.id = id
        self.groom = groom
        self.bride = bride
        self.date = date
        self.location = location
        self.welcomeMessage = welcomeMessage
        self.album = album
    }
}

protocol Person {
    var name: String?{get}
    var surname: String?{get}
    var image: String?{get}
}

