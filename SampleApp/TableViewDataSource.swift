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
            return 1 // Returning `1` for the single cell that we set up in this same case within cellForRowAt:
        }
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard case let State.words(words) = state  else {
            // Set up and return single cell for empty-state
            let cell: WordTableViewCell = createCellForEmptyState(tableView: tableView, indexPath: indexPath)
            // I don't quite know how yet, but calling this `animateForEmpty()` here can create a weird bug where the cells in the valid State still have an adjusted .alpha -> I've broken on the only assignment of the .alpha and it doesn't ever hit when we're in a valid State.. assuming it has something to do with cells not quite being dequeued after we show (and animate) the empty State cell.. still investigating, but leaving here for now for the visual purposes.
            cell.animateForEmpty()
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

extension ViewController: UITableViewDelegate {
    // Moved this Delegate extension into this file to keep it with the DataSource. Normally I would change the name of this file in this case, but naming is hard.. I might call this file like .. SearchTableViewController ..? or something like that.
}


extension TableViewDataSource {
    // Used to create the cell shown in certain cases related to a State or specific APIError type
    // TODO: This could maybe be pulled into some other ErrorCellHandling class? Especially as the number of possible APIErrors increases
    func createCellForEmptyState(tableView: UITableView, indexPath: IndexPath) -> WordTableViewCell {
        let cell: WordTableViewCell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath) as? WordTableViewCell ?? WordTableViewCell()
        
        if let error = error, error == .tooShort {
            cell.wordTitleLabel.text = "Oops . . "
            cell.flLabel.text = ". . .that search was too short"
            cell.taglineLabel.text = "..it's got to be more than a two characters..."
            cell.wordDefinitionLabel.text = "... I can understand if that's too restrictive, we've got to have some contraints on you, such as language is to thought...."
        } else if let error = error, error == .emptyQuery {
            cell.wordTitleLabel.text = "Ahh . . "
            cell.flLabel.text = ". . .well you've got to enter something"
            cell.taglineLabel.text = "..the word must be at least one character..."
            cell.wordDefinitionLabel.text = "... make it something interseting too.. please? I've seen sooo many lame searches, give me something new...."
        } else if let error = error, error == .noData {
            cell.wordTitleLabel.text = "That's not good . . "
            cell.flLabel.text = ". . .there's been an error"
            cell.taglineLabel.text = "...you've really bungled this..."
            cell.wordDefinitionLabel.text = "... mayyyybe just try searching another word, if this keeps happening please email us at wedefinitlycare@pura.com...."
        }
        else {
            cell.wordTitleLabel.text = "Go ahead . . "
            cell.flLabel.text = ". . .search a word above"
            cell.taglineLabel.text = "..it will be totally worth it..."
            cell.wordDefinitionLabel.text = "... okay, maybe it won't be worth it. I mean, you can literally just ask Siri to get the definition of a word for you."
        }
        
        return cell // TODO: In this case, we're returning an default instance of WordTableViewCell, which would show the user the default text we have for each field in the .xib. So would probably want to either 1) Change the defaults in the .xib to be user-facing (but unable to be localized) or 2) Set up a "default" set of text (that we can localize) to assign for this case.
    }
}
