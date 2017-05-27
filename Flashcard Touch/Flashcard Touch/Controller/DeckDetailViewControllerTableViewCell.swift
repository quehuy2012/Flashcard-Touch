//
//  DeckDetailViewControllerTableViewCell.swift
//  Flashcard Touch
//
//  Created by TuanAnhVu on 5/23/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

import UIKit

class DeckDetailViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var viewScreen: UIView!
    @IBOutlet weak var definition: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        viewScreen.layer.cornerRadius = 15
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let f = contentView.frame
        let fr = UIEdgeInsetsInsetRect(f, UIEdgeInsetsMake(10, 10, 10, 10))
        contentView.frame = fr
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
