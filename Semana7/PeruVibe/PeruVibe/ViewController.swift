//
//  ViewController.swift
//  PeruVibe
//
//  Created by Tecsup on 13/10/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!
    // Lista de culturas peruanas con datos
    let culturas: [Cultura] = [
        Cultura(nombre: "Caral", region: "Lima", descripcion: "La civilización más antigua de América.", imagenNombre: "caral"),
        Cultura(nombre: "Chavín", region: "Áncash", descripcion: "Famosa por sus cabezas clavas y el Lanzón Monolítico.", imagenNombre: "chavin"),
        Cultura(nombre: "Mochica", region: "La Libertad", descripcion: "Conocidos por su cerámica escultórica y los huacos retratos.", imagenNombre: "mochica")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Culturas Peruanas"
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - Métodos de UITableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return culturas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        let cultura = culturas[indexPath.row]
        cell.textLabel?.text = cultura.nombre
        cell.detailTextLabel?.text = cultura.region
        cell.imageView?.image = UIImage(named: cultura.imagenNombre)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }

    // NAVEGACIÓN Y PASO DE DATOS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let culturaSeleccionada = culturas[indexPath.row]
        
        // Cargar el View Controller de Detalle desde el Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detalleVC = storyboard.instantiateViewController(withIdentifier: "DetalleViewController") as? DetalleViewController {
            detalleVC.cultura = culturaSeleccionada
            
            // Empujar la vista al NavigationController
            navigationController?.pushViewController(detalleVC, animated: true)
        }
    }
}

