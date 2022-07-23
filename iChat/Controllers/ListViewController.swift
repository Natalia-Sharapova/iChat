//
//  ListViewController.swift
//  iChat
//
//  Created by Наталья Шарапова on 09.07.2022.
//

import UIKit
import FirebaseFirestore

class ListViewController: UIViewController {
    
    //MARK: - Properties
    var collectionView: UICollectionView!
    private var waitingChatsListener: ListenerRegistration?
    private var activeChatsListener: ListenerRegistration?
    private let currentUser: MUser
    
    
    var waitingChats = [MChat]()
    var activeChats = [MChat]()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MChat>?
    
    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.userName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        waitingChatsListener?.remove()
        activeChatsListener?.remove()
    }
    
    // Enum for sections name
    enum Section: Int, CaseIterable {
        case waitingChats
        case activeChats
        
        func description() -> String {
            switch self {
            case .waitingChats:
                return "Waiting chats"
            case .activeChats:
                return "Active chats"
            }
        }
    }
    
    //MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupSearchBar()
        createDataSource()
        reloadData()
        
        view.backgroundColor = UIColor.milkWhite()
        
        // Observe waiting chats
        waitingChatsListener = ListenerService.shared.waitingChatsObserver(chats: waitingChats, completion: { result in
            
            switch result {
            case .success(let chats):
                self.waitingChats = chats
                if self.waitingChats != [], self.waitingChats.count <= chats.count {
                    
                    let chatRequestViewController = ChatRequestViewController(chat: chats.last!)
                    chatRequestViewController.delegate = self
                    self.present(chatRequestViewController, animated: true, completion: nil)
                }
                self.reloadData()
                
            case .failure(let error):
                self.showAlert(with: "Error", and: error.localizedDescription)
            }
        })
        
        // Observe active chats
        activeChatsListener = ListenerService.shared.activeChatsObserver(chats: activeChats, completion: { result in
            
            switch result {
            case .success(let chats):
                
                self.activeChats = chats
                self.reloadData()
                
            case .failure(let error):
                self.showAlert(with: "Error", and: error.localizedDescription)
            }
        })
    }
    
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, MChat>()
        snapShot.appendSections([.waitingChats,.activeChats])
        snapShot.appendItems(waitingChats, toSection: .waitingChats)
        snapShot.appendItems(activeChats, toSection: .activeChats)
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        view.addSubview(collectionView)
        
        collectionView.register(ActiveChatCollectionViewCell.self, forCellWithReuseIdentifier: ActiveChatCollectionViewCell.reuseId)
        collectionView.register(WaitingChatCollectionViewCell.self, forCellWithReuseIdentifier: WaitingChatCollectionViewCell.reuseId)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        collectionView.delegate = self
    }
}

// MARK: - Extensions
// MARK: - Setup data source

extension ListViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MChat>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, chat) in
            
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
            case .waitingChats:
                return self.configure(collectionView: collectionView,
                                      cellType: WaitingChatCollectionViewCell.self,
                                      with: chat,
                                      for: indexPath)
            case .activeChats:
                return self.configure(collectionView: collectionView,
                                      cellType: ActiveChatCollectionViewCell.self,
                                      with: chat,
                                      for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { return nil }
            
            guard let section = Section(rawValue: indexPath.section) else { return nil }
            sectionHeader.configure(text: section.description(),
                                    font: .laoSangamMN20(),
                                    textColor: #colorLiteral(red: 0.5725490196, green: 0.5725490196, blue: 0.5725490196, alpha: 1))
            
            return sectionHeader
        }
    }
}

// MARK: - Setup layout

extension ListViewController {
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnviroment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .waitingChats:
                return self.createWaitingChats()
            case .activeChats:
                return self.createActiveChats()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func createActiveChats() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 29, bottom: 0, trailing: 20)
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createWaitingChats() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(88),
            heightDimension: .absolute(88))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 29, bottom: 0, trailing: 20)
        section.interGroupSpacing = 16
        
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

// MARK: - UICollectionViewDelegate

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let chat = dataSource?.itemIdentifier(for: indexPath) else { return }
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
        case .waitingChats:
            let chatRequestViewController = ChatRequestViewController(chat: chat)
            chatRequestViewController.delegate = self
            present(chatRequestViewController, animated: true, completion: nil)
        case .activeChats:
            let chatsViewController = ChatsViewController(user: currentUser, chat: chat)
            navigationController?.pushViewController(chatsViewController, animated: true)
            
        }
    }
}

// MARK: - WaitingChatNavigation

extension ListViewController: WaitingChatNavigation {
    
    func removeWaitingChat(chat: MChat) {
        FirestoreService.shared.deleteWaitingChat(chat: chat) { result in
            
            switch result {
            case .success():
                self.showAlert(with: "Succeded", and: "Chat with \(chat.friendUserName) deleted")
            case .failure(let error):
                self.showAlert(with: "Error", and: error.localizedDescription)
            }
        }
    }
    
    func changeToActive(chat: MChat) {
        FirestoreService.shared.changeToActive(chat: chat) { result in
            
            switch result {
            case .success():
                self.showAlert(with: "Success", and: "Great chat with \(chat.friendUserName)")
                print(#function, "success")
                
            case .failure(let error):
                self.showAlert(with: "Error", and: error.localizedDescription)
                print(#function, String(describing: error))
            }
        }
    }
}


// MARK: - UISearchBarDelegate

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

// MARK: - For Canvas mode

import SwiftUI

struct ListViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ListContainerView().edgesIgnoringSafeArea(.all)
    }
}

struct ListContainerView: UIViewControllerRepresentable {
    let tabBarVc = MainTabBarController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return tabBarVc
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

