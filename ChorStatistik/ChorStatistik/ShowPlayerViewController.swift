//
//  ShowPlayerViewController.swift
//  ChorStatistik
//
//  Created by Christian Toni on 30.12.16.
//  Copyright © 2016 Christian Toni. All rights reserved.
//

import UIKit
import CoreData


class ShowPlayerViewController: UIViewController {

    var players:[NSManagedObject] = []
    var selectedRow = 0
    var editPressed = 0
    var tfFirstNameHasChanged = false
    var tfNameHasChanged = false
    var tfBirthdayHasChanged = false
    var tempBirthday:String!
    var pl:NSManagedObject!
    
    @IBOutlet weak var tfBirthday: UITextField!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var btnEdit: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pl = self.players[self.selectedRow]
        self.tfName.text = pl.value(forKey: "name") as! String?
        self.tfFirstName.text = pl.value(forKey: "firstName") as! String?
        self.tfFirstName.addTarget(self, action: #selector(ShowPlayerViewController.tfDidChange(textField:)), for: UIControlEvents.editingChanged)
        self.tfName.addTarget(self, action: #selector(ShowPlayerViewController.tfDidChange(textField:)), for: UIControlEvents.editingChanged)
        self.tfBirthday.addTarget(self, action: #selector(ShowPlayerViewController.tfDidChange(textField:)), for: UIControlEvents.editingChanged)
        navigationItem.title = "\(self.pl.value(forKey: "id")!)"
        
        let myFormatter = DateFormatter()
        myFormatter.dateStyle = .medium
        
        if pl.value(forKey: "birthday") == nil {
            self.tfBirthday.text = "Keine Angabe"
        }
        else
        {
           self.tfBirthday.text = myFormatter.string(from: self.pl.value(forKey: "birthday")  as! Date)
        }

        

        // Do any additional setup after loading the view.
    }

    func donePicker(){
        self.tfBirthday.text = self.tempBirthday
        self.tfBirthdayHasChanged = true
        
        self.tfBirthday.resignFirstResponder()
    }
    
    func cancelPicker(){
        self.tfBirthday.resignFirstResponder()
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        self.tempBirthday = dateFormatter.string(from: sender.date)
        
    }


    func tfDidChange(textField: UITextField) {
        switch textField {
        case self.tfFirstName:
            self.tfFirstNameHasChanged = true
        case self.tfName:
            self.tfNameHasChanged = true
        case self.tfBirthday:
            self.tfBirthdayHasChanged = true
        default:
            break
        }
            }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func bDayEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Fertig", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ShowPlayerViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Abbrechen", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ShowPlayerViewController.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.date = self.pl.value(forKey: "birthday")  as! Date
        sender.inputView = datePickerView
        sender.inputAccessoryView = toolBar
        
        datePickerView.addTarget(self, action: #selector(ShowPlayerViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }

    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        switch editPressed {
        case 0:
            let btnReady = UIBarButtonItem(title: "Fertig", style: .plain, target: self, action: #selector(ShowPlayerViewController.editAction(_:)))
            self.navigationItem.rightBarButtonItem  = btnReady
            self.btnEdit = btnReady
            print("\(self.btnEdit.title)")
            
            self.tfFirstName.isEnabled = true
            self.tfName.isEnabled = true
            self.tfBirthday.isEnabled = true
            self.editPressed = 1
        case 1:
            let context = getContext()
            let btnEdit = UIBarButtonItem(title: "Bearbeiten", style: .plain, target: self, action: #selector(ShowPlayerViewController.editAction(_:)))
            self.navigationItem.rightBarButtonItem  = btnEdit
            self.btnEdit = btnEdit
            self.tfFirstName.isEnabled = false
            self.tfName.isEnabled = false
            self.tfBirthday.isEnabled = false
            self.editPressed = 0
            
            if self.tfFirstNameHasChanged {
                self.pl.setValue(self.tfFirstName.text, forKey: "firstName")
                self.tfFirstNameHasChanged = false
            }
            
            if self.tfNameHasChanged {
                self.pl.setValue(self.tfName.text, forKey: "name")
                self.tfNameHasChanged = false
            }
            
            if self.tfBirthdayHasChanged {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy"
                self.pl.setValue(formatter.date(from: self.tfBirthday.text!), forKey: "birthday")
                self.tfBirthdayHasChanged = false
            }
            
            //save the object
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
        default: break
        
        }
        
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
