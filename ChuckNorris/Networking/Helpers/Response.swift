//
//  Response.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

typealias Response<T: Decodable> = (Result<T>) -> ()
