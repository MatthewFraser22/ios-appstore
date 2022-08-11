//
//  SelfConfiguringCell.swift
//  ios-appstore
//
//  Created by Matthew Fraser on 2022-08-09.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with item: SectionItem)
}
