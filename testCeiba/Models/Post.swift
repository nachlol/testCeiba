//
//  Post.swift
//  testCeiba
//
//  Created by Nicolas Chavez on 10/21/20.
//  Copyright © 2020 Nicolas Chavez. All rights reserved.
//

import Foundation

struct Post:Codable {
    let userId:Int
    let id:Int
    let title: String
    let body:String
}
