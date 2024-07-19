//
//  DeckDetailAddEditTableViewCell.swift
//  Flashcard Touch
//
//  Created by TuanAnhVu on 5/2/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

import UIKit
import SwipeCellKit

protocol DeckDetailAddEditTableViewCellDelegate: class {
    func cell(_ cell:DeckDetailAddEditTableViewCell, didEndEdit term: String, definition: String)
    func cell(_ cell:DeckDetailAddEditTableViewCell, textFieldDidBecomeFirstResponder textFrield:UITextField)
}

class DeckDetailAddEditTableViewCell: SwipeTableViewCell, UITextFieldDelegate {
    
    weak var editDelegate:DeckDetailAddEditTableViewCellDelegate?

    @IBOutlet weak var termTextField: UITextField!
    @IBOutlet weak var giaiNghiaTextField: UITextField!
    @IBOutlet weak var borderView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        termTextField.delegate = self
        giaiNghiaTextField.delegate = self
        
        borderView.layer.cornerRadius = 5.0
        borderView.layer.borderWidth = 0
        borderView.layer.borderColor = UIColor.darkGray.cgColor
        
        let shadowFrame = borderView.layer.bounds;
        let shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: 5.0)
        borderView.layer.shadowPath = shadowPath.cgPath;
        borderView.layer.shadowOpacity = 0.25;
        borderView.layer.shadowColor = #colorLiteral(red: 0.6071627736, green: 0.6042224169, blue: 0.6251516938, alpha: 1).cgColor
        
        let f = contentView.frame
        let fr = UIEdgeInsetsInsetRect(f, UIEdgeInsetsMake(10, 10, 0, 10))
        contentView.frame = fr
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editDelegate?.cell(self, textFieldDidBecomeFirstResponder: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editDelegate?.cell(self, didEndEdit: termTextField.text ?? "", definition: giaiNghiaTextField.text ?? "")
    }
    
    @IBAction func termTextFieldTextChanged(_ sender: AnyObject) {
        editDelegate?.cell(self, didEndEdit: termTextField.text ?? "", definition: giaiNghiaTextField.text ?? "")
    }
    
    @IBAction func definitionTextFieldTextChanged(_ sender: AnyObject) {
        editDelegate?.cell(self, didEndEdit: termTextField.text ?? "", definition: giaiNghiaTextField.text ?? "")
    }
}


