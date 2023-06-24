//
//  CollectionItem.swift
//  NewBalina
//
//  Created by Илья Салей on 24.06.23.
//

import Foundation

struct CollectionItem {
    let urlString: String
    let name: String
    
    init?(urlString: String?, name: String?) {
        if let urlString, let name {
            self.urlString = urlString
            self.name = name
        } else {
            return nil
        }
    }
}
