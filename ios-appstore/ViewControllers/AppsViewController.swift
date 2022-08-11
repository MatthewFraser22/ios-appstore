//
//  AppsViewController.swift
//  ios-appstore
//
//  Created by Matthew Fraser on 2022-08-06.
//

import Foundation
import UIKit

class AppsViewController: UIViewController {
    
    let sections = Bundle.main.decode([Section].self, from: "appstore.json")

    private var collectionView: UICollectionView!
    lazy var dataSource = { createDataSource() }()

    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, SectionItem>

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createCompositionalViewLayout()
        )

        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // collectionview fills the screen
        collectionView.backgroundColor = .systemBackground
        collectionView.frame = view.bounds
        view.addSubview(collectionView)

        // Cell Registation
        collectionView.register(FeaturedCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedCollectionViewCell.reuseIdentifier)
        collectionView.register(MediumTableCell.self, forCellWithReuseIdentifier: MediumTableCell.reuseIdentifier)
        collectionView.register(SmallTableCell.self, forCellWithReuseIdentifier: SmallTableCell.reuseIdentifier)
        collectionView.register(SectionHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderCollectionReusableView.reuseIdentifier)

        collectionView.dataSource = self.dataSource
        reloadData()
    }

    private func createCompositionalViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            switch self?.sections[sectionIndex].type {
            case SectionNames.mediumTable.rawValue:
                return self?.configureMediumTableSection()
            case SectionNames.smallTable.rawValue:
                return self?.configureSmallTableSection()
            default:
                return self?.configureFeaturedSection()
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config

        return layout
    }

    private func createDataSource() -> DataSource {
        let datasource = DataSource(
            collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in

                switch self?.sections[indexPath.section].type {
                case SectionNames.mediumTable.rawValue:
                    return try? self?.configureCell(
                        collectionView: collectionView,
                        indexPath: indexPath,
                        sectionItem: itemIdentifier,
                        cellType: MediumTableCell.self
                    )
                case SectionNames.smallTable.rawValue:
                    return try? self?.configureCell(
                        collectionView: collectionView,
                        indexPath: indexPath,
                        sectionItem: itemIdentifier,
                        cellType: SmallTableCell.self
                    )
                default:
                    return try? self?.configureCell(
                        collectionView: collectionView,
                        indexPath: indexPath,
                        sectionItem: itemIdentifier,
                        cellType: FeaturedCollectionViewCell.self
                    )
                }
            }

        datasource.supplementaryViewProvider = { [weak self] (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: SectionHeaderCollectionReusableView.reuseIdentifier, for: indexPath) as? SectionHeaderCollectionReusableView else {
                return nil
            }

            guard let firstApp = self?.dataSource.itemIdentifier(for: indexPath) else { return nil }

            guard let section = self?.dataSource.snapshot().sectionIdentifier(containingItem: firstApp) else { return nil }

            guard !section.title.isEmpty else { return nil }

            sectionHeader.sectionTitle.text = section.title
            sectionHeader.sectionSubtitle.text = section.subtitle

            return sectionHeader
        }

        return datasource
    }

    private func configureCell<T: SelfConfiguringCell>(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        sectionItem: SectionItem,
        cellType: T.Type
    ) throws -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            throw CellConfigureError.init(
                errorCode: CellConfigureError.ErrorCodes.unableToDequeueCell.rawValue,
                errorUserInfo: [
                    CellConfigureError.UserInfoKey.failureReason.rawValue: "Failed to dequeue cell \(cellType)"
                ])
            
        }

        cell.configure(with: sectionItem)

        return cell
    }

    private func reloadData() {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections(sections)

        sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }

        dataSource.apply(snapshot)
    }

    // MARK: Create Sections

    private func configureFeaturedSection() -> NSCollectionLayoutSection {

        // Make the item
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: size)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        // make the group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(350))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // return the section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        return section
    }

    private func configureMediumTableSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.33)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.93),
                heightDimension: .fractionalWidth(0.55)),
            subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        let sectionItem = configureSectionHeader()
        section.boundarySupplementaryItems = [sectionItem]

        return section
    }

    private func configureSmallTableSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.2)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 0)

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.93),
                heightDimension: .estimated(200)),
            subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let sectionItem = configureSectionHeader()
        section.boundarySupplementaryItems = [sectionItem]

        return section
    }
    
    private func configureSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.93),
            heightDimension: .estimated(80)
        )

        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    
        return layoutSectionHeader
    }

    // MARK: - Enums

    private enum SectionNames: String {
        case mediumTable = "mediumTable"
        case smallTable = "smallTable"
        case featured = "featured"
    }
}
