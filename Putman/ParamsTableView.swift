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
        guard
            let rawValue = notification.userInfo?["NSTextMovement"] as? Int,
            let movement = NSTextMovement(rawValue: rawValue)
            else { return assertionFailure("No text movement") }
        switch movement {
        case .up: print("NSUpTextMovement")
        case .down: print("NSDownTextMovement")
        case .backtab: print("NSBacktabTextMovement")
        case .tab: print("NSTabTextMovement")
        case .left: print("NSLeftTextMovement")
        case .right: print("NSRightTextMovement")
        case .return: print("NSReturnTextMovement")
        case .other: print("NSOtherTextMovement")
        case .cancel: print("NSCancelTextMovement")
        @unknown default: print("Totally unknown movement: \(movement)")
        }
        let row = editedRow
        let column = editedColumn
        //print("row:", row, "column:", column)
        super.textDidEndEditing(notification)
        switch movement {
        case .tab:
            let nextColumn = (column + 1) % numberOfColumns
            self.selectRowIndexes(IndexSet(integer: row), byExtendingSelection: false)
            self.editColumn(nextColumn, row: row, with: nil, select: true)
        case .return:
            let nextRow = (row + 1) % numberOfRows
            self.selectRowIndexes(IndexSet(integer: nextRow), byExtendingSelection: false)
            self.editColumn(1, row: nextRow, with: nil, select: true)
        default: return
        }
    }
}
