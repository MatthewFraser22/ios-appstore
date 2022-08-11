//
//  SectionItem.swift
//  ios-appstore
//
//  Created by Matthew Fraser on 2022-08-09.
//

import Foundation

struct SectionItem: Decodable, Hashable {
    let id: Int
    let tagline: String
    let name: String
    let subheading: String
    let image: String
    let iap: Bool
}
