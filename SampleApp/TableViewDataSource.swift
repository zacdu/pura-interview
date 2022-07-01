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
            return 0
        }
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard case let State.words(words) = state  else {
            return UITableViewCell()
        }
        let cell: WordTableViewCell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath) as? WordTableViewCell ?? WordTableViewCell()
        let word = words[indexPath.row]
        cell.wordTitleLabel.text = "\(word.text):"
        var definitionString = ""
        for (i, def) in word.definitions.enumerated() {
            let newLineString = (i == word.definitions.endIndex - 1) ? "" : "\n\n" // if we're on the last definition, we don't include newlines, to save space per each cell.
            definitionString += "\u{2022} \(def).\(newLineString)"
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
