//
//  TitlePriviewViewController.swift
//  Netflix Programmatic
//
//  Created by Macbook on 04/07/2023.
//

import UIKit
import WebKit


class TitlePriviewViewController: UIViewController {

    var titleItem : TitleItem?
    var fromDownloadViewController : Bool?
    public var titles : Title?
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .label
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    
    private let overviewLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.tintColor = .systemGray2
        return label
    }()
    
    private let downLoadButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Download", for: .normal)
        return button
    }()
    
    private let webKit : WKWebView = {
        let webKit = WKWebView()
        webKit.translatesAutoresizingMaskIntoConstraints = false
        return webKit
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webKit)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downLoadButton)
        applyConstrains()
        
        downLoadButton.addTarget(self, action: #selector(didTapedDownlaodButton), for: .touchUpInside)
        
        if fromDownloadViewController == true{
            downLoadButton.setTitle("Delete", for: .normal)
            downLoadButton.addTarget(self, action: #selector(didTapedDeleteFromDownload), for: .touchUpInside)
        }
    }
    
    @objc func didTapedDeleteFromDownload(){
        guard let titleItem = titleItem else{
            return
        }
        DataPersistenceManger.shared.deleteTitleWith(model: titleItem) { result in
            switch result{
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("DeletedFromDownloaded"), object: nil)
                print("Deleted From DataBase")
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    @objc func didTapedDownlaodButton(){
    
        guard let title = titles else{
            return
        }
        
        
        DataPersistenceManger.shared.downloadTitlewith(model: title) { result in
            switch result{
            case .success():
                
                NotificationCenter.default.post(name: NSNotification.Name("DownloadedFromPerviewViewConteroller"), object: nil)
               
                print("add to dataBase")
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    private func applyConstrains(){
        
        let webKitConstrains = [
            
            webKit.topAnchor.constraint(equalTo: view.topAnchor,constant: 50),
            webKit.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 5),
            webKit.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -5),
            webKit.heightAnchor.constraint(equalToConstant: 300)
            
        ]
        let titleLabelConstrains = [
            
            titleLabel.leadingAnchor.constraint(equalTo: webKit.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: webKit.bottomAnchor,constant: 20),
            
        ]
        let overviewConstrains = [
            
             overviewLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
             overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 20),
             overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20)
     
        ]
        
        let downLaodButtonConstrains = [
        
            downLoadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downLoadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor,constant: 25),
            downLoadButton.widthAnchor.constraint(equalToConstant: 150),
            downLoadButton.heightAnchor.constraint(equalToConstant: 50)
        
        ]
        NSLayoutConstraint.activate(webKitConstrains)
        NSLayoutConstraint.activate(titleLabelConstrains)
        NSLayoutConstraint.activate(overviewConstrains)
        NSLayoutConstraint.activate(downLaodButtonConstrains)
    }
    
    
    func configure(with model : TitlePreviewViewModel){
        
        
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)")else{
            return
        }
        webKit.load(URLRequest(url: url))
    }

   
}
