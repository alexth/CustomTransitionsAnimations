//
//  PopAnimator.swift
//  Animations
//
//  Created by Alex Golub on 12/24/15.
//  Copyright © 2015 Alex Golub. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    enum PopTransitionMode: Int {
        case Present, Dismiss
    }
    
    var transitionMode: PopTransitionMode = .Present
    
    // View of circle being presented
    var circle: UIView?
    
    // Color of cirlce, set based on button clicked
    var circleColor: UIColor?
    
    // Starting point of transition
    var origin = CGPointZero
    
    // Duration
    
    var presentDuration = 0.3
    var dismissDuration = 0.3
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        if transitionMode == .Present {
            return presentDuration
        } else {
            return dismissDuration
        }
    }
    
    // Returns the frame for the circle required to fill the screen
    func frameForCircle(center: CGPoint, size: CGSize, start: CGPoint) -> CGRect {
        let lengthX = fmax(start.x, size.width - start.x)
        let lengthY = fmax(start.y, size.height - start.y)
        let offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2
        let size = CGSize(width: offset, height: offset)
        
        return CGRect(origin: CGPointZero, size: size)
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        if transitionMode == .Present {
            // Get view of viewcontroller being presented
            let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            let originalCenter = presentedView.center
            let originalSize = presentedView.frame.size
            
            // Get frame of circle
            circle = UIView(frame: frameForCircle(originalCenter, size: originalSize, start:  origin))
            circle!.layer.cornerRadius = circle!.frame.size.height / 2
            circle!.center = origin
            
            // Make it very small
            circle!.transform = CGAffineTransformMakeScale(0.001, 0.001)
            
            // Set the background color
            circle!.backgroundColor = circleColor
            
            // Add circle to container view
            containerView!.addSubview(circle!)
            
            // Make presented view very small and transparent
            presentedView.center = origin
            presentedView.transform = CGAffineTransformMakeScale(0.001, 0.001)
            
            // Set the background color
            presentedView.backgroundColor = circleColor
            
            // Add presented view to container view
            containerView?.addSubview(presentedView)
            
            // Animate both views
            UIView.animateWithDuration(presentDuration, animations: { () -> Void in
                self.circle!.transform = CGAffineTransformMakeScale(1.0, 1.0)
                presentedView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                presentedView.center = originalCenter
                }) { (_) -> Void in
                    // On completion, complete the transition
                    transitionContext.completeTransition(true)
            }
        } else {
            // Essentially doing the same thing, but in reverse
            let returningControllerView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            let originalCenter = returningControllerView.center
            let originalSize = returningControllerView.frame.size
            
            circle!.frame = frameForCircle(originalCenter, size: originalSize, start: origin)
            circle!.layer.cornerRadius = circle!.frame.size.height / 2
            circle!.center = origin

            UIView.animateWithDuration(dismissDuration, animations: { () -> Void in
                self.circle!.transform = CGAffineTransformMakeScale(0.001, 0.001)
                returningControllerView.transform = CGAffineTransformMakeScale(0.001, 0.001)
                returningControllerView.center = self.origin
                returningControllerView.alpha = 0
                }) { (_) -> Void in
                    returningControllerView.removeFromSuperview()
                    self.circle!.removeFromSuperview()
                    transitionContext.completeTransition(true)
            }
        }
    }
}
