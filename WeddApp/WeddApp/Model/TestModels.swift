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
    static var wedding = Wedding(id: 1, groom: groom, bride: bride, date: "01.01.2001", location: "Istanbul", welcomeMessage: "Sizleri aramızda gördüğümüz için çok mutluyuz. Sizleri aramızda gördüğümüz için çok mutluyuz. Sizleri aramızda gördüğümüz için çok mutluyuz. ")
}

