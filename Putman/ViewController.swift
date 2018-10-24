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
        print(self.childViewControllers)
        for child in childViewControllers {
            print(child, child.identifier)
            if child is NSSplitViewController {
                for child in child.childViewControllers {
                    print("\t",child, child.identifier)
                    if child.identifier?.rawValue == "body" {
                        self.bodyController = child as! BodyController
                    }
                    if let child = child as? TableViewController {
                        self.headerController = child
                    }
                }
            }
        }
        
        loadAndPresent()
    }
    
    private func loadAndPresent() {
        let url = URL(string: "http://127.0.0.1:8124/")!
        call(url: url){ data, response, error in
            print("completion")
            print(data, error, response)
            self.headerController?.headers = Array(response!.allHeaderFields)
            DispatchQueue.main.async {
                self.headerController?.table.reloadData()
                if let data = data, let body = String(data: data, encoding: .utf8) {
                    self.bodyController?.textView.insertText(body)
                } else {
                    print(data)
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

class TopViewController: NSViewController {
    override func viewDidLoad() {
        ValueTransformer.setValueTransformer(ComponentsTransformer(), forName: ComponentsTransformer.name)
        super.viewDidLoad()
    }
    @objc dynamic var params: [NSURLQueryItem] = [] // Must be declared dynamic if using bindings; Use NS variant over struct variant for compatibility with NSArrayController
    @IBOutlet weak var paramsTableView: NSTableView!
    @IBAction func methodPopUpDidChange(_ sender: NSPopUpButton) {
        print(#function, sender.selectedItem!.identifier!.rawValue)
    }
}

extension TopViewController: NSTextFieldDelegate {
    override func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        //print(#function, textField.stringValue)
        guard let url = URL(string: textField.stringValue), let components = URLComponents(url: url, resolvingAgainstBaseURL: false), var queryItems = components.queryItems else { return self.params.removeAll() }
        //print(queryItems)
        queryItems.append(URLQueryItem(name: "", value: nil))
        self.params = queryItems as [NSURLQueryItem]
        paramsTableView.reloadData()
    }
}

class Grej: NSObject {
    // NB: Any value returned from a ValueTransformer to an ObjectController must be KVC compliant, hence the @objc variable declarations
    @objc var name: String
    @objc var value: String
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

// Use @objc() declaration with explicit name to avoid automatic name mangling which prevents ObjectController from finding the class
@objc(ComponentsTransformer) class ComponentsTransformer: ValueTransformer {
    static let name = NSValueTransformerName("ComponentsTransformer")
    /*
    override class func transformedValueClass() -> AnyClass {
        return Grej.self
        return NSString.self
    }
     */
    override func transformedValue(_ value: Any?) -> Any? {
        print(#function, value)
        return [Grej(name: "hej", value: "grej")]
    }
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        print(#function, value)
        return nil
    }
}
