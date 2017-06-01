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
        
        print(deck)
        
        hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 300
        
        deckTitleTextField.text = deck.name
        accessoryTermCountItem.title =
        "\(deck.cards.count) term"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // [START screen_view_hit_swift]
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Deck Detail Add Edit View Controller")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        // [END screen_view_hit_swift]
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
        // [START custom_event_swift]
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        guard let event = GAIDictionaryBuilder.createEvent(withCategory: "Deck Edit", action: "Add a new Card", label: nil, value: nil) else { return }
        tracker.send(event.build() as [NSObject : AnyObject])
        // [END custom_event_swift]
        
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
        
//        cell.layer.borderWidth = 1
//        cell.layer.cornerRadius = 5
//        cell.layer.borderColor = UIColor.black.cgColor
        
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
