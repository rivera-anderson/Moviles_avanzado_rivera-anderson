//
//  LugaresViewController.swift
//  PeruVibe
//
//  Created by Tecsup on 15/10/26.
//

import UIKit



class LugaresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var cultura: Cultura?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = cultura?.nombre ?? "Lugares Turísticos"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 90
    }

    // MARK: - UITableViewDataSource & Delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cultura?.lugares.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "lugarCell", for: indexPath) as? LugarTableViewCell else {
            return UITableViewCell()
        }
        
        if let lugar = cultura?.lugares[indexPath.row] {
            cell.nombreLugarLabel.text = lugar.nombre
            cell.imagenLugarImageView.image = UIImage(named: lugar.imagenNombre)
            
            // Ajuste para que la imagen de la lista no se deforme
            cell.imagenLugarImageView.contentMode = .scaleAspectFill
            cell.imagenLugarImageView.clipsToBounds = true
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let lugarSeleccionado = cultura?.lugares[indexPath.row] {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let detalleVC = storyboard.instantiateViewController(withIdentifier: "DetalleLugarViewController") as? DetalleLugarViewController {
                detalleVC.lugar = lugarSeleccionado
                navigationController?.pushViewController(detalleVC, animated: true)
            }
        }
    }
}
