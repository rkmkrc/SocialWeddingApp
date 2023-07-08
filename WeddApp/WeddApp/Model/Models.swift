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
    let title: String
    let date: String
    let location: String
    let welcomeMessage: String
}
protocol Person {
    var name: String?{get}
    var surname: String?{get}
    var image: String?{get}
}

