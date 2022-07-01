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
    var error: APIError?
    init(state: State) {
        self.state = state
    }
    
    func updateState(_ state: State, error: APIError? = nil , completion: @escaping () -> ()) {
        self.state = state
        self.error = error
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
            let cell: WordTableViewCell = createCellForEmptyState(tableView: tableView, indexPath: indexPath)
            cell.animateForEmpty() // Is this the right place to call animate? I tried on willDisplayCell: but was not working there.
            return cell
        }
        let cell: WordTableViewCell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath) as? WordTableViewCell ?? WordTableViewCell()
        let word = words[indexPath.row]
        cell.wordTitleLabel.text = "\(word.text) "
        cell.flLabel.text = word.fl
        let definitionString = word.definitionString()
        cell.wordDefinitionLabel.text = definitionString.isEmpty ? "N/A" : definitionString
        let taglineString = word.taglineString()
        cell.taglineLabel.text = taglineString.isEmpty ? "N/A" : taglineString

        return cell
    }
}

extension TableViewDataSource {
    // Used to create the cell shown in certain cases related to a State or specific APIError type
    // TODO: This could maybe be pulled into some other ErrorCellHandling class? Especially as the number of possible APIErrors increases
    func createCellForEmptyState(tableView: UITableView, indexPath: IndexPath) -> WordTableViewCell {
        let cell: WordTableViewCell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath) as? WordTableViewCell ?? WordTableViewCell()
        
        if let error = error, error == .tooShort {
            cell.wordTitleLabel.text = "Oops . . "
            cell.flLabel.text = "...that search was too short"
            cell.taglineLabel.text = "..it's got to be more than a single character..."
            cell.wordDefinitionLabel.text = "... I can understand if that's too restrictive, we've got to have some contraints on you, such as language is to thought...."
        } else if let error = error, error == .emptyQuery {
            cell.wordTitleLabel.text = "Ahh . . "
            cell.flLabel.text = "...well you've got to enter something"
            cell.taglineLabel.text = "..the word must be at least one character..."
            cell.wordDefinitionLabel.text = "... make it something interseting too.. please? I've seen sooo many lame searches, give me something new...."
        } else if let error = error, error == .noData {
            cell.wordTitleLabel.text = "That's not good . . "
            cell.flLabel.text = "...we've really messed up now"
            cell.taglineLabel.text = "..there's been an error on getting data..."
            cell.wordDefinitionLabel.text = "... mayyyybe just try searching another word, if this keeps happening please email us at wedefinitlycare@pura.com...."
        }
        else {
            cell.wordTitleLabel.text = "Go ahead . . "
            cell.flLabel.text = "...search a word above"
            cell.taglineLabel.text = "..it will be totally worth it..."
            cell.wordDefinitionLabel.text = "... okay, maybe it won't be worth it. I mean, you can literally just ask Siri to get the definition of a word for you."
        }
        
        return cell
    }
}
