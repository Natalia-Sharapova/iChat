//
//  PeopleViewController.swift
//  iChat
//
//  Created by Наталья Шарапова on 09.07.2022.
//

import UIKit

class PeopleViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    let users = Bundle.main.decode(_type: [MUser].self, from: "users2.json")
   
    enum Section: Int, CaseIterable {
        case users
        func description(usersCount: Int) -> String {
            return "\(usersCount) people nearby"
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MUser>?
                
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 247, green: 248, blue: 253, alpha: 1)
        setupCollectionView()
        setupSearchBar()
        createDataSource()
        reloadData(with: nil)
        
        print(users)
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        view.addSubview(collectionView)
        
        collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: UserCollectionViewCell.reuseId)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
    }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
  
    private func reloadData(with searchText: String?)  {
        
        let filtered = users.filter { (user) -> Bool in
            user.contains(filter: searchText)
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, MUser>()
        snapShot.appendSections([.users])
        snapShot.appendItems(filtered, toSection: .users)
        dataSource?.apply(snapShot, animatingDifferences: true)
        }
}

// MARK: - UISearchBarDelegate

extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
    }
}

extension PeopleViewController {
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnviroment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .users:
                return self.createUsersSection()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func createUsersSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.6))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(15)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 15, bottom: 0, trailing: 15)
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let sectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(1))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: sectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        return sectionHeader
    }
    }
    
    extension PeopleViewController {
        
        private func createDataSource() {
            
                dataSource = UICollectionViewDiffableDataSource<Section, MUser>(
                collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) in
                
                guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
                }
                switch section {
                case .users:
                    return self.configure(collectionView: collectionView,
                                          cellType: UserCollectionViewCell.self,
                                          with: user,
                                          for: indexPath)
                }
            })
            dataSource?.supplementaryViewProvider = {
                collectionView, kind, indexPath in
                
                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { return nil }
                
                guard let section = Section(rawValue: indexPath.section) else { return nil }
                
                let items = self.dataSource?.snapshot().itemIdentifiers(inSection: .users)
                sectionHeader.configure(text: section.description(usersCount: items?.count ?? 0),
                                        font: .systemFont(ofSize: 36, weight: .light),
                                        textColor: #colorLiteral(red: 0.5725490196, green: 0.5725490196, blue: 0.5725490196, alpha: 1))
                
                return sectionHeader
            }
        }
    }

import SwiftUI

struct PeopleViewControllerProvider: PreviewProvider {
    static var previews: some View {
        PeopleContainerView().edgesIgnoringSafeArea(.all)
    }
}

struct PeopleContainerView: UIViewControllerRepresentable {
    let tabBarVc = MainTabBarController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return tabBarVc
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
