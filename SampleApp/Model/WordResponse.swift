//
//  WordResponse.swift
//  SampleApp
//
//  Created by natehancock on 6/28/22.
//

import Foundation


struct WordResponse: Codable {
    let meta: Meta
    let shortdef: [String]
    
    var word: Word {
        return Word(text: meta.stems.first!, definitions: shortdef, stems: meta.stems)
    }
    
    static func parseData(_ data: Data) -> WordResponse? {
        do {
            let response = try JSONDecoder().decode([WordResponse].self, from: data)
            print(response)
            return response.first
        } catch {
            print("WORD RESPONSE ERROR: ", error.localizedDescription)
        }
        return nil
    }
}
