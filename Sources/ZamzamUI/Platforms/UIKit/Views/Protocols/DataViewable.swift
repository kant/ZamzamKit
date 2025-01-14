//
//  DataViewable.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2018-02-04.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit

public protocol DataViewable: AnyObject {
    var backgroundView: UIView? { get set }
    func cellForRow(at indexPath: IndexPath) -> UIView?
    func reloadData()
}

public extension DataViewable {
    /// Returns the table cell at the specified index path.
    /// - Parameter indexPath: The index path locating the row in the table view.
    func cellForRow(at indexPath: IndexPath) -> UIView? {
        switch self {
        case let tableView as UITableView:
            return tableView.cellForRow(at: indexPath)
        case let collectionView as UICollectionView:
            return collectionView.cellForItem(at: indexPath)
        default:
            return nil
        }
    }
}

// Align API's for table and collections views
// http://basememara.com/protocol-oriented-tableview-collectionview/

extension UITableView: DataViewable {}
extension UICollectionView: DataViewable {}
#endif
