//
//  CoreData.swift
//  NewsNetworkApp_Day6
//
//  Created by mayar on 22/06/2024.
//

import Foundation
import CoreData

class CoreData {
    
    let context = CommoneObjects.context
    
    static  func fetchDataFromCoreData() ->  [NSManagedObject] {
        var newsItems: [NSManagedObject] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NewsTable")
        do {
            newsItems = try CommoneObjects.context.fetch(fetchRequest)
            return newsItems
        } catch let error {
            print("Error fetching data: \(error.localizedDescription)")
        }
        return newsItems
    }
    
 

    
  static  func storeNewsToCoreData(news: News) {
        let context = CommoneObjects.context

        let entity = NSEntityDescription.entity(forEntityName: "NewsOffline", in: context)
        let favNews = NSManagedObject(entity: entity!, insertInto: context)
        
        favNews.setValue(news.author, forKey: "author")
        favNews.setValue(news.title, forKey: "title")
        favNews.setValue(news.desription, forKey: "desription")
        favNews.setValue(news.publishedAt, forKey: "publishedAt")
        favNews.setValue(news.imageUrl, forKey: "imageUrl")
        
        do {
            try context.save()
            print("News saved to Core Data")
        } catch {
            print("Error saving news to Core Data: \(error.localizedDescription)")
        }
        
    }
   static func deleteAllDataFromCoreData() {
       let context = CommoneObjects.context

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsOffline")
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            print("All data deleted from Core Data")
        } catch {
            print("Error deleting data from Core Data: \(error.localizedDescription)")
        }
    }
    
    
    
    static  func removeFromCoreData(object:NSManagedObject) {
        let context = CommoneObjects.context
        context.delete(object)
        
        do {
            try context.save()
            print("News removed from Core Data and table view")
        } catch {
            print("Error removing news from Core Data: \(error.localizedDescription)")
        }
        
    }
    
    static func isNewsSavedToCoreData(newsTitle: String) -> Bool {
        let context = CommoneObjects.context
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsTable")
        fetchRequest.predicate = NSPredicate(format: "title == %@", newsTitle )
        
        do {
            let result = try context.fetch(fetchRequest)
            return !result.isEmpty
        } catch {
            print("Error fetching news: \(error.localizedDescription)")
            return false
        }
    }
    
    static  func saveToCoreData(news:News) {
        
        let context = CommoneObjects.context
        let entity = NSEntityDescription.entity(forEntityName: "NewsTable", in: context)
        let favNews = NSManagedObject(entity: entity!, insertInto: context)
        
        favNews.setValue(news.author, forKey: "author")
        favNews.setValue(news.title, forKey: "title")
        favNews.setValue(news.desription, forKey: "desription")
        favNews.setValue(news.publishedAt, forKey: "publishedAt")
        favNews.setValue("", forKey: "imageUrl")
        
        do {
            try context.save()
            print("News saved to Core Data")
        } catch {
            print("Error saving news to Core Data: \(error.localizedDescription)")
        }
    }
    
    static func removeFromCoreData(title: String) {
        let context = CommoneObjects.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsTable")
        fetchRequest.predicate = NSPredicate(format: "title == %@",title)
        do {
            let result = try context.fetch(fetchRequest)
            guard let objectToDelete = result.first as? NSManagedObject else { return }
            context.delete(objectToDelete)
            try context.save()
            print("News removed from Core Data")
        } catch {
            print("Error removing news from Core Data: \(error.localizedDescription)")
        }
    }
    
}
