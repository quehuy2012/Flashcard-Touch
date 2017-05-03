//
//  DeckDetailAddEditViewController.swift
//  Flashcard Touch
//
//  Created by TuanAnhVu on 5/2/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

import UIKit

protocol DeckDetailAddEditViewControllerDelegate: class {
    func didEndEdit(deck:Deck)
}

class DeckDetailAddEditViewController: UIViewController {
    
    @IBOutlet weak var accessoryTermCountItem: UIBarButtonItem!
    @IBOutlet var keyboardAccessoryView: UIToolbar!
    @IBOutlet weak var deckTitleTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var cardt:[Card] = []
    
    var deck:Deck!
    
    weak var delegate:DeckDetailAddEditViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        deckTitleTextField.text = deck.name
        accessoryTermCountItem.title =
        "\(deck.cards.count) term"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptEditButton(_ sender: Any) {
        deck.identifier = deckTitleTextField.text ?? ""
        self.delegate?.didEndEdit(deck: deck)
    }

    @IBAction func addCardButtonTapped(_ sender: AnyObject) {
        deck.cards.append(Card())
        tableView.reloadData()
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

extension DeckDetailAddEditViewController : UITableViewDelegate, UITableViewDataSource, DeckDetailAddEditTableViewCellDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //UItableDatasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        print("hihi")
        print(cardt.count)
        print("-----")
        return deck.cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeckDetailAddEditTableViewCell", for: indexPath) as! DeckDetailAddEditTableViewCell
        let gramma = deck.cards[indexPath.row]
        //        cell.descriptionLabel.text = table.name
        cell.termTextField.text = gramma.term
        cell.giaiNghiaTextField.text = "\(gramma.definition)"
        
        cell.editingAccessoryType = .disclosureIndicator
        cell.delegate = self
        cell.termTextField.inputAccessoryView = keyboardAccessoryView
        cell.giaiNghiaTextField.inputAccessoryView = keyboardAccessoryView
        return cell
    }
    
    func cell(_ cell: DeckDetailAddEditTableViewCell, didEndEdit term: String, definition: String) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        deck.cards[indexPath.row].term = term
        deck.cards[indexPath.row].definition = definition
    }
}
