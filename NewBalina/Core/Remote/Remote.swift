//
//  Remote.swift
//  NewBalina
//
//  Created by Илья Салей on 24.06.23.
//

import Foundation

protocol Remote {
    func requestItems(completion: @escaping ((Result<StoredModel, Swift.Error>)->(Void)))
    func upload(item: StoredContent, completion: @escaping ((Result<UploadResponse, Swift.Error>) -> (Void)))
}
