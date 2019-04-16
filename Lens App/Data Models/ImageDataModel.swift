//
//  IMageDataModel.swift
//  Lens App
//
//  Created by Apple on 13/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation

struct ImageDetails {
    var image: URL!
    var id: Int!
    var downloadStatus: Int!
    var isCompleteCache = false
    init(imageDetails: JSONDictionary) {
        self.image = URL(string: BASE_URL.appending(imageDetails[APIKeys.kImage] as? String ?? ""))
        self.id = imageDetails[APIKeys.kId] as? Int ?? 0
        self.downloadStatus = imageDetails[APIKeys.kStatus] as? Int ?? 0
    }
}

struct MyImagesDetails {
    var name: String!
    var rating: Double!
    var id: Int!
    var image: URL?
    var imageCount: Int!
    var isDownloaded: Bool!

    init(userDetails: JSONDictionary) {
        self.name = userDetails[APIKeys.kFullName] as? String ?? kEmptyString
        self.id = userDetails[APIKeys.kId] as? Int ?? 0
        self.rating = userDetails[APIKeys.kRating] as? Double ?? 0.0
        self.image = URL(string: userDetails[APIKeys.kImage] as? String ?? "")
        self.imageCount = userDetails[APIKeys.kImageCount] as? Int ?? 0
        self.isDownloaded = userDetails[APIKeys.kDownloadComplete] as? Bool ?? false
    }
}

