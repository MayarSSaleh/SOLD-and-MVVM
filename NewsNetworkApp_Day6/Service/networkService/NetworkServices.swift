//
//  NetworkServices.swift
//  NewsNetworkApp_Day6
//
//  Created by mayar on 22/06/2024.
//

import Foundation


protocol NetworkServiceProtocol {
    func fetchData(from url: String, completion: @escaping (Data?, Error?) -> Void)
}


class NetworkServices: NetworkServiceProtocol {
    func fetchData(from url: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("No data")
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"]))
                return
            }
            completion(data, nil)
        }
        
        task.resume()
    }
    

}
