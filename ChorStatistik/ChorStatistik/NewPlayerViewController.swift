//
//  NewPlayerViewController.swift
//  ChorStatistik
//
//  Created by Christian Toni on 28.12.16.
//  Copyright © 2016 Christian Toni. All rights reserved.
//

import UIKit
import CoreData

extension Notification.Name {
    static let reload = Notification.Name("reload")
}

class NewPlayerViewController: UIViewController, NSFetchedResultsControllerDelegate {

    var players: [NSManagedObject] = []
    
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfBirthday: UITextField!
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
  
    @IBAction func bDayEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Fertig", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewPlayerViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Abbrechen", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewPlayerViewController.donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        datePickerView.datePickerMode = UIDatePickerMode.date
            
        sender.inputView = datePickerView
        sender.inputAccessoryView = toolBar
        
        datePickerView.addTarget(self, action: #selector(NewPlayerViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        storePlayer(name: tfName.text!, firstname: tfFirstName.text!, birthday: tfBirthday.text!)
        NotificationCenter.default.post(name: .reload, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func donePicker(){
        self.tfBirthday.resignFirstResponder()
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        tfBirthday.text = dateFormatter.string(from: sender.date)
        
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func storePlayer (name: String, firstname: String, birthday: String) {
        let context = getContext()
        
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "Player", in: context)
        
        let player = NSManagedObject(entity: entity!, insertInto: context)
        
        var id = 1
        
        for pl in players {
            let temp = pl.value(forKey: "id") as! Int
            if id <=  temp{
                id = temp + 1
            }
        }
        
        //let strTime = "2015-07-27 19:29:50 +0000"
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let formattedBday = formatter.date(from: birthday)
        
        //set the entity values
        player.setValue(id, forKey: "id")
        player.setValue(name, forKey: "name")
        player.setValue(firstname, forKey: "firstName")
        player.setValue(formattedBday, forKey: "birthday")
        
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
