//
//  ViewController.swift
//  Mailbox
//
//  Created by Kelly II, Richard W. on 9/5/16.
//  Copyright © 2016 Kelly II, Richard W. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var inboxView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var laterView: UIView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var archiveView: UIView!
    @IBOutlet weak var archiveIcon: UIImageView!
    var messageOrigin: CGPoint!
    var inboxOrigin: CGPoint!
    
    
    @IBAction func menuTouchTap(sender: UIButton) {
        print("touchatap")
        if inboxView.frame.origin.x == 0 {
            UIView.animateWithDuration(0.4, animations: {
                self.menuView.frame.origin.x =   0
                self.inboxView.frame.origin.x = 300
            })
        } else {
            UIView.animateWithDuration(0.4, animations: { 
                self.menuView.frame.origin.x = -320
                self.inboxView.frame.origin.x = 0
            })
        }
    }
    @IBAction func didScreenEdgePanGesture(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translationInView(view)
        print(translation)
        if sender.state == UIGestureRecognizerState.Began {
            inboxOrigin = inboxView.center
        } else if ( sender.state == UIGestureRecognizerState.Changed) {
            menuView.frame.origin.x = translation.x - inboxView.frame.width
            inboxView.frame.origin.x = translation.x - menuView.frame.width + 320
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            if translation.x > 150 {
                menuView.frame.origin.x = 0
                inboxView.frame.origin.x = 300
            } else {
                menuView.frame.origin.x = -320
                inboxView.center = inboxOrigin
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSizeMake(320, 1120)
        let panGestureReco = UIPanGestureRecognizer(target: self, action: #selector(ViewController.onCustomPan(_:)))
        messageView.addGestureRecognizer(panGestureReco)
        
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            messageView.alpha = 1
            messageView.frame.origin.x = 0
            feedImage.frame.origin.y = 86
        }
    }
    
    func onCustomPan(panGestureRecognizer: UIPanGestureRecognizer) {
        
        // Absolute (x,y) coordinates in parent view
        let point = panGestureRecognizer.locationInView(view)
        
        // Relative change in (x,y) coordinates from where gesture began.
        let translation = panGestureRecognizer.translationInView(view)
        let velocity = panGestureRecognizer.velocityInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("Gesture began at: \(point) \(translation) \(velocity) ")
            messageOrigin = messageView.center
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("Gesture changed at: \(point) \(translation) \(velocity)")
            messageView.frame.origin.x = translation.x
            
            if (translation.x > 0) {
                // archive and delete
                print(convertValue(translation.x, r1Min: 0, r1Max: 60, r2Min: 0, r2Max: 1))
                deleteView.alpha = 0
                laterView.alpha = 0
                listView.alpha = 0
                archiveView.alpha = convertValue(translation.x, r1Min: 60, r1Max: 250, r2Min: 0, r2Max: 1)
                archiveView.frame.origin.x = translation.x - messageView.frame.width
                if translation.x > 250 {
                    archiveView.alpha = 0
                    deleteView.alpha = 1
                    deleteView.frame.origin.x = translation.x - messageView.frame.width
                }
            } else {
                // later and list
                laterView.alpha = convertValue(translation.x, r1Min: 60, r1Max: -250, r2Min: 0, r2Max: 1)
                listView.alpha = 0
                archiveView.alpha = 0
                deleteView.alpha = 0
                laterView.frame.origin.x = translation.x + messageView.frame.width
                if translation.x < -250 {
                    listView.alpha = 1
                    listView.frame.origin.x = translation.x + messageView.frame.width
                    laterView.alpha = 0
                }
            }
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("Gesture ended at: \(point) \(translation) \(velocity)")
            if (translation.x > 60 && translation.x < 250) {
                // archive view
                messageView.alpha = 0
                UIView.animateWithDuration(0.4, animations: {
                    self.archiveView.frame.origin.x = 0
                    self.feedImage.frame.origin.y = 0
                })
            } else if (translation.x > 250 && translation.x < 320) {
                // delete view
                messageView.alpha = 0
                UIView.animateWithDuration(0.4, animations: {
                    self.deleteView.frame.origin.x = 0
                    self.feedImage.frame.origin.y -= 86
                })
            } else if (translation.x > -250 && translation.x < -50) {
                // later view
                messageView.center = messageOrigin
                performSegueWithIdentifier("resechduleSegue", sender: self)
            } else if (translation.x > -320 && translation.x < -250) {
                messageView.center = messageOrigin
                performSegueWithIdentifier("laterSegue", sender: self)
            } else {
                messageView.frame.origin.x = 0
            }
        }
    }
}

