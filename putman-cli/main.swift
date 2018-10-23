//
//  main.swift
//  putman-cli
//
//  Created by Iggy Drougge on 2018-09-23.
//  Copyright © 2018 Iggy Drougge. All rights reserved.
//

import Foundation

print("Hello, World!")

let url = URL(string: "http://127.0.0.1:8124/")!
call(url: url){ _, _, _ in
    exit(0)
}
dispatchMain()
