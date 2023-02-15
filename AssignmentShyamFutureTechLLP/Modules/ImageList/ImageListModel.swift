//
//  ImageListModel.swift
//  AssignmentShyamFutureTechLLP
//
//  Created by openweb on 14/02/23.
//

import Foundation

struct ImageItem: Decodable, Identifiable {
    let id, author: String
    let width, height: Int
    let url, downloadURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}
