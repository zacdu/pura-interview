//
//  Word.swift
//  SampleApp
//
//  Created by natehancock on 6/28/22.
//

import Foundation


struct Word: Codable {
    var text: String
    var definitions: [String]
    var stems: [String]
    var syns: [Array<String>]
    let fl: String
    
    func definitionString() -> String {
        // TODO: Think about seperating `syns` out of this `definitions` string
        // with this change, we would want to create a new view in the WordTableViewCell to assign the seperated `syns` string
        var definitionString = ""
        for (i, def) in self.definitions.enumerated() {
            let newLineString = (i == self.definitions.endIndex - 1) ? "" : "\n" // if we're on the last definition, we don't include newlines, to save space per each cell.
            definitionString += "\u{2022} \(def).\(newLineString)"
        }
        if !self.syns.isEmpty {
            definitionString += "\n\n"
            definitionString += "synonyms: "
            for arr in self.syns {
                for (i, syn) in arr.enumerated() {
                    if i <= 5 {
                        definitionString += "\(syn), "
                    }
                }
            }
        }
        return definitionString
    }
    
    func taglineString() -> String {
        var taglineString = ""
        for stem in self.stems {
            taglineString += "\(stem) \\ "
        }
        return taglineString
    }
}
