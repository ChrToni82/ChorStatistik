//
//  NewDateViewController.swift
//  ChorStatistik
//
//  Created by Christian Toni on 31.12.16.
//  Copyright © 2016 Christian Toni. All rights reserved.
//

import UIKit
import CoreData

class NewDateViewController: UIViewController, NSFetchedResultsControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var dateTableViewController = NewDateTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateTableViewController.player = self.dateTableViewController.getPlayer()
        self.dateTableViewController.tableView = self.tableView
        self.tableView.dataSource = self.dateTableViewController
        self.tableView.delegate = self.dateTableViewController
        
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(verifyAndRefreshUI), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    func verifyAndRefreshUI(_ notification : Notification){
        
        guard let _ = self.view.window else{
            return
        }
        self.dateTableViewController.tableView.reloadData()
    }
    

        // Do any additional setup after loading the view.

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveDate(_ sender: UIBarButtonItem) {
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
