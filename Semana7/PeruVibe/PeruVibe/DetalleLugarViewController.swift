//
//  DetalleLugarViewController.swift
//  PeruVibe
//
//  Created by Tecsup on 15/10/26.
//

import UIKit

class DetalleLugarViewController: UIViewController {


    @IBOutlet weak var imagenGrandeImageView: UIImageView!
    
    @IBOutlet weak var regionLabel: UILabel!
    
    @IBOutlet weak var descripcionLabel: UILabel!
    var lugar: Lugar?

        override func viewDidLoad() {
            super.viewDidLoad()
            
            if let lugar = lugar {
                title = lugar.nombre
    
                
                // Asignación directa para evitar que diga "Ubicación:" dos veces
                regionLabel.text = lugar.region
                
                // Permite saltos de línea automáticos por código
                descripcionLabel.numberOfLines = 0
                descripcionLabel.text = lugar.descripcion
                
                imagenGrandeImageView.image = UIImage(named: lugar.imagenNombre)
                imagenGrandeImageView.contentMode = .scaleAspectFill
                imagenGrandeImageView.clipsToBounds = true
            }
        }
}
