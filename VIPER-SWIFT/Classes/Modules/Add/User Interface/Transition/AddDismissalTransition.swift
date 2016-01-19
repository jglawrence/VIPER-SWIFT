//
//  AddDismissalTransition.swift
//  VIPER-SWIFT
//
//  Created by Conrad Stoll on 6/4/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation
import UIKit

let transitionDurationInSeconds = 0.72
let transitionAnimationDelay = 0.0
let transitionAnimationSpringWithDamping: CGFloat = 0.64
let transitionAnimationInitialVelocity: CGFloat = 0.22

class AddDismissalTransition : NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transitionDurationInSeconds
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? AddViewController else { return }
        
        let finalCenter = CGPointMake(160.0, (fromVC.view.bounds.size.height / 2) - 1000.0)
        let options = UIViewAnimationOptions.CurveEaseIn

        UIView.animateWithDuration(self.transitionDuration(transitionContext),
            delay: transitionAnimationDelay,
            usingSpringWithDamping: transitionAnimationSpringWithDamping,
            initialSpringVelocity: transitionAnimationInitialVelocity,
            options: options,
            animations: {
                fromVC.view.center = finalCenter
                fromVC.transitioningBackgroundView.alpha = 0.0
            },
            completion: { finished in
                fromVC.view.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        )
    }

}