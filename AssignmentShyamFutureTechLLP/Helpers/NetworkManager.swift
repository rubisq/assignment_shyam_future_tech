//
//  NetworkManager.swift
//  AssignmentShyamFutureTechLLP
//
//  Created by openweb on 14/02/23.
//

import Foundation
import Combine

enum NetworkError: Error{
    case invalidUrl, requestError, decodingError, statusNotOk
}

let BASE_URL: String = "https://picsum.photos/v2"

struct NetworkManager {
    
    func fetchData<T: Decodable>(endpoint: String, responseDecoder: T.Type) -> AnyPublisher<T, Error> {
        
        guard let url = URL(string:  "\(BASE_URL)/\(endpoint)") else {
            return Fail(error: NetworkManagerError.apiErrorWithCustomMessage(code: -1, message: "Invalid URL.")).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode >= 200,
                      httpResponse.statusCode < 300 else {
                    throw NetworkManagerError.apiErrorWithCustomMessage(code: -2, message: "Bad response.")
                }
                return data
            }
            .decode(type: responseDecoder, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}

enum NetworkManagerError: Error {
    case apiErrorWithCustomMessage(code: Int, message: String?)
}


extension NetworkManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .apiErrorWithCustomMessage(_, let message):
            return NSLocalizedString(message ?? "NetworkManagerError error!", comment: "NetworkManagerError custom error.")
        }
    }
}
