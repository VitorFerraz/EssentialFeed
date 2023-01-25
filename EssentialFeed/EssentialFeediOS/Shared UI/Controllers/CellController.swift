//
//  CellController.swift
//  EssentialFeediOS
//
//  Created by Vitor Ferraz Varela on 11/01/23.
//

import UIKit

public struct CellController {
    var id: AnyHashable
    let dataSource: UITableViewDataSource
    let delegate: UITableViewDelegate?
    let dataSourcePrefetching: UITableViewDataSourcePrefetching?

    public init(id: AnyHashable, _ dataSource: UITableViewDataSource) {
        self.dataSource = dataSource
        delegate = nil
        dataSourcePrefetching = nil
        self.id = id
    }

    public init(id: AnyHashable, _ dataSource: UITableViewDataSource & UITableViewDelegate & UITableViewDataSourcePrefetching) {
        self.dataSource = dataSource
        delegate = dataSource
        dataSourcePrefetching = dataSource
        self.id = id
    }
}

extension CellController: Equatable {
    public static func == (lhs: CellController, rhs: CellController) -> Bool {
        lhs.id == rhs.id
    }
}

extension CellController: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
