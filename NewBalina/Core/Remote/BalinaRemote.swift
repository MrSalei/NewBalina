//
//  BalinaRemote.swift
//  NewBalina
//
//  Created by Илья Салей on 24.06.23.
//

import Foundation
import Multipart

fileprivate enum API: String {
    case baseUrl = "https://junior.balinasoft.com"
}

final class BalinaRemote: Remote {
    
    enum Error: Swift.Error {
        case invalidURL
        case validationError
        case decodingError
    }
    
    func requestItems(completion: @escaping ((Result<StoredModel, Swift.Error>) -> (Void))) {
        let urlString = "\(API.baseUrl.rawValue)/api/v2/photo/type"
        
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let storedModel = try? JSONDecoder().decode(StoredModel.self, from: data) {
                completion(.success(storedModel))
            }
        }.resume()
    }
    
    func upload(item: StoredContent, completion: @escaping ((Result<UploadResponse, Swift.Error>) -> (Void))) {
        let urlString = "\(API.baseUrl.rawValue)/api/v2/photo"
        
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        var multipart = Multipart(type: .formData)
        multipart.append(Part.FormData(name: "typeId", value: String(item.id)))
        multipart.append(Part.FormData(name: "name", value: item.name))
        multipart.append(Part.FormData(name: "photo", fileData: item.image, fileName: "image.jpeg", contentType: "image/jpeg"))
        
        request.setMultipartBody(multipart)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let uploadResponse = try? JSONDecoder().decode(UploadResponse.self, from: data) {
                completion(.success(uploadResponse))
            }
        }.resume()
    }
}
