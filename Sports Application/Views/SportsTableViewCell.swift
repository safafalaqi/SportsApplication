//
//  SportsTableViewCell.swift
//  Sports Application
//
//  Created by Safa Falaqi on 27/12/2021.
//

import UIKit

class SportsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageBt: UIButton!
    @IBOutlet weak var sportLabel: UILabel!
    var delegate : ImagePickerPressedDelegate?
    var indexPath:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    @IBAction func imagePressed(_ sender: UIButton) {
        
        delegate?.addImage(indexPath: indexPath!)
    }
}


