//
//  MediumTable.swift
//  ios-appstore
//
//  Created by Matthew Fraser on 2022-08-09.
//

import UIKit

class MediumTableCell: UICollectionViewCell, SelfConfiguringCell {
    static var reuseIdentifier: String = "MediumTable"

    // MARK:
    private var imageView = UIImageView()
    private var name = UILabel()
    private var subtitle = UILabel()
    private var buybutton = UIButton(type: .custom)

    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        name.font = UIFont.preferredFont(forTextStyle: .headline)
        name.textColor = .label

        subtitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitle.textColor = .secondaryLabel

        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        buybutton.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        buybutton.setImage(UIImage(systemName: "icloud.and.arrow.down"), for: .normal)

        let verticalStackView = UIStackView(arrangedSubviews: [name, subtitle])
        verticalStackView.axis = .vertical

        let horizontalStackView = UIStackView(arrangedSubviews: [imageView, verticalStackView, buybutton])
        horizontalStackView.axis = .horizontal
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.spacing = 10
        horizontalStackView.contentMode = .center

        contentView.addSubview(horizontalStackView)

        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: SectionItem) {
        imageView.image = UIImage(named: item.image)
        name.text = item.name
        subtitle.text = item.subheading
    }
}
