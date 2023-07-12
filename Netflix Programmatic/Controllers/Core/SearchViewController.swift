//
//  SearchViewController.swift
//  Netflix Programmatic
//
//  Created by Macbook on 21/06/2023.
//

import UIKit

class SearchViewController: UIViewController{
    
    
    
    var titles : [Title] = [Title]()
    
    private let searchController : UISearchController = {
        
        let searchController = UISearchController(searchResultsController: SearchResultViewController())
        searchController.searchBar.placeholder = "Search for movie or tv"
        searchController.searchBar.tintColor = .label
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
        
    }()
    
    private let searchTableView : UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier:TitleTableViewCell.identifler)
         return table
        
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        searchTableView.delegate = self
        searchTableView.dataSource = self
        view.addSubview(searchTableView)
        fetchDiscover()
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTableView.frame = view.bounds
    }
    
    
    private func fetchDiscover(){
        APICaller.shared.getDiscoverMovie { [weak self] result in
            switch result{
            case .success(let discover):
            self?.titles = discover
                DispatchQueue.main.async {
                    self?.searchTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
extension SearchViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifler, for: indexPath)as? TitleTableViewCell else{
            return UITableViewCell()
        }
        let data = titles[indexPath.row]
        let titleViewModel = TitleViewModel(titleName: data.original_title,posterURL: data.poster_path)
        cell.configure(with: titleViewModel)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let title = titles[indexPath.row]
        guard let titleName = title.original_title else{
            return
        }
        guard let overview = title.overview else{
            return
        }
        APICaller.shared.getMovie(query: titleName) {[weak self] result in
            switch result{
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePriviewViewController()
                    let titlePreviewViewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: overview)
                    vc.configure(with: titlePreviewViewModel)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
}
extension SearchViewController : UISearchResultsUpdating , SearchResultViewControllerDelegete {
   
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        
        // check that query not empty and its count >= 3
        guard let query = searchBar.text ,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3 ,
            let resultController = searchController.searchResultsController as? SearchResultViewController else{
                return
           
            }
        resultController.delegete = self
        print(query)
        APICaller.shared.search(query: query) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let searchResult):
                    resultController.titles = searchResult
                    resultController.searchResultCollectionView.reloadData()
                    print(searchResult)
                case .failure(let error):
                    print(error)
                }
            }
         
        }
        
    }
    
    
    func SearchResultViewControllerDidTaped(_ viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePriviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
