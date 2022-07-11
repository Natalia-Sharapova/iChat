//
//  PeopleViewController.swift
//  iChat
//
//  Created by Наталья Шарапова on 09.07.2022.
//

import UIKit

class PeopleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange
        setupSearchBar()
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
  
}

// MARK: - UISearchBarDelegate

extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
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
