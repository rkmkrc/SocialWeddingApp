//
//  TestModels.swift
//  WeddApp
//
//  Created by Erkam Karaca on 8.07.2023.
//

import Foundation

struct TestModels {
    static var groom = Groom(name: "JohnT", surname: "BrownT", image: "groom")
    static var bride = Bride(name: "EmmaT", surname: "WatsonT", image: "bride")
    static var wedding = Wedding(id: "2", groom: groom, bride: bride, date: "01.01.2001T", location: "\u{1F309} CaliforniaT \u{1F309}", welcomeMessage: "We are so happy to see you among us. Grateful to you.T \n\u{1F33A}", album: [])
}

