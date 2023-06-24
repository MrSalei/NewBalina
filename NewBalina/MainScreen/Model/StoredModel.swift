//
//  Model.swift
//  NewBalina
//
//  Created by Илья Салей on 24.06.23.
//

import Foundation

struct StoredModel: Decodable {
    let content: [Content]
    let page, pageSize, totalElements, totalPages: Int
}

struct Content: Decodable {
    let id: Int
    let name, image: String?
}
