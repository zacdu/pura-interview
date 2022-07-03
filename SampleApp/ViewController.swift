//
//  ViewController.swift
//  SampleApp
//
//  Created by natehancock on 6/28/22.
//

import UIKit

class ViewController: UIViewController {

    var dataSource = TableViewDataSource(state: .empty)
    
    @IBOutlet weak var textField: WordSearchTextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func didTapButton() {
        guard let text = textField.text, !text.isEmpty else {
            self.dataSource.updateState(.empty, error: APIError.emptyQuery) { // Here, this isn't _really_ an API error, so might want to think through fleshing out our dataSource.updateState() error handling to allow for errors coming from either the API or, in the case, the ViewController (empty textField)
                self.textField.shake(duration: 0.08, autoReverse: true, repeatCount: 5)
                self.tableView.reloadData()
            }
            return
        }
        
        API.shared.fetchWord(query: text) { response in
            switch response {
            case .success(let data):
                guard let r = WordResponse.parseData(data) else {
                    self.dataSource.updateState(.empty, error: APIError.noData) {
                        self.textField.shake(duration: 0.02, autoReverse: false, repeatCount: 2)
                        self.tableView.reloadData()
                    }
                    return
                }
                var words: [Word] = []
                for response in r {
                    words.append(response.word)
                }
                self.dataSource.updateState(.words(words)) {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                self.dataSource.updateState(.empty, error: error) {
                    self.textField.shake(duration: 0.05, autoReverse: true, repeatCount: 3)
                    self.tableView.reloadData()
                }
                // Ideally here we would want to change this from a `print()` to something more "logging" specfic, that we could turn on and off as devs. Stacking up `print()` statements over a large codebase can create an unreadable debugging Outputs
                print("NETWORK ERROR: ", error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }


}
