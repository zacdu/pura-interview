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
            self.dataSource.updateState(.empty, error: APIError.emptyQuery) {
                self.textField.shake(duration: 0.08, autoReverse: true, repeatCount: 5)
                self.tableView.reloadData()
            }
            return
        }
        
        API.shared.fetchWord(query: text) { response in
            switch response {
            case .success(let data):
                guard let r = WordResponse.parseData(data) else {
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

extension ViewController: UITableViewDelegate {

}
