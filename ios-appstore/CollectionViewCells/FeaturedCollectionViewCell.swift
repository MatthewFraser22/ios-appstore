//
//  FeaturedCollectionViewCell.swift
//  ios-appstore
//
//  Created by Matthew Fraser on 2022-08-09.
//

import UIKit

class FeaturedCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {
    static var reuseIdentifier: String = "FeaturedCell"

    // MARK: Properties

    private var tagline = UILabel()
    private var appNameLabel = UILabel()
    private var subtitle = UILabel()
    private var appImage = UIImageView()

    // MARK: Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let separator = UIView(frame: .zero)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .quaternaryLabel

        tagline.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .bold))
        tagline.textColor = .systemBlue

        appNameLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        appNameLabel.textColor = .label

        subtitle.font = UIFont.preferredFont(forTextStyle: .title2)
        subtitle.textColor = .secondaryLabel
        
        appImage.layer.cornerRadius = 5
        appImage.clipsToBounds = true
        appImage.contentMode = .scaleAspectFit
        
        let verticalStackView = UIStackView(arrangedSubviews: [separator, tagline, appNameLabel, subtitle, appImage])
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillProportionally
        contentView.addSubview(verticalStackView)
        

        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        verticalStackView.setCustomSpacing(10, after: separator)
        verticalStackView.setCustomSpacing(5, after: subtitle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: SectionItem) {
        tagline.text = item.tagline.uppercased()
        appNameLabel.text = item.name
        subtitle.text = item.subheading
        appImage.image = UIImage(named: item.image)
    }
}
