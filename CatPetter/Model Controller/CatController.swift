//
//  CatController.swift
//  CatPetter
//
//  Created by Haley Jones on 5/15/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//

import UIKit
class CatController{
    
    //singleton
    static let shared = CatController()
    //Save the API key for shorthand
    let apiKey = "7d821e1d-f584-4832-935a-07a3f86a5280"
    
    //CRUD
    
    //we need to get a random cat.
    func fetchCat(apiKey: String, completion: @escaping (Cat?) -> Void){
        guard let baseURL = URL(string:"https://api.thecatapi.com/v1/images/search") else {completion(nil); return}
        var request = URLRequest(url: baseURL)
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.httpBody = nil
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            //if the error isnt nil, handle the error
            if let error = error{
                print ("There was an error fetching a cat. \(error.localizedDescription)")
                completion(nil)
                return
            }
            //so the data it passes will be optional. So we have to unwrap that.
            guard let unwrappedData = data else {completion(nil); return}
            print(unwrappedData)
            //and then we should be able to decode it into an object!
            let catDecoder = JSONDecoder()
            //free the cat from the data zone!
            do{
                let cat = try catDecoder.decode([Cat].self, from: unwrappedData)
                completion(cat[0])
            } catch {
                print ("There was an error decoding the cat. \(error.localizedDescription)")
                completion(nil)
                return
            }
        }.resume()
    }
    
    //We got a cat! Now we can get its image.
    func fetchCatImage(cat: Cat, apiKey: String, completion: @escaping (UIImage?) -> Void) {
        guard let baseURL = URL(string: cat.url) else {completion(nil); return}
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        request.httpBody = nil
        //make sure u remember that API key in the header.
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error{
                print("There was an error with the image request. \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let fetchedData = data else {completion(nil); return}
            let image = UIImage(data: fetchedData)
            completion(image)
        }.resume()
    }
}
