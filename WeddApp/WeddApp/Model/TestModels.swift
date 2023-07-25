//
//  TestModels.swift
//  WeddApp
//
//  Created by Erkam Karaca on 8.07.2023.
//

import Foundation

struct TestModels {
    static var groom = Groom(name: "John", surname: "Brown", image: "groom")
    static var bride = Bride(name: "Emma", surname: "Watson", image: "bride")
    static var wedding = Wedding(id: 2, groom: groom, bride: bride, date: "01.01.2001", location: "\u{1F309} California \u{1F309}", welcomeMessage: "We are so happy to see you among us. Grateful to you. \n\u{1F33A}", album: Constants.album)
}

