//
//  APIRequestManager.swift
//  Lazesnor
//
//  Created by Tong Lin on 5/1/17.
//  Copyright © 2017 TongLin91. All rights reserved.
//

import Foundation

class APIRequestManager: Request {
    
    private let request = URLSession(configuration: URLSessionConfiguration.default)
    
    init() { }
    
    func request(endPoint: URL, completion: @escaping ((Data?)->Void)){
        
        self.request.dataTask(with: endPoint) {(data: Data?, _, error: Error?) in
            
            if let validData = data{
                completion(validData)
            }else{
                print(error?.localizedDescription ?? "Unknow error during api call - \(endPoint.absoluteString)")
            }
        }.resume()
    }
}
