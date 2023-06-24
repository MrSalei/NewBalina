//
//  StoredContent.swift
//  NewBalina
//
//  Created by Илья Салей on 24.06.23.
//

import Foundation

struct StoredContent: Encodable {
    let id: Int
    let name: String
    let image: Data
}
