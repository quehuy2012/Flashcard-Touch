//
//  DeckDetailAddEditViewController.swift
//  Flashcard Touch
//
//  Created by TuanAnhVu on 5/2/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

import UIKit
import SwipeCellKit
import Firebase
import FirebaseDatabase

protocol DeckDetailAddEditViewControllerDelegate: class {
    func didEndEdit(deck:Deck)
}

class DeckDetailAddEditViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var imagePickerButton: UIBarButtonItem!
    @IBOutlet weak var accessoryTermCountItem: UIBarButtonItem!
    @IBOutlet var keyboardAccessoryView: UIToolbar!
    @IBOutlet weak var deckTitleTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var cardt:[Card] = []
    var isEditDeck = true
    var UID = ""
    var deck:Deck = Deck()
    
    var nameDeckOld = ""
    var dateconvert = ""
    
    weak var delegate: DeckDetailAddEditViewControllerDelegate?
    
    var firstResponderCell: DeckDetailAddEditTableViewCell?
    var firstResponderTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(deck)
        
        if deck.identifier == "" {
            let id = "\(decks.count + 1)"
           self.deck.cards.append(Card(term: "", definition: "", termImage: nil, definitionImage: nil, deckID: id))
        }
        
        hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .interactive
        
        nameDeckOld = deck.name
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 250, 0)
        
        deckTitleTextField.text = deck.name
        accessoryTermCountItem.title =
        "\(deck.cards.count) terms"
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        // [START screen_view_hit_swift]
//        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
//        tracker.set(kGAIScreenName, value: "Deck Detail Add Edit View Controller")
//        
//        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
//        tracker.send(builder.build() as [NSObject : AnyObject])
//        // [END screen_view_hit_swift]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func imagePickerButtonTapped(_ sender: Any) {
        let alertVC = UIAlertController(title: "Choose image", message: "Choose image for definitation", preferredStyle: .actionSheet)
        
        alertVC.addAction(UIAlertAction(title: "From Photo Library", style: .default, handler: { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
//            imagePicker.delegate = self
        }))
    }
    
    //xoá nhánh trong firebase
    func myDeleteFunction(childIWantToRemove: String) {
        
        ref.child(UID).child(childIWantToRemove).removeValue { (error, ref) in
            if error != nil {
                print("error \(error)")
            }
        }
    }
    
    @IBAction func acceptEditButton(_ sender: Any) {
        
        ref = Database.database().reference()
        
        let date = Date()
        
        dateconvert = convertDateToString(date)
        
        if isEditDeck {
            deck.name = deckTitleTextField.text ?? ""
            self.delegate?.didEndEdit(deck: deck)
            
            myDeleteFunction(childIWantToRemove: self.nameDeckOld)
            for (indexEdit,legEdit) in deck.cards.enumerated() {
                ref.child(UID).child(deckTitleTextField.text!).child("cards").child("card\(indexEdit)").setValue(["term":legEdit.term , "defination":legEdit.definition, "mark":legEdit.marked])
            }
            ref.child(UID).child(deckTitleTextField.text!).child("last activity").setValue(dateconvert)
        }
        else {
            
            
            let id = "\(decks.count + 1)"
            deck.folderID = "1"
            deck.identifier = id
            deck.name = deckTitleTextField.text ?? ""
            decks.append(deck)
            //push data lên firebase
            for (index,leg) in deck.cards.enumerated() {
                ref.child(UID).child(deckTitleTextField.text!).child("cards").child("card\(index)").setValue(["term":leg.term , "defination":leg.definition, "mark":false])
                
            }
            ref.child(UID).child(deckTitleTextField.text!).child("last activity").setValue(dateconvert)
        }
        _ = navigationController?.popViewController(animated: true)
    }

    func convertDateToString(_ date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    @IBAction func addCardButtonTapped(_ sender: AnyObject) {
        deck.cards.append(Card())
        tableView.reloadData()
        
        let indexPath = IndexPath(row: deck.cards.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        accessoryTermCountItem.title =
        "\(deck.cards.count) terms"
        
        let cell = tableView.cellForRow(at: indexPath) as! DeckDetailAddEditTableViewCell
        cell.termTextField.becomeFirstResponder()
    }
    
    
    @IBAction func moveToNextFristResponse(_ sender: Any) {
        if (firstResponderTextField == firstResponderCell?.termTextField) {
            firstResponderCell?.giaiNghiaTextField.becomeFirstResponder()
        }
        else {
            if let currentCell = firstResponderCell,
                let index = tableView.indexPath(for: currentCell)?.row {
                if index == deck.cards.count - 1 {
                    // the firstResponder is last cell, so add new cell
                }
                else {
                    let nextIndexPath = IndexPath(row: index + 1, section: 0)
                    let nextCell = tableView.cellForRow(at: nextIndexPath) as! DeckDetailAddEditTableViewCell
                    nextCell.termTextField.becomeFirstResponder()
                    
                    let offset = tableView.contentOffset
                    tableView.contentOffset = CGPoint(x: offset.x, y: offset.y + 100)
                }
            }
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

    // MARK: Notification
    func keyboardWillShow(notification: NSNotification) {
        if !deckTitleTextField.isFirstResponder {
//            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//                if self.view.frame.origin.y == 0{
//                    self.view.frame.origin.y -= keyboardSize.height
//                }
//            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if !deckTitleTextField.isFirstResponder {
//            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//                if self.view.frame.origin.y != 0{
//                    self.view.frame.origin.y += keyboardSize.height
//                }
//            }
        }
    }
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
        cell.editDelegate = self
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
    
    func cell(_ cell: DeckDetailAddEditTableViewCell, textFieldDidBecomeFirstResponder textFrield: UITextField) {
        firstResponderCell = cell
        firstResponderTextField = textFrield
        imagePickerButton.isEnabled = cell.giaiNghiaTextField == textFrield ? true : false

    }
}

extension DeckDetailAddEditViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        //let card = deck.cards[indexPath.row]
        
        if orientation == .left {
            // Làm edit
            return nil
        }
        else {
            let deleteAction = SwipeAction(style: .destructive, title: nil, handler: { (action, indexPath) in
                self.deck.cards.remove(at: indexPath.row)
                self.delegate?.didEndEdit(deck: self.deck)
            })
            
            deleteAction.hidesWhenSelected = true
            deleteAction.title = "Delete"
            deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.2655673325, blue: 0.3893191218, alpha: 1)
            return [deleteAction]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        options.buttonSpacing = 10
        
        return options
    }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title()
        action.image = descriptor.image()
        action.backgroundColor = descriptor.color
    }
}

