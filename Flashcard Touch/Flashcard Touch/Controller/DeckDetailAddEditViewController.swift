//
//  DeckDetailAddEditViewController.swift
//  Flashcard Touch
//
//  Created by TuanAnhVu on 5/2/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

import UIKit

protocol DeckDetailTableControllerDelegate: class {
    func edit(card:Card)
}

class DeckDetailAddEditViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var cardt:[Card] = []
    
    weak var delegate:DeckDetailTableControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptEditButton(_ sender: Any) {
        
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

extension DeckDetailAddEditViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //UItableDatasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        print("hihi")
        print(cardt.count)
        print("-----")
        return cardt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeckDetailAddEditTableViewCell", for: indexPath) as! DeckDetailAddEditTableViewCell
        let gramma = cardt[indexPath.row]
        //        cell.descriptionLabel.text = table.name
        cell.termTextField.text = gramma.term
        cell.giaiNghiaTextField.text = "\(gramma.definition)"
        
        cell.editingAccessoryType = .disclosureIndicator
        
        
        return cell
    }
}
