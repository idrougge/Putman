//
//  ViewController.swift
//  Putman
//
//  Created by Iggy Drougge on 2018-09-23.
//  Copyright © 2018 Iggy Drougge. All rights reserved.
//

import Cocoa

class HorSplitViewController: NSSplitViewController {
    var bodyController: BodyController?
    var headerController: TableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(type(of: self), #function)
        print(self.children)
        for child in children {
            print(child, child.identifier!)
            if child is NSSplitViewController {
                for child in child.children {
                    print("\t",child, child.identifier!)
                    if child.identifier?.rawValue == "body" {
                        self.bodyController = child as? BodyController
                    }
                    if let child = child as? TableViewController {
                        self.headerController = child
                    }
                }
            }
        }
        
        loadAndPresent()
    }
    
    @objc func loadAndPresent(url: URL? = nil) {
        let url = url ?? URL(string: "http://127.0.0.1:8124/")!
        call(url: url){ data, response, error in
            print("completion")
            print(data ?? "", error ?? "", response ?? "")
            self.headerController?.headers = Array(response!.allHeaderFields)
            DispatchQueue.main.async {
                self.headerController?.table.reloadData()
                if let data = data, let body = String(data: data, encoding: .utf8) {
                    self.bodyController?.textView.string = body
                } else {
                    print(data ?? "no data")
                }
            }
        }
    }
}

class TableViewController: NSViewController, NSTableViewDataSource {
    //var headers: [AnyHashable: Any]?
    var headers: [(key: AnyHashable, value: Any)]?

    @IBOutlet weak var table: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        //print(#function)
        return headers?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        //let header = headers?.map{$0}[row]
        let header = headers?[row]
        //print(#function, header)
        switch tableColumn?.identifier.rawValue {
        case "key"?: return header?.key
        case "value"?: return header?.value
        default: fatalError()
        }
    }
}

class BodyController: NSViewController {
    @IBOutlet weak var textView: NSTextView!
}

