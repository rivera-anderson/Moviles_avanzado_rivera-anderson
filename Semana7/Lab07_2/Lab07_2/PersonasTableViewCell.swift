//
//  PersonasTableViewCell.swift
//  Lab07_2
//
//  Created by Tecsup on 13/10/26.
//

import UIKit

class PersonasTableViewCell: UITableViewCell {

    
    @IBOutlet weak var PersonaNombre: UILabel!
    @IBOutlet weak var PersonaImagen: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
