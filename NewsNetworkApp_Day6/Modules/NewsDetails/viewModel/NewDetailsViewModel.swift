//
//  NewDetailsViewModel.swift
//  NewsNetworkApp_Day6
//
//  Created by mayar on 22/06/2024.
//

import Foundation
import Foundation

protocol NewDetailsViewModelProtocol {
    var bindToView: (() -> Void)? { get set }
    var newsItem : News? { get set }
    static func isNewsSavedToCoreData(newsTitle: String) -> Bool
    static func saveToCoreData(news: News)
    static func removeFromCoreData(news: News)
}


class NewDetailsViewModel : NewDetailsViewModelProtocol {
    
    var bindToView : (() ->Void )?
    
    var newsItem: News?{
        didSet {
            print("print newsItem is set")
            bindToView?()
        }
    }
    
    static func isNewsSavedToCoreData(newsTitle: String) -> Bool {
       return CoreData.isNewsSavedToCoreData(newsTitle: newsTitle)
    }
    
    static func saveToCoreData(news:News) {
        CoreData.saveToCoreData(news: news)
    }
    
    static func removeFromCoreData(news:News) {
        CoreData.removeFromCoreData(title: news.title ?? "")
    }

}
