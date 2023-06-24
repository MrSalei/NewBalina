//
//  ViewControllerViewModel.swift
//  NewBalina
//
//  Created by Илья Салей on 24.06.23.
//

import Foundation
import Combine

final class ViewControllerViewModel {
    
    private let repository: BalinaRepository
    private(set) var itemsReceiver = PassthroughSubject<[CollectionItem], Never>()
    private(set) var alertReceiver = PassthroughSubject<String, Never>()
    
    init(repository: BalinaRepository) {
        self.repository = repository
    }
    
    func requestItems() {
        repository.requestItems { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let storedModel):
                    let collectionItems = storedModel.content.map {
                        CollectionItem(urlString: $0.image, name: $0.name)
                    }
                    self?.itemsReceiver.send(collectionItems)
                case .failure(let error):
                    self?.alertReceiver.send(error.localizedDescription)
                }
            }
        }
    }
    
    func upload(item: StoredContent) {
        repository.upload(item: item) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let uploadResponse):
                    self?.alertReceiver.send("Image successfully stored with id: " + uploadResponse.id)
                case .failure(let error):
                    self?.alertReceiver.send(error.localizedDescription)
                }
            }
        }
    }
}
