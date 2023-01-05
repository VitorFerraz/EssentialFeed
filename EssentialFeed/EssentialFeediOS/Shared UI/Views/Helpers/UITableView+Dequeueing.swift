//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Vitor Ferraz Varela on 26/10/22.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
