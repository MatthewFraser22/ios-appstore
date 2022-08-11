//
//  SectionHeaderCollectionReusableView.swift
//  ios-appstore
//
//  Created by Matthew Fraser on 2022-08-10.
//

import UIKit

class SectionHeaderCollectionReusableView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderCollectionReusableView"

    // MARK: Properties

    var sectionTitle: UILabel = {
        let title = UILabel()
        title.textColor = .label
        title.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 22, weight: .bold))

        return title
    }()

    var sectionSubtitle: UILabel = {
        let section = UILabel()
        section.textColor = .secondaryLabel
        section.font = UIFont.preferredFont(forTextStyle: .subheadline)

        return section
    }()

    var sectionButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        button.configuration?.title = "See All"
        return button
    }()

    // MARK: Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let separator = UIView(frame: .zero)
        separator.backgroundColor = .quaternaryLabel
        separator.translatesAutoresizingMaskIntoConstraints = false

        let verticalStackView = UIStackView(arrangedSubviews: [sectionTitle, sectionSubtitle])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 3

        let horizontalStackView = UIStackView(arrangedSubviews: [verticalStackView, sectionButton])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 3

        let vStack = UIStackView(arrangedSubviews: [separator, horizontalStackView])
        vStack.axis = .vertical
        vStack.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(vStack)

        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            vStack.topAnchor.constraint(equalTo: self.topAnchor)
        ])

        vStack.setCustomSpacing(10, after: separator)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
