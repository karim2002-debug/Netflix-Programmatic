//
//  APICaller.swift
//  Netflix Programmatic
//
//  Created by Macbook on 22/06/2023.
//

import Foundation
import Alamofire

struct Constrains{
    static let API_KEY = "5ba431c7d6dcd0a1e20773e0a8240a3b"
    static let base_URL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyB4UXmUI0cz7IbX_h7nVXUwGkILUBy-r60"
}
enum APIError : Error {
    case failedTogetData
    case failedURL
}

class APICaller {
    
    static let shared = APICaller()
    
    func getTrandingMovies(compleltionHandler : @escaping (Result<[Title],APIError>)->Void){
        
        guard let url = URL(string: "\(Constrains.base_URL)/3/trending/movie/day?api_key=\(Constrains.API_KEY)")else{
            compleltionHandler(.failure(.failedURL))
            return
        }
        AF.request(url,method: .get).responseDecodable(of:TrendingTitlesResponse.self) { response in
            switch response.result{
            case .success(let movies):
                print(movies)
                compleltionHandler(.success(movies.results!))
            case .failure(let error):
                compleltionHandler(.failure(.failedTogetData))
                print(error)
            }
        }
    }
    func getTraindingtv(completionHandler : @escaping (Result<[Title],APIError>)->Void){
        guard let url = URL(string: "\(Constrains.base_URL)/3/trending/tv/day?api_key=\(Constrains.API_KEY)")else{
            completionHandler(.failure(.failedURL))
            return
        }
        AF.request(url,method: .get).responseDecodable(of:TrendingTitlesResponse.self) { response in
            switch response.result{
            case .success(let tv):
                print(tv)
                completionHandler(.success(tv.results!))
                
            case .failure(let error):
                completionHandler(.failure(.failedTogetData))
                print(error)
            }
        }
    }
    
    func getUpcomingMovies(completionHandler : @escaping(Result<[Title],APIError>)->Void){
        guard let url = URL(string: "\(Constrains.base_URL)/3/movie/upcoming?api_key=\(Constrains.API_KEY)")else{
            completionHandler(.failure(.failedURL))
            return
        }
        AF.request(url,method: .get).responseDecodable(of:TrendingTitlesResponse.self) { response in
            switch response.result{
            case .success(let upComing):
                print(upComing)
                completionHandler(.success(upComing.results!))
            case .failure(let error):
                print(error)
                completionHandler(.failure(.failedTogetData))
            }
        }
    }
    
    
    func getToRatedMovies(completionHandler : @escaping (Result<[Title],APIError>)->Void){
        guard let url = URL(string: "\(Constrains.base_URL)/3/tv/top_rated?api_key=\(Constrains.API_KEY)")else{
            completionHandler(.failure(.failedURL))
            return
        }
        
        AF.request(url,method: .get).responseDecodable(of:TrendingTitlesResponse.self) { response in
            switch response.result{
            case .success(let topRated):
                print(topRated)
                completionHandler(.success(topRated.results!))
            case .failure(let error):
                print(error)
                completionHandler(.failure(.failedTogetData))
            }
        }
        
    }
    
    func getPopularMovies(completionHandler : @escaping (Result<[Title],APIError>)->Void){
        guard let url = URL(string: "\(Constrains.base_URL)/3/tv/popular?api_key=\(Constrains.API_KEY)")else{
            completionHandler(.failure(.failedURL))
            return
        }
        
        AF.request(url,method: .get).responseDecodable(of:TrendingTitlesResponse.self) { response in
            switch response.result{
            case .success(let popuar):
                print(popuar)
                completionHandler(.success(popuar.results!))
            case .failure(let error):
                print(error)
                completionHandler(.failure(.failedTogetData))
            }
        }
    }
    
    func getDiscoverMovie(completionHandler : @escaping (Result<[Title],APIError>)->Void){
        
        guard let url = URL(string:"\(Constrains.base_URL)/3/discover/movie?api_key=\(Constrains.API_KEY)")else{
            completionHandler(.failure(.failedURL))
            return
        }
        AF.request(url,method: .get).responseDecodable(of: TrendingTitlesResponse.self) { response in
            switch response.result{
            case .success(let discover):
                print(discover)
                completionHandler(.success(discover.results!))
            case .failure(let error):
                print(error)
                completionHandler(.failure(.failedTogetData))
            }
        }
    }
    
    
    func search(query : String,completionHandler : @escaping (Result<[Title],APIError>)->Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)else{return}
        guard let url = URL(string: "\(Constrains.base_URL)/3/search/movie?query=\(query)&api_key=\(Constrains.API_KEY)")else{
            completionHandler(.failure(.failedURL))
            return
        }
        
        AF.request(url,method: .get).responseDecodable(of:TrendingTitlesResponse.self) { response in
            switch response.result{
            case .success(let movie):
                print(movie)
                completionHandler(.success(movie.results!))
            case .failure(let error):
                print(error)
                completionHandler(.failure(.failedTogetData))
            }
        }
    }
    
    
    func getMovie(query : String,completionHandler : @escaping (Result<VideoElement,APIError>)->Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)else{return}
        guard let url = URL(string: "https://youtube.googleapis.com/youtube/v3/search?q=\(query)&key=\(Constrains.YoutubeAPI_KEY)")else{
            completionHandler(.failure(.failedURL))
            return
        }
        
        AF.request(url,method: .get).responseDecodable(of:YoutubeSearchResponse.self) { response in
            switch response.result{
            case.success(let movie):
             
                completionHandler(.success(movie.items[0]))
            case .failure(let error):
                print(error)
                completionHandler(.failure(.failedTogetData))
            }
        }
    }
 
}
