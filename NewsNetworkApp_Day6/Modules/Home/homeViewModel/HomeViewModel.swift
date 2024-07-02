//
//  HomeViewModel.swift
//  NewsNetworkApp_Day6
//
//  Created by mayar on 22/06/2024.
//

import Foundation

protocol HomeViewModelProtocal {
    
    var url: String { get set }
    var news: [News]? { get set }
    var bindToView: (() -> Void) { get set }
    func fetchData()
  
}

protocol HandleCoreData {
    func storeAllNewsToCoreData(newsArray: [News])
    func storeNewsToCoreData(news: News)
    func deleteAllDataFromCoreData()
}

class HomeViewModel : HomeViewModelProtocal , HandleCoreData {
    
    var url = fetchUrl
    
    var networkService: NetworkServiceProtocol?
//    = NetworkServices() // i can replace NetworkServices with anothe data source
    
    var dataCoding: CodingProtocol?
//    = Coding()
    
    var news : [News]? {
        didSet {
            print("in did set")

            bindToView()
        }
    }
    var bindToView : ( ()->Void) = {}

    // i can replace NetworkServices with anothe data source to follow dependency inversion
    init(networkService: NetworkServiceProtocol = NetworkServices(), dataCoding: CodingProtocol = Coding()) {
           self.networkService = networkService
           self.dataCoding = dataCoding
       }
    
     
    var model: [News]?{
        didSet {
            bindToViewTwo()
        }
    }
    
    var bindToViewTwo : (()-> Void) = {}
    
    func fetchData(){
        networkService?.fetchData(from: url){ [weak self ] data, error in
            
            guard let self = self, let data = data else {
                print("error\(error)")
            return
            }
            
            dataCoding?.decoding(data: data, objectType: [News].self){ results , error in
                if let error = error {
                    print ("erroe\(error)")
                }
                self.news = results
                self.storeAllNewsToCoreData(newsArray: results ?? [])

            }
        }
    }
    
    // core data functions should be in another class
    func storeAllNewsToCoreData(newsArray: [News]) {
        for newsItem in newsArray {
            storeNewsToCoreData(news: newsItem)
        }
    }
    func storeNewsToCoreData(news: News) {
        CoreData.storeNewsToCoreData(news: news)
    }
    
    func deleteAllDataFromCoreData(){
        CoreData.deleteAllDataFromCoreData()
    }
    
    
}
