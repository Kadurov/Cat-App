//
//  NetworkService.swift
//  macpaw-cat-app
//
//  Created by Kadir Kadyrov on 17.05.2020.
//  Copyright © 2020 Kadir Kadyrov. All rights reserved.
//

import Foundation
import UIKit

class NetworkService {
    static let shared = NetworkService()
    
    let URL_SCHEME = "https"
    let URL_BASE = "api.thecatapi.com"
    let URL_V1 = "/v1"
    let URL_IMAGES = "/images"
    let URL_SEARCH = "/search"
    let URL_GET_CATEGORIES = "/categories"
    let URL_GET_BREEDS = "/breeds"
    let headers = ["x-api-key": "a268c0d0-710f-4be0-b004-142c99fed668"]
    
    let session = URLSession(configuration: .default)
    //let headers = ["x-api-key": "a268c0d0-710f-4be0-b004-142c99fed668"]
    
    func getUrlOfImage(imageOfBreed breed: String) -> String {
        var ans: String = ""
        getImage(imageOfBreed: breed, onSuccess: { (Images) in
            ans = Images[0].url
        }) { (errorMessage) in
            ans = errorMessage
        }
        return ans
    }
    
    func getImage(imageOfBreed breed: String, onSuccess: @escaping (Images) -> Void, onError: @escaping (String) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.thecatapi.com"
        urlComponents.path = "\(URL_V1)" + "\(URL_IMAGES)" + "\(URL_SEARCH)"
        urlComponents.queryItems = [
            URLQueryItem(name: "breed_id", value: breed)
        ]
        
        let request = NSMutableURLRequest(url: urlComponents.url!,
            cachePolicy: .useProtocolCachePolicy,
        timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                
                //print(String(decoding: data!, as: UTF8.self))
                
                
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }
                
                do {
                    if response.statusCode == 200 {
                        let images = try JSONDecoder().decode(Images.self, from: data)
                        
                        onSuccess(images)
                    } else {
                        let err = try JSONDecoder().decode(APIError.self, from: data)
                        onError(err.message)
                    }
                }
                catch {
                    onError(error.localizedDescription)
                }
            }
            
        }
        task.resume()
    }
    
    func getMubOfImage(numOfImages num: Int, imageOfBreed breed: String, onSuccess: @escaping (Images) -> Void, onError: @escaping (String) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.thecatapi.com"
        urlComponents.path = "\(URL_V1)" + "\(URL_IMAGES)" + "\(URL_SEARCH)"
        urlComponents.queryItems = [
            URLQueryItem(name: "limit", value: "\(num)"),

            URLQueryItem(name: "breed_id", value: breed)
        ]
                    
        
        //print(urlComponents.url?.absoluteString)
        let request = NSMutableURLRequest(url: urlComponents.url!,
            cachePolicy: .useProtocolCachePolicy,
        timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                
                //print(String(decoding: data!, as: UTF8.self))
                
                
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }
                
                do {
                    if response.statusCode == 200 {
                        let images = try JSONDecoder().decode(Images.self, from: data)
                        
                        onSuccess(images)
                    } else {
                        let err = try JSONDecoder().decode(APIError.self, from: data)
                        onError(err.message)
                    }
                }
                catch {
                    onError(error.localizedDescription)
                }
            }
            
        }
        task.resume()
    }
    
    func getCatBreeds(onSuccess: @escaping (Breeds) -> Void, onError: @escaping (String) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.thecatapi.com"
        urlComponents.path = "\(URL_V1)" + "\(URL_GET_BREEDS)"
        
        let request = NSMutableURLRequest(url: urlComponents.url!,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }
                
                do {
                    if response.statusCode == 200 {
                        let breeds = try JSONDecoder().decode(Breeds.self, from: data)
                        //print(breeds)
                        onSuccess(breeds)
                    } else {
                        let err = try JSONDecoder().decode(APIError.self, from: data)
                        onError(err.message)
                    }
                }
                catch {
                    onError(error.localizedDescription)
                }
            }
            
        }
        task.resume()
    }
    
    func getCatCategories(onSuccess: @escaping (Categories) -> Void, onError: @escaping (String) -> Void) {
        
        //let url = URL(string: "\(URL_BASE)" + "\(URL_GET_CATEGORIES)")!
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.thecatapi.com"
        urlComponents.path = "\(URL_V1)" + "\(URL_GET_CATEGORIES)"
        
        let request = NSMutableURLRequest(url: urlComponents.url!,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                
                
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }
                
                do {
                    if response.statusCode == 200 {
                        let categories = try JSONDecoder().decode(Categories.self, from: data)
                        
                        onSuccess(categories)
                    } else {
                        let err = try JSONDecoder().decode(APIError.self, from: data)
                        onError(err.message)
                    }
                }
                catch {
                    onError(error.localizedDescription)
                }
            }
            
        }
        task.resume()
    }
    
    func downloadPicture(CatURL: String, onSuccess: @escaping (UIImage) -> Void, onError: @escaping (String) -> Void) {
        
        let url:URL
        if(CatURL != "") {
             url = URL(string: "\(CatURL)")!
        }
        else {
            url = URL(string: "https://cdn2.thecatapi.com/images/TGuAku7fM.jpg")!
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                //print(String(decoding: data!, as: UTF8.self))
                
                
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }
                
                if response.statusCode == 200 {
                    let image = UIImage(data: data)
                    onSuccess(image!)
                } else {
                    onError("Couldn't get image: Image is nil")
                }
            }
            
        }
        task.resume()
    }
}
