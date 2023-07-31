//
//  Constants.swift
//  WeddApp
//
//  Created by Erkam Karaca on 8.07.2023.
//

import Foundation

struct Constants {
    static let PLACEHOLDER_GROOM_IMAGE = ""
    static let PLACEHOLDER_BRIDE_IMAGE = ""
    static let TEXT_PADDING = 10.0
    static let IMAGE_PADDING = 20.0
    static let TOP_PADDING = 30.0
    static let DEFAULT_TITLE = "DefaultTitle"
    static let DEFAULT_DATE = "00.00.0000"
    static let DEFAULT_NAME = "DefaultName"
    static let DEFAULT_SURNAME = "DefaultSurame"
    static let DEFAULT_IMAGE = "DefaultImage"
    static let DEFAULT_LOCATION = "DefaultLocation"
    static let DEFAULT_WELCOME_MESSAGE = "DefaultWM"
    static let DEFAULT_WEDDING_ID = "9999"
    
    static let album: [Photo] = {
        var photos: [Photo] = []
        for i in 1...10 {
            photos.append(contentsOf: [Photo(name: "p\(i%6)"), Photo(name: "groom"), Photo(name: "bride")])
        }
        return photos.shuffled()
    }()

}
