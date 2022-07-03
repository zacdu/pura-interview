//
//  WordTableViewCell.swift
//  SampleApp
//
//  Created by Zac Duvall on 7/1/22.
//

import UIKit

class WordTableViewCell: UITableViewCell {
    
    func animateForEmpty() {
        // Set initial state for animation
        wordTitleLabel.alpha = 0
        wordDefinitionLabel.alpha = 0
        taglineLabel.alpha = 0
        flLabel.alpha = 0
        
        let endAlpha = 0.65
        let options: UIView.AnimationOptions = [.curveEaseIn]
        // use UIView.animate to animate to final state
        UIView.animate(withDuration: 2, delay: 0, options: options, animations: {
            self.wordTitleLabel.alpha = endAlpha
        }, completion: nil)
        UIView.animate(withDuration: 2, delay: 3, options: options, animations: {
            self.flLabel.alpha = endAlpha
        }, completion: nil)
        UIView.animate(withDuration: 1.5, delay: 4.5, options: options, animations: {
            self.taglineLabel.alpha = endAlpha
        }, completion: nil)
        UIView.animate(withDuration: 2.5, delay: 6, options: options, animations: {
            self.wordDefinitionLabel.alpha = endAlpha
        }, completion: nil)

    }
    
    @IBOutlet weak var wordTitleLabel: UILabel!
    @IBOutlet weak var wordDefinitionLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel! // TODO: Some Words have many "stems", handle for trundication gracefully
    @IBOutlet weak var flLabel: UILabel!
}
