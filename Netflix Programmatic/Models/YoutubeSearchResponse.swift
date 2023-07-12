//
//  YoutubeSearchResponse.swift
//  Netflix Programmatic
//
//  Created by Macbook on 03/07/2023.
//

import Foundation
struct YoutubeSearchResponse : Codable{
    var items : [VideoElement]
}


struct VideoElement : Codable{
    
    var id : IdVideoElement
}

struct IdVideoElement : Codable{
    var kind : String
    var videoId : String
}

