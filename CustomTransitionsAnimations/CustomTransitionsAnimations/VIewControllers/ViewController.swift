//
//  ViewController.swift
//  CustomTransitionsAnimations
//
//  Created by Alex Golub on 8/3/16.
//  Copyright © 2016 Alex Golub. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var topBarHeightConstraint: NSLayoutConstraint!

    var topBarOpened = false
    var selectedCell: UITableViewCell!
    var selectedSegue: String!
    var openingFrame: CGRect?
    let numberOfSections = 1
    let cellIdentifier = "cellIdentifier"
    let sourceArray = ["Custom Segue", "Rounded Pop Animation", "Expand Cell(in progress)"]
    let appearSegue = "appearSegue"
    let popAnimatorSegue = "popAnimatorSegue"
    let expandAnimatorSegue = "expandAnimatorSegue"
    let appearSegueRow = 0
    let popAnimationRow = 1
    let expandCellRow = 2
    let topBarDefaultHeight: CGFloat = 64.0
    let topBarExpandedHeight: CGFloat = 150.0
    let cellHeight: CGFloat = 60
    let popAnimator = PopAnimator()
    let expandAnimator = ExpandAnimator.animator

    // MARK: View lifecycle

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == popAnimatorSegue {
            if let controller = segue.destinationViewController as? DestinationViewController {
                controller.transitioningDelegate = self
                controller.modalPresentationStyle = .Custom
            }
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    // MARK: Actions

    @IBAction func animateTopBar(button: UIButton) {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.33, initialSpringVelocity: 0, options: [], animations: {
            if self.topBarOpened == false {
                self.topBarHeightConstraint.constant = self.topBarExpandedHeight
            } else {
                self.topBarHeightConstraint.constant = self.topBarDefaultHeight
            }
            self.topBarOpened = !self.topBarOpened

            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    // MARK: TableView Data Source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) 
        cell.textLabel?.text = sourceArray[indexPath.row]

        if indexPath.row == popAnimationRow {
            cell.backgroundColor = UIColor.lightGrayColor()
        }
        return cell
    }

    // MARK: TableView Delegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case appearSegueRow:
            selectedSegue = appearSegue
        case popAnimationRow:
            selectedCell = tableView.cellForRowAtIndexPath(indexPath)
            selectedSegue = popAnimatorSegue
        case expandCellRow:
            //TODO:
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            let cellFrame = cell?.contentView.frame
            openingFrame = tableView.convertRect(cellFrame!, toView: tableView.superview)


            selectedSegue = expandAnimatorSegue

            let expandedVC = DestinationViewController()
            expandedVC.transitioningDelegate = self
            expandedVC.modalPresentationStyle = .Custom
            expandedVC.view.backgroundColor = UIColor.yellowColor()
            presentViewController(expandedVC, animated: true, completion: nil)
        default:
            print("Wrong Segue!")
        }
        performSegueWithIdentifier(selectedSegue, sender: self)
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }

    // MARK: UIViewControllerTransitioning Delegate

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch selectedSegue {
        case popAnimatorSegue:
            popAnimator.transitionMode = .Present
            popAnimator.origin = selectedCell.center
            popAnimator.circleColor = selectedCell.backgroundColor!
            return popAnimator
        case expandAnimatorSegue:
            expandAnimator.openingFrame = openingFrame!
            expandAnimator.transitionMode = .Present
            return expandAnimator
        default:
            print("Wrong Segue!")
        }
        return nil
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch selectedSegue {
        case popAnimatorSegue:
            popAnimator.transitionMode = .Dismiss
            popAnimator.origin = selectedCell.center
            popAnimator.circleColor = selectedCell.backgroundColor!
            return popAnimator
        case expandAnimatorSegue:
            expandAnimator.openingFrame = openingFrame!
            expandAnimator.transitionMode = .Dismiss
            return expandAnimator
        default:
            print("Wrong Segue!")
        }
        return nil
    }
}

