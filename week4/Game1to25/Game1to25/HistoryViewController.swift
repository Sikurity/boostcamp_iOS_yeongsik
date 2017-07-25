//
//  HistoryViewController.swift
//  Game1to25
//
//  Created by YeongsikLee on 2017. 7. 25..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var dateFormatter: DateFormatter = {
     
        let _dateFormatter = DateFormatter()
        
        _dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        
        return _dateFormatter
    }()
    
    @IBOutlet var historyTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyTable.delegate = self
        historyTable.dataSource = self
        historyTable.allowsMultipleSelectionDuringEditing = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didResetButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Really?", message: nil, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Yes", style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
            
            self.appDelegate.history = []
            self.historyTable.reloadData()
            
            self.appDelegate.save()
        })
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            print("Canelled")
        })
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: { _ in })
    }
    
    @IBAction func didCloseButtonTapped(_ sender: Any) {
        
        if( isModal ) {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.appDelegate.history.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath)
        
        let playtime = self.appDelegate.history[indexPath.row].playtime
        let name = self.appDelegate.history[indexPath.row].name
        let date = dateFormatter.string(from: self.appDelegate.history[indexPath.row].date)
        
        cell.textLabel?.text = "\(name) (\(date))"
        cell.detailTextLabel?.text = playtime
     
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {    // Delete the row from the data source
            
            self.appDelegate.history.remove(at: indexPath.row)
            self.appDelegate.save()
            
            self.historyTable.reloadData()
        }
    }
}
