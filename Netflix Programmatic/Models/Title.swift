//
//  TrendingMovieResponse.swift
//  Netflix Programmatic
//
//  Created by Macbook on 22/06/2023.
//

import Foundation

struct TrendingTitlesResponse : Codable{
    
    var results : [Title]?
}
struct Title: Codable{
    let original_title : String?
    let adult : Bool?
    let media_type : String?
    let backdrop_path : String?
    let id : Int?
    let name : String?
    let original_language : String?
    let original_name : String?
    let overview : String?
    let popularity : Double?
    let first_air_date : String?
    let vote_average : Double?
    let vote_count : Double?
    let poster_path : String?
}
