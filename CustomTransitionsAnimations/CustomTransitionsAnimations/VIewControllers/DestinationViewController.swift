//
//  DestinationViewController.swift
//  CustomTransitionsAnimations
//
//  Created by Alex Golub on 8/4/16.
//  Copyright © 2016 Alex Golub. All rights reserved.
//

import UIKit

class DestinationViewController: UIViewController {

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = false
    }

    // MARK: Actions

    @IBAction func userDidPressedBack(button: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
