//
//  URLBuilder.swift
//  SampleApp
//
//  Created by natehancock on 6/28/22.
//

import Foundation


struct URLBuilder {
    var baseURL: String
    var word: String

    var searchRequestURL: String {
        let url = baseURL + word + "?key=" + Tokens.apiKeyDict
        return url
    }
    
    var thesaurusRequestURL: String {
        let url = baseURL + word + "?key=" + Tokens.apiKeyThes
        return url
    }
}
