//
//  ViewController.swift
//  CustomTransitionsAnimations
//
//  Created by Alex Golub on 8/3/16.
//  Copyright © 2016 Alex Golub. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let numberOfSections = 1
    let cellIdentifier = "cellIdentifier"
    let sourceArray = []

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

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
        cell.textLabel?.text = sourceArray[indexPath.row] as? String
        return cell
    }

    // MARK: TableView Delegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}

