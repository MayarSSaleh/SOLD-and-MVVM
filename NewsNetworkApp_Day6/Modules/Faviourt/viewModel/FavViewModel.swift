//
//  FavViewModel.swift
//  NewsNetworkApp_Day6
//
//  Created by mayar on 22/06/2024.
//

import Foundation
import CoreData

protocol FavProtocol {

    static var bindResultToView: (() -> Void) { get set }
    static var newsItems: [NSManagedObject] { get set }
    
    static func fetchDataFromCoreData()
    static func convertToNewsObject(newsManagedObject: NSManagedObject) -> News?
    static func removeFromCoreData(object:NSManagedObject)
}


class FavViewModel : FavProtocol {
    
    static var bindResultToView : (() -> Void) = {}
    static var newsItems: [NSManagedObject] = []{
        didSet{
            bindResultToView()
        }
    }

    static func fetchDataFromCoreData()  {
        newsItems = CoreData.fetchDataFromCoreData()
    }
    
   static func convertToNewsObject(newsManagedObject: NSManagedObject) -> News? {
        // Convert NSManagedObject to News object
        let news = News()
        news.author = newsManagedObject.value(forKey: "author") as? String
        news.title = newsManagedObject.value(forKey: "title") as? String
        news.desription = newsManagedObject.value(forKey: "desription") as? String
        news.publishedAt = newsManagedObject.value(forKey: "publishedAt") as? String
        news.imageUrl = newsManagedObject.value(forKey: "imageUrl") as? String
        
        return news
    }
    
    
    static  func removeFromCoreData(object:NSManagedObject) {
        CoreData.removeFromCoreData(object: object)
    }
    
}
