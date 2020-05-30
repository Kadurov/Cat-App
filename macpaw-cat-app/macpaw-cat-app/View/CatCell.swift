//
//  CatCell.swift
//  macpaw-cat-app
//
//  Created by Kadir Kadyrov on 17.05.2020.
//  Copyright © 2020 Kadir Kadyrov. All rights reserved.
//

import UIKit


class CatCell: UITableViewCell {

    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        cellView.layer.borderWidth = 1.5
        cellView.layer.borderColor = #colorLiteral(red: 0.3992092311, green: 0.3836411536, blue: 0.2096695304, alpha: 1)
        cellView.layer.cornerRadius = 5
    }
    
    func updateCell (nameOfCat name: String, image: UIImage) {
        
        self.catName.text = name
        self.catImage.image = image
    }
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
