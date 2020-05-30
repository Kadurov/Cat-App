//
//  DescriptiomCell.swift
//  macpaw-cat-app
//
//  Created by Kadir Kadyrov on 18.05.2020.
//  Copyright © 2020 Kadir Kadyrov. All rights reserved.
//

import UIKit

class DescriptiomCell: UITableViewCell {
    @IBOutlet weak var nameOfDescriprion: UILabel!
    @IBOutlet weak var level: UILabel!
    
    
    func getLevelMain (level: Int) -> String {
        switch level {
        case 1...2:
            return "Low"
        case 3:
            return "Medium"
        case 4...5:
            return "High"
        default:
            return "None"
        }
    }
    
    func getLevelYesNo (level: Int) -> String {
        switch level {
        case 1:
            return "Yes"
        case 0:
            return "No"
        default:
            return "None"
        }
    }
    
    func updateCell (name: String, level: Int, typeOfCell type: DescriptionCellType) {
        nameOfDescriprion.text = name
        //print(self.level.text)
        if(type == .descriptionMain) {
            self.level.text = getLevelMain(level: level)
        } else {
            self.level.text = getLevelYesNo(level: level)
        }
    }

}
