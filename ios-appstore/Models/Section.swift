//
//  Section.swift
//  ios-appstore
//
//  Created by Matthew Fraser on 2022-08-09.
//

import Foundation

struct Section: Decodable, Hashable {
    let id: Int
    let type: String
    let title: String
    let subtitle: String
    let items: [SectionItem]
}
