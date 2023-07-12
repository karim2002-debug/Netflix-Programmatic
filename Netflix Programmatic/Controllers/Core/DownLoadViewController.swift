//
//  DownLoadViewController.swift
//  Netflix Programmatic
//
//  Created by Macbook on 21/06/2023.
//

import UIKit

class DownLoadViewController: UIViewController {

    
    private var titleItem : [TitleItem] = [TitleItem]()
    
    private let downloadTableView : UITableView = {
        
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifler)
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        view.addSubview(downloadTableView)
        downloadTableView.delegate = self
        downloadTableView.dataSource = self
        fetchData()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Downloaded"), object: nil, queue: nil) { _ in
            self.fetchData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        downloadTableView.frame = view.bounds
    }
 
    private func fetchData(){
        DataPersistenceManger.shared.fetchingDataFromDatabase {[weak self]result in
            switch result{
            case .success(let titleItem):
                DispatchQueue.main.async {
                    self?.downloadTableView.reloadData()
                }
                self?.titleItem = titleItem
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
extension DownLoadViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifler, for: indexPath)as? TitleTableViewCell else{
            return UITableViewCell()
        }
        let title = titleItem[indexPath.row]
        let titleViewModel = TitleViewModel(titleName: title.original_title, posterURL: title.poster_path)
        cell.configure(with: titleViewModel)
        
        
        return cell
    }
 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle{
        case .delete :
            DataPersistenceManger.shared.deleteTitleWith(model: titleItem[indexPath.row]) { result in
                switch result{
                case .success():
                    print("Delete From DataBase")
                case .failure(let error):
                    print(error)
                }
                self.titleItem.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let title = titleItem[indexPath.row]
        let vc = TitlePriviewViewController()
        
        APICaller.shared.getMovie(query: title.original_title!) { result in
            switch result{
            case .success(let videoELement):
                let titlePreviewModel = TitlePreviewViewModel(title: title.original_title!, youtubeView: videoELement, titleOverview: title.overview!)
                vc.configure(with: titlePreviewModel)
                self.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                print(error)
            }
        }
        
       
    }
}
