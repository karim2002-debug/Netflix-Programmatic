//
//  DataPersisteceManger.swift
//  Netflix Programmatic
//
//  Created by Macbook on 12/07/2023.
//

import Foundation

import CoreData
import UIKit

enum databaseError : Error {
    case failedTogetData
    case failedToDeleteData
}

class DataPersistenceManger {

    static let shared = DataPersistenceManger()
    
    
    func downloadTitlewith(model : Title , completionHandler : @escaping (Result<Void,databaseError>)->Void){
        
        
        guard let appdelegete = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let contex = appdelegete.persistentContainer.viewContext
        
        let item = TitleItem(context: contex)
        
        item.original_title = model.original_title
        item.poster_path = model.poster_path
        item.overview = model.overview
        item.first_air_date = model.first_air_date
        item.media_type = model.media_type
        item.id = Int64(model.id!)
        item.original_name = model.original_name
        item.vote_average = model.vote_average!
        item.vote_count = Int64(model.vote_count!)
        
        
        do{
            try contex.save()
            completionHandler(.success(()))
        }catch{
            print("FaildToSave")
        }
        
    }
    
    
    func fetchingDataFromDatabase(completionHandler : @escaping(Result<[TitleItem],databaseError>)->Void){
        
        guard let appdelegete = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context = appdelegete.persistentContainer.viewContext
        
        let request : NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        do{
            let titles = try context.fetch(request)
            completionHandler(.success(titles))
            
        }catch{
            completionHandler(.failure(.failedTogetData))
        }
    }
    
    func deleteTitleWith(model : TitleItem , completionHandler : @escaping (Result <Void , databaseError>)->Void){
        
        guard let appdelegete = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context = appdelegete.persistentContainer.viewContext
        context.delete(model)
        do{
            try context.save()
            completionHandler(.success(()))
        }catch{
            completionHandler(.failure(.failedToDeleteData))
        }
    }
}
