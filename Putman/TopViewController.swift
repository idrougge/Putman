//
//  TopViewController.swift
//  Putman
//
//  Created by Iggy Drougge on 2018-10-24.
//  Copyright © 2018 Iggy Drougge. All rights reserved.
//

import Cocoa

class TopViewController: NSViewController {
    override func viewDidLoad() {
        ValueTransformer.setValueTransformer(ComponentsTransformer(), forName: ComponentsTransformer.name)
        super.viewDidLoad()
    }
    @objc dynamic var editable: Bool = true
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

class TransformedValue: NSObject {
    // NB: Any value returned from a ValueTransformer to an ObjectController must be KVC compliant, hence the @objc variable declarations
    @objc var name: String
    @objc var value: String
    @objc var selected: Bool
    init(name: String, value: String) {
        self.name = name
        self.value = value
        self.selected = true
    }
    init(queryItem: URLQueryItem) {
        self.name = queryItem.name
        self.value = queryItem.value ?? "???"
        self.selected = queryItem.name == "primo"
    }
}

// Use @objc() declaration with explicit name to avoid automatic name mangling which prevents ObjectController from finding the class
@objc(ComponentsTransformer) class ComponentsTransformer: ValueTransformer {
    static let name = NSValueTransformerName("ComponentsTransformer")
    override class func transformedValueClass() -> AnyClass {
        return TransformedValue.self
    }
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    override func transformedValue(_ value: Any?) -> Any? {
        print(#function, value ?? "")
        if let value = value as? [URLQueryItem] {
            return value.map(TransformedValue.init(queryItem:))
        }
        return [TransformedValue(name: "hej", value: "grej")]
    }
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        print(#function, value ?? "")
        return nil
    }
}
