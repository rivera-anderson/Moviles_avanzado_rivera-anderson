//
//  DetalleViewController.swift
//  PeruVibe
//
//  Created by Tecsup on 13/10/26.
//

import UIKit

class DetalleViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nombreLabel: UILabel!
    
    @IBOutlet weak var regionLabel: UILabel!
    
    
    @IBOutlet weak var descripcionLabel: UILabel!
    // Variable para recibir los datos transmitidos
        var cultura: Cultura?

        override func viewDidLoad() {
            super.viewDidLoad()
            
            if let cultura = cultura {
                title = cultura.nombre
                nombreLabel.text = cultura.nombre
                regionLabel.text = "\(cultura.region)"
                descripcionLabel.text = cultura.descripcion
                imageView.image = UIImage(named: cultura.imagenNombre)
            }
        }
   

}
