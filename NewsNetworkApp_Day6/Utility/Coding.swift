//
//  Coding.swift
//  NewsNetworkApp_Day6
//
//  Created by mayar on 22/06/2024.
//

import Foundation


protocol CodingProtocol {
     func decoding <T:Codable> (data:Data, objectType: T.Type, completion: @escaping (T? ,Error?) -> Void)
}


class Coding : CodingProtocol{
 
     func decoding <T:Codable> (data:Data, objectType: T.Type, completion: @escaping (T? ,Error?) -> Void) {
        do {
            let results = try JSONDecoder().decode(objectType.self, from: data)
            completion(results,nil)
            
        } catch {
            completion(nil,error)
        }
        
    }
    
    func decodingTwo <T:Codable> (data:Data , objectType:T.Type,completion:@escaping(T?,Error?)-> Void){
        do {
            let results = try JSONDecoder().decode(objectType.self, from: data)
            completion(results,nil)
        } catch {
            completion(nil,error)
        }
    }
    
}
