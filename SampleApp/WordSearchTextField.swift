//
//  WordSearchTextField.swift
//  SampleApp
//
//  Created by Zac Duvall on 7/1/22.
//

import UIKit

class WordSearchTextField: UITextField {

    func shake(duration: CFTimeInterval, autoReverse: Bool, repeatCount: Float) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.autoreverses = autoReverse
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 4, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 4, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
    }

}
