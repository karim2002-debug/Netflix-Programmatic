//
//  TableViewCell.swift
//  Netflix Programmatic
//
//  Created by Macbook on 22/06/2023.
//

import UIKit

protocol CollectionTableViewCellDelegete {
    func CollectionTableViewCellDidTabed(_ cell : CollectionTableViewCell , title : Title , viewModel : TitlePreviewViewModel)
}

class CollectionTableViewCell: UITableViewCell {

   static let identifier = "CollectionTableViewCell"
    
    var delegete : CollectionTableViewCellDelegete?
   private var title : [Title] = [Title]()
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier:TitleCollectionViewCell.identifier)
         return collectionView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with title : [Title]){
        self.title = title
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadTitleAt(indexPath : IndexPath){
       
        let title = title[indexPath.row]
        DataPersistenceManger.shared.downloadTitlewith(model:title) { [weak self] result in
            switch result{
            case .success() :
                NotificationCenter.default.post(name: NSNotification.Name("Downloaded"), object: nil)
                print("add to data base")
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
       
    }
    
    
}
extension CollectionTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return title.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for:indexPath)as? TitleCollectionViewCell else{
            return UICollectionViewCell()
        }
        guard let model = title[indexPath.row].poster_path else{
            return UICollectionViewCell()
        }
        cell.configure(with:model)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let title = title[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else{
            return
        }
        guard let overview = title.overview else{
            return
        }

        APICaller.shared.getMovie(query: titleName + " trailer") { [weak self]result in
            switch result{
            case .success(let videoElement):
              
                let titlePreviewViewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: overview)
                guard let strongSelf = self else {
                    return
                }
                
                self?.delegete?.CollectionTableViewCellDidTabed(strongSelf, title: title, viewModel: titlePreviewViewModel)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { [weak self]_ in
            
                let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    print("downloaded")
                    self?.downloadTitleAt(indexPath: indexPath)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
     
}
