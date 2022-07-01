//
//  API.swift
//  SampleApp
//
//  Created by natehancock on 6/28/22.
//

import Foundation

class API: NSObject {
    static let shared = API()
    let session = URLSession.shared
    
    static let baseSearchUrl = "https://www.dictionaryapi.com/api/v3/references/collegiate/json/" // Not need for now, as the baseThesaurusUrl call gives us all the properties we are currently using
    static let baseThesaurusUrl = "https://www.dictionaryapi.com/api/v3/references/thesaurus/json/"
    
    func fetchWord(query: String, _ completion: @escaping (Result<Data, APIError>) -> Void) {
        guard !query.isEmpty else {
            completion(.failure(.emptyQuery))
            return
        }
        
        guard query.count > 1 else { // Single character entries we can skip, but there are plenty of two-letter words we want to allow
            completion(.failure(.tooShort))
            return
        }
        
        let requestURL = URLBuilder(baseURL: API.baseThesaurusUrl, word: query.lowercased()).thesaurusRequestURL
        
        guard let url = URL(string: requestURL) else {
            completion(.failure(.badURL))
            return
        }

        let request = URLRequest(url: url)
        
        print("Fetching from: ", request.url?.absoluteString ?? "")
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.custom(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
            
        }.resume()
        
    }
    
}
