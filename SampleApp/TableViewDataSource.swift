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
        case word(Word)
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
        guard case let State.word(word) = state  else {
            return 0
        }
        return word.definitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard case let State.word(word) = state  else {
            return UITableViewCell()
        }
        let cell: WordTableViewCell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath) as? WordTableViewCell ?? WordTableViewCell()
        
        cell.wordTitleLabel.text = word.text
        cell.wordDefinitionLabel.text = word.definitions[indexPath.row]
        return cell
    }
}
