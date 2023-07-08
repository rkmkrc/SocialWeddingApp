//
//  TestModels.swift
//  WeddApp
//
//  Created by Erkam Karaca on 8.07.2023.
//

import Foundation

struct TestModels {
    static var groom = Groom(name: "Ali", surname: "Yılmaz", image: "groom")
    static var bride = Bride(name: "Fatma", surname: "Yılar", image: "bride")
    static var wedding = Wedding(id: 1, groom: groom, bride: bride, title: "Ali & Fatma", date: "01.01.2001", location: "Istanbul", welcomeMessage: "Sizleri aramızda gördüğümüz için çok mutluyuz.")
}

