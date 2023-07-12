//
//  HeroHeaderUIView.swift
//  Netflix Programmatic
//
//  Created by Macbook on 22/06/2023.
//

import UIKit
import SDWebImage
class HeroHeaderUIView: UIView {
    
    
    
    public let playButton : UIButton = {
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play", for: .normal)
         button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.white.cgColor
        return button
        
    }()
    
    
    private let downloadButton : UIButton = {
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Download", for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5

       button.layer.borderColor = UIColor.white.cgColor
       return button
        
    }()
    
    private let heroImageView : UIImageView = {
        
        let image = UIImageView()
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstrains()
        
    }

    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    
    
    func applyConstrains(){
        
        let playButtonConstrains = [

             playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            // playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 90),
             playButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -15),
             playButton.widthAnchor.constraint(equalToConstant: 120)
            
        ]
        let downlaodButtonConstrains = [
        
      //      downloadButton.trailingAnchor.constraint(equalTo:trailingAnchor, constant: -90),
            downloadButton.bottomAnchor.constraint(equalTo:bottomAnchor,constant: -50),
            downloadButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 15),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(downlaodButtonConstrains)
        NSLayoutConstraint.activate(playButtonConstrains)
    }
    
    public func configureHeader(with model : TitleViewModel){
        
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL!)")else{
            return
        }
        heroImageView.sd_setImage(with: url)
        
    }
    
}
