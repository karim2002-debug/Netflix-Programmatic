//
//  HomeViewController.swift
//  Netflix Programmatic
//
//  Created by Macbook on 21/06/2023.
//


enum section : Int {
    case TrendingMovie = 0
    case Popular = 1
    case TrendingTv = 2
    case ComingMovies = 3
    case TopRated = 4
}



import UIKit

class HomeViewController: UIViewController {
    
    var sectionTitles = ["Trending Movies","Popular","Trending tv","Coming movies","Top rated"]
    private var randomTrendingMovie : Title?
    private var headerView : HeroHeaderUIView?
    private let homeFeedTableView : UITableView = {
        
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        return table
        
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTableView)
        
        homeFeedTableView.delegate = self
        homeFeedTableView.dataSource = self
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        
        homeFeedTableView.tableHeaderView = headerView
        
        
        configureNavBar()
        
        
        configureHeroHeader()
        
        headerView?.playButton.addTarget(self, action: #selector(didTapedPlayButton), for: .touchUpInside)
        
    }
    @objc func didTapedPlayButton(){
        
        APICaller.shared.getMovie(query: randomTrendingMovie?.original_title ?? "") { [weak self] result in
            switch result{
            case .success(let random):
                DispatchQueue.main.async {
                    let vc = TitlePriviewViewController()
                    let titlePreviewModel = TitlePreviewViewModel(title: self?.randomTrendingMovie?.original_title ?? "", youtubeView: random, titleOverview: self?.randomTrendingMovie?.overview ?? "")
                    vc.configure(with: titlePreviewModel)
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                }
            case .failure(let error):
                print(error)
                
            }
        }
        
        
        
    }
    private func configureHeroHeader(){
        
        APICaller.shared.getTrandingMovies { [weak self] result in
            switch result{
            case .success(let title):
                let randomMovie = title.randomElement()
                self?.randomTrendingMovie = randomMovie
                let titleViewModel = TitleViewModel(titleName: randomMovie?.original_title, posterURL: randomMovie?.poster_path)
                self?.headerView?.configureHeader(with: titleViewModel)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureNavBar(){
        
        var image = UIImage(named: "net")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .label
    }
    
    override func viewDidLayoutSubviews() {
        homeFeedTableView.frame = view.bounds
    }
}

extension HomeViewController : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    // to Handel Header
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else{return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: CGFloat(Int(header.bounds.origin.x) + 20), y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.captialTheFirstLetter()
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:  CollectionTableViewCell.identifier, for:indexPath)as? CollectionTableViewCell else{
            return UITableViewCell()
        }
        switch indexPath.section{
        case section.TrendingMovie.rawValue :
            APICaller.shared.getTrandingMovies { result in
                
                switch result{
                case .success(let data):
                    cell.configure(with: data)
                    print(data)
                case .failure(let error):
                    print(error)
                }
            }
        case section.Popular.rawValue :
            APICaller.shared.getPopularMovies { result in
                
                switch result{
                case .success(let data):
                    cell.configure(with: data)
                case .failure(let error):
                    print(error)
                }
            }
        case section.TrendingTv.rawValue:
            APICaller.shared.getTraindingtv { result in
                switch result{
                case .success(let data):
                    cell.configure(with: data)
                case .failure(let error):
                    print(error)
                }
            }
        case section.ComingMovies.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result{
                case .success(let data):
                    cell.configure(with: data)
                case .failure(let error):
                    print(error)
                }
            }
        case section.TopRated.rawValue:
            APICaller.shared.getToRatedMovies { result in
                switch result{
                case .success(let data):
                    cell.configure(with: data)
                case .failure(let error):
                    print(error)
                }
            }
        default:
            print("error")
        }
        
        cell.delegete = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}

extension  HomeViewController : CollectionTableViewCellDelegete{
    func CollectionTableViewCellDidTabed(_ cell: CollectionTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePriviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}
