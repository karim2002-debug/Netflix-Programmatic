//
//  TitleTableViewCell.swift
//  Netflix Programmatic
//
//  Created by Macbook on 25/06/2023.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    static let identifler = "TitleTableViewCell"
    
    private let playButton : UIButton = {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "play.circle",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    
    
    private let titlePosterName : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16,weight: .semibold)
        label.numberOfLines = 2
        return label
        
    }()
    
    
    private let titlePosterImageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
 
    }()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlePosterImageView)
        contentView.addSubview(titlePosterName)
        contentView.addSubview(playButton)
        applyConstrains()
    }
    
    
    required init?(coder: NSCoder) {
      
        fatalError()
    }
    
    private func applyConstrains(){
        
        let titlePosterImageConstrains = [
            titlePosterImageView.leadingAnchor.constraint(equalTo:leadingAnchor),
            titlePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titlePosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titlePosterImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let titlePosterNameConstrains = [
            titlePosterName.leadingAnchor.constraint(equalTo: titlePosterImageView.trailingAnchor, constant: 15),
            titlePosterName.centerYAnchor.constraint(equalTo:contentView.centerYAnchor),
            titlePosterName.trailingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: -20)
        ]
        let playButtonConstrains = [
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        
        ]
        
        NSLayoutConstraint.activate(titlePosterImageConstrains)
        NSLayoutConstraint.activate(titlePosterNameConstrains)
        NSLayoutConstraint.activate(playButtonConstrains)

    }
    
    
      func configure(with model : TitleViewModel){
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL!)")else{
            return
        }
        titlePosterImageView.sd_setImage(with: url)
          titlePosterName.text = model.titleName 
           
    }

}
