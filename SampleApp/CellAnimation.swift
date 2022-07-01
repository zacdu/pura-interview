//
//  CellAnimation.swift
//  SampleApp
//
//  Created by Zac Duvall on 7/1/22.
//

import UIKit

class CellAnimation {
    static let shared = CellAnimation()
    
    public func cellAnimation(cell: UITableViewCell, duration: Double = 1.1, delay: Double = 0, springDampening: CGFloat = 0.5, initialSpringVelocity: CGFloat = 1, animationOptions: UIView.AnimationOptions = [.allowUserInteraction], tx: CGFloat, ty: CGFloat, scaleX: CGFloat, scaleY: CGFloat) {
        // 1. Initial state
        cell.alpha = 0
        let scale = CATransform3DScale(CATransform3DIdentity, scaleX, scaleY, 0)
        let transform = CATransform3DTranslate(scale, tx , ty, 0)
        cell.layer.transform = transform
        
        
        // 2. Use UIView.animate to animate to final state
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: springDampening, initialSpringVelocity: initialSpringVelocity, options: animationOptions, animations: {
            cell.alpha = 0.75
            cell.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }
}
