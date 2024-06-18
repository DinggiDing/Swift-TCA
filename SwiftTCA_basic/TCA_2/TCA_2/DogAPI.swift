//
//  DogAPI.swift
//  TCA_2
//
//  Created by 성재 on 6/17/24.
//

import Foundation
import Combine
import Alamofire
import ComposableArchitecture

@DependencyClient
struct DogAPI {
    var dogimage: @Sendable () async throws -> [DogImage]
}

extension DependencyValues {
  var dogAPI: DogAPI {
    get { self[DogAPI.self] }
    set { self[DogAPI.self] = newValue }
  }
}

extension DogAPI: DependencyKey {
    static let liveValue = DogAPI(
        dogimage: {
//            var components = URLComponents(string: "https://api.thedogapi.com/v1/images/search")!
//            components.queryItems = [
//                URLQueryItem(name: "limit", value: "\(10)"),
//                URLQueryItem(name: "api_key", value: Config.shared.apiKey)
//            ]
//            
//            let (data, _) = try await URLSession.shared.data(from: components.url!)
//            return try JSONDecoder().decode([DogImage].self, from: data)
            
            let url = "https://api.thedogapi.com/v1/images/search"
            let parameters: [String: String] = [
                "limit": "10",
                "api_key": Config.shared.apiKey
            ]

            return try await withCheckedThrowingContinuation { continuation in
                AF.request(url, parameters: parameters)
                    .validate()
                    .responseDecodable(of: [DogImage].self) { response in
                        switch response.result {
                        case .success(let dogImages):
                            continuation.resume(returning: dogImages)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
            }
        }
    )
}

struct DogImage: Decodable, Equatable, Sendable {
    var breeds: [Breed]
    var id: String
    var url: String
    var width: Int?
    var height: Int?
    
    struct Breed: Decodable, Equatable, Sendable {
        var id: Int
        var name: String
        var weight: Measurement
        var height: Measurement
        var breed_group: String?
        var life_span: String
        var temperament: String?
        
        struct Measurement: Decodable, Equatable, Sendable {
            var imperial: String
            var metric: String
        }
    }
}

class Config {
    static let shared = Config()

    var apiKey: String {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let key = plist["API_KEY"] as? String {
            return key
        } else {
            fatalError("API Key not found in Config.plist")
        }
    }

    private init() {}
}
