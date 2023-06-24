//
//  BalinaRepository.swift
//  NewBalina
//
//  Created by Илья Салей on 24.06.23.
//

import Foundation

final class BalinaRepository {
    
    private let remote: Remote
    
    init(remote: Remote) {
        self.remote = remote
    }
    
    func requestItems(completion: @escaping ((Result<StoredModel, Swift.Error>) -> (Void))) {
        remote.requestItems(completion: completion)
    }
    
    func upload(item: StoredContent, completion: @escaping ((Result<UploadResponse, Swift.Error>) -> (Void))) {
        remote.upload(item: item, completion: completion)
    }
}
