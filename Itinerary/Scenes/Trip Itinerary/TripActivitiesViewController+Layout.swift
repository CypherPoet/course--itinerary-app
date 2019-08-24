//
//  TripActivitiesViewController+Layout.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


// MARK: - Layout Structure
extension TripActivitiesViewController {
    enum DecorationElementKind {
        static let sectionBackground = "Section Background"
    }
    
    enum SupplementaryViewKind {
        static let sectionHeader = "Section Header"
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<TripDay, TripActivity>
    typealias SectionSupplementaryViewProvider = DataSource.SupplementaryViewProvider
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<TripDay, TripActivity>
}


// MARK: - Layout Composition
extension TripActivitiesViewController {
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(56))
        
        let dayItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [dayItem])
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 0, leading: 36, bottom: 56, trailing: 36)
        section.interGroupSpacing = 14
        
        let sectionHeader = makeLayoutSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        let sectionDecoration = NSCollectionLayoutDecorationItem.background(elementKind: DecorationElementKind.sectionBackground)
        
        sectionDecoration.contentInsets = .init(
            top: 0,
            leading: section.contentInsets.leading / 2,
            bottom: section.contentInsets.bottom - 16,
            trailing: section.contentInsets.trailing / 2
        )
        
        section.decorationItems = [sectionDecoration]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    func makeLayoutSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(42))
        
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: SupplementaryViewKind.sectionHeader,
            alignment: .top,
            absoluteOffset: CGPoint(x: 0, y: -8)
        )
    }
    
    
    func makeSectionSupplementaryViewProvider() -> SectionSupplementaryViewProvider {
        return {
            [weak self] (
                collectionView: UICollectionView,
                kind: String,
                indexPath: IndexPath
            ) -> UICollectionReusableView? in
            
            guard kind == SupplementaryViewKind.sectionHeader else {
                preconditionFailure("Unknown kind for supplementary view")
            }
            
            guard
                let tripDay = self?.currentDataSnapshot.sectionIdentifiers[indexPath.section]
            else {
                preconditionFailure("Unable to find section identifier for trip day")
            }
            
            let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: R.reuseIdentifier.tripDayCollectionSectionHeader.identifier,
                for: indexPath
            )
            
            
            self?.configure(sectionHeaderView, for: tripDay)
            
            return sectionHeaderView
        }
    }
    
    
    func configure(_ sectionHeaderView: UICollectionReusableView, for tripDay: TripDay) {
        guard let headerView = sectionHeaderView as? TripDayCollectionHeaderReusableView else {
            preconditionFailure("Unknown header view type")
        }
        
        headerView.viewModel = .init(
            date: tripDay.date,
            subtitle: tripDay.subtitle
        )
    }
    
    
    func configure(_ activityCell: UICollectionViewCell, for tripActivity: TripActivity) {
        guard let cell = activityCell as? TripActivityCollectionViewCell else {
            preconditionFailure("Unknown cell type")
        }
        
        cell.viewModel = .init(
            activityTitle: tripActivity.title,
            activitySubtitle: tripActivity.subtitle,
            activityType: tripActivity.activityType
        )
    }
}
