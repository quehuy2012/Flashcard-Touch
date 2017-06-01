//
//  DeckDetailAddEditTableViewCell.swift
//  Flashcard Touch
//
//  Created by TuanAnhVu on 5/2/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

import UIKit

protocol DeckDetailAddEditTableViewCellDelegate: class {
    func cell(_ cell:DeckDetailAddEditTableViewCell, didEndEdit term: String, definition: String)
}

class DeckDetailAddEditTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    weak var delegate:DeckDetailAddEditTableViewCellDelegate?

    @IBOutlet weak var termTextField: UITextField!
    @IBOutlet weak var giaiNghiaTextField: UITextField!
    @IBOutlet weak var borderView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        termTextField.delegate = self
        giaiNghiaTextField.delegate = self
        
        borderView.layer.cornerRadius = 5.0
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.darkGray.cgColor
        
        let f = contentView.frame
        let fr = UIEdgeInsetsInsetRect(f, UIEdgeInsetsMake(10, 10, 0, 10))
        contentView.frame = fr
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.cell(self, didEndEdit: termTextField.text ?? "", definition: giaiNghiaTextField.text ?? "")
    }
    
    @IBAction func termTextFieldTextChanged(_ sender: AnyObject) {
        delegate?.cell(self, didEndEdit: termTextField.text ?? "", definition: giaiNghiaTextField.text ?? "")
    }
    
    @IBAction func definitionTextFieldTextChanged(_ sender: AnyObject) {
        delegate?.cell(self, didEndEdit: termTextField.text ?? "", definition: giaiNghiaTextField.text ?? "")
    }
}
