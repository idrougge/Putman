//
//  ParamsTableView.swift
//  Putman
//
//  Created by Iggy Drougge on 2018-11-04.
//  Copyright © 2018 Iggy Drougge. All rights reserved.
//

import Cocoa

/// NSTableView subclass to handle jumping to correct row/column when tabbing
class ParamsTableView: NSTableView {
    
    override func textDidEndEditing(_ notification: Notification) {
        //print(type(of: self), #function, notification)
        guard let movement = notification.userInfo?["NSTextMovement"] as? Int else {
            return assertionFailure("No text movement")
        }
        switch movement {
        case NSUpTextMovement: print("NSUpTextMovement")
        case NSDownTextMovement: print("NSDownTextMovement")
        case NSBacktabTextMovement: print("NSBacktabTextMovement")
        case NSTabTextMovement: print("NSTabTextMovement")
        case NSLeftTextMovement: print("NSLeftTextMovement")
        case NSRightTextMovement: print("NSRightTextMovement")
        case NSReturnTextMovement: print("NSReturnTextMovement")
        case NSOtherTextMovement: print("NSOtherTextMovement")
        case NSIllegalTextMovement: print("NSIllegalTextMovement")
        default: print("Totally unknown movement: \(movement)")
        }
        let row = editedRow
        let column = editedColumn
        //print("row:", row, "column:", column)
        super.textDidEndEditing(notification)
        // TODO: Refactor for use of NSTextMovement (OSX 10.13+)
        switch movement {
        case NSTabTextMovement:
            let nextColumn = (column + 1) % numberOfColumns
            self.selectRowIndexes(IndexSet(integer: row), byExtendingSelection: false)
            self.editColumn(nextColumn, row: row, with: nil, select: true)
        case NSReturnTextMovement:
            let nextRow = (row + 1) % numberOfRows
            self.selectRowIndexes(IndexSet(integer: nextRow), byExtendingSelection: false)
            self.editColumn(1, row: nextRow, with: nil, select: true)
        default: return
        }
    }
}
