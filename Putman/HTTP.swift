//  HTTP.swift
//
//  Created by Iggy Drougge on 2018-09-23.
//  Copyright © 2018 Iggy Drougge. All rights reserved.

import Foundation

func call(url: URL, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> ()) {
    print(#function)
    let task = URLSession.shared.dataTask(with: url){ data, response, error in
        //print(data, response, error)
        if let error = error {
            print(error)
            return
        }
        guard let response = response as? HTTPURLResponse else {
            fatalError()
        }
        print(response.statusCode)
        print(response.allHeaderFields)
        guard let data = data else {
            fatalError()
        }
        guard let text = String(data: data, encoding: .utf8) else {
            return print("Not text!")
        }
        print(text)
        completion(data, response, error)
    }
    task.resume()
}
