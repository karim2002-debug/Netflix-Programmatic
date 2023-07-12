//
//  TitleCollectionViewCell.swift
//  Netflix Programmatic
//
//  Created by Macbook on 24/06/2023.
//

import UIKit
import SDWebImage
class TitleCollectionViewCell: UICollectionViewCell {
   
    static let identifier = "TitleCollectionViewCell"
    
    
    private let posterImageView : UIImageView = {
        
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    
    public func configure(with model : String){

        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)")else{
            print("Nil")
            return
        }
        posterImageView.sd_setImage(with: url)

        
      
    }
    
    
    
}
