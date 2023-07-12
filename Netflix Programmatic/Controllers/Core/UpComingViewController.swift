//
//  UpComingViewController.swift
//  Netflix Programmatic
//
//  Created by Macbook on 21/06/2023.
//

import UIKit

class UpComingViewController: UIViewController {

    
    private var titles : [Title] = [Title]()
    
    private let upComingTableView : UITableView = {
        
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifler)
        return table
        
        
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Up coming"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
        
        view.addSubview(upComingTableView)
        upComingTableView.delegate = self
        upComingTableView.dataSource = self
        fetchUpcoming()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        upComingTableView.frame = view.bounds
        
    }

    private func fetchUpcoming(){
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result{
            case .success(let upComing):
                self?.titles = upComing
                
                self?.upComingTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
 
}
extension UpComingViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifler, for: indexPath)as? TitleTableViewCell else{
            return UITableViewCell()
        }
        
        
        let data = titles[indexPath.row]
        let titleViewModel = TitleViewModel(titleName: data.original_title, posterURL: data.poster_path)
        
        cell.configure(with: titleViewModel)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title else{
            return
        }
        guard let overview = title.overview else{
            return
        }
        
        APICaller.shared.getMovie(query: titleName) { [weak self] result in
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
