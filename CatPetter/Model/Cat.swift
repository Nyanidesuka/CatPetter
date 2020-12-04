//
//  Cat.swift
//  CatPetter
//
//  Created by Haley Jones on 5/15/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//

import Foundation

struct Cat: Decodable{
    //the random cat will always have an ID, URL for an image, an image hieght, and an image width.
    //It will also always return a breeds array but it may be empty. I can use that.
    let id: String
    let url: String
    let height: Int
    let width: Int
    //later, because we can get some cool shit from this and Breed
    //let categories: [Category]
}

struct Category: Decodable{
    let name: String
}
