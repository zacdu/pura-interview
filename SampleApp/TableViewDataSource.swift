//
//  TableViewDataSource.swift
//  SampleApp
//
//  Created by natehancock on 6/28/22.
//

import Foundation
import UIKit


class TableViewDataSource: NSObject {
    
    enum State {
        case empty
        case words([Word])
    }

    var state: State
    init(state: State) {
        self.state = state
    }
    
    func updateState(_ state: State, completion: @escaping () -> ()) {
        self.state = state
        DispatchQueue.main.async {
            completion()
        }
    }
}

extension TableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case let State.words(words) = state  else {
            return 1
        }
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard case let State.words(words) = state  else {
            let cell: WordTableViewCell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath) as? WordTableViewCell ?? WordTableViewCell()
            cell.wordTitleLabel.text = "Go ahead . . "
            cell.flLabel.text = "...search a word above"
            cell.taglineLabel.text = "..it will be totally worth it..."
            cell.wordDefinitionLabel.text = "... okay, maybe it won't be worth it. I mean, you can literally just ask Siri to get the definition of a word for you."
            return cell
        }
        let cell: WordTableViewCell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath) as? WordTableViewCell ?? WordTableViewCell()
        let word = words[indexPath.row]
        cell.wordTitleLabel.text = "\(word.text) "
        cell.flLabel.text = word.fl
        var definitionString = ""
        for (i, def) in word.definitions.enumerated() {
            let newLineString = (i == word.definitions.endIndex - 1) ? "" : "\n" // if we're on the last definition, we don't include newlines, to save space per each cell.
            definitionString += "\u{2022} \(def).\(newLineString)"
        }
        if !word.syns.isEmpty {
            definitionString += "\n\n"
            definitionString += "synonyms: "
            for arr in word.syns {
                for (i, syn) in arr.enumerated() {
                    if i <= 5 {
                        definitionString += "\(syn), "
                    } 
                }
            }
        }
        cell.wordDefinitionLabel.text = definitionString.isEmpty ? "N/A" : definitionString
        var stemString = ""
        for stem in word.stems {
            stemString += "\(stem) \\ "
        }
        cell.taglineLabel.text = stemString.isEmpty ? "N/A" : stemString


        
        return cell
    }
}
