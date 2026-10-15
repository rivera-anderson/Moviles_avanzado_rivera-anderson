//
//  LugarTableViewCell.swift
//  PeruVibe
//
//  Created by Tecsup on 15/10/26.
//

import UIKit

class LugarTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nombreLugarLabel: UILabel!
    
    @IBOutlet weak var imagenLugarImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
