//
//  SearchResultViewController.swift
//  Netflix Programmatic
//
//  Created by Macbook on 26/06/2023.
//

import UIKit

protocol SearchResultViewControllerDelegete {
    func SearchResultViewControllerDidTaped( _ viewModel : TitlePreviewViewModel)
}

class SearchResultViewController: UIViewController {

     var titles : [Title] = [Title]()
    var delegete : SearchResultViewControllerDelegete?
     let searchResultCollectionView : UICollectionView = {
         let layout = UICollectionViewFlowLayout()
         layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3.4, height: 200)
         
         let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(searchResultCollectionView)
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        print(titles)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }

}
extension SearchResultViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return titles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath)as?TitleCollectionViewCell else{
            return UICollectionViewCell()
        }
        guard let data = titles[indexPath.row].poster_path else{
            return UICollectionViewCell()
        }
        print(data)
        cell.configure(with: data)
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title else{
            return
        }
        guard let overview = title.overview else{
            return
        }
        
        APICaller.shared.getMovie(query: titleName) { [weak self] result in
            switch result{
            case .success(let videoElemet):
                DispatchQueue.main.async {
                     let titlePreviewViewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElemet, titleOverview: overview)
                    self?.delegete?.SearchResultViewControllerDidTaped(titlePreviewViewModel)
                   
                }
                
            case .failure(let error):
                print(error)
            }
        
        }
        
    }
}
