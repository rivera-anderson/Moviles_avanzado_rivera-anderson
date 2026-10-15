//
//  ViewController.swift
//  PeruVibe
//
//  Created by Tecsup on 13/10/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!
    
    var culturas: [Cultura] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Culturas Peruanas"
        
        cargarDatos()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func cargarDatos() {
        let caral = Cultura(
            nombre: "Caral",
            region: "Lima",
            imagenNombre: "caral",
            lugares: [
                Lugar(
                    nombre: "Ciudad Sagrada de Caral",
                    region: "Supe, Lima",
                    descripcion: "La civilización más antigua de América, destacan sus pirámides y plazas circulares.",
                    imagenNombre: "caral_ciudad"
                )
            ]
        )
        
        let chavin = Cultura(
            nombre: "Chavín",
            region: "Áncash",
            imagenNombre: "chavin",
            lugares: [
                Lugar(
                    nombre: "Monumento Arqueológico Chavín de Huántar",
                    region: "Huari, Áncash",
                    descripcion: "Centro ceremonial con galerías subterráneas, el Lanzón Monolítico y las Cabezas Clavas.",
                    imagenNombre: "chavin_huantar"
                )
            ]
        )
        
        let mochica = Cultura(
            nombre: "Mochica",
            region: "La Libertad",
            imagenNombre: "mochica",
            lugares: [
                Lugar(
                    nombre: "Huaca del Sol y de la Luna",
                    region: "Trujillo, La Libertad",
                    descripcion: "Santuario Moche decorado con impresionantes murales polícromos.",
                    imagenNombre: "huaca_luna"
                ),
                Lugar(
                    nombre: "Ciudadela de Chan Chan",
                    region: "Trujillo, La Libertad",
                    descripcion: "La ciudad de barro más grande de América precolombina.",
                    imagenNombre: "chan_chan"
                )
            ]
        )
        
        culturas = [caral, chavin, mochica]
    }

    // MARK: - UITableViewDataSource & Delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return culturas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CulturaTableViewCell else {
            return UITableViewCell()
        }
        
        let cultura = culturas[indexPath.row]
        
        // Asignación sin regionLabel
        cell.nombreLabel.text = cultura.nombre
        cell.imagenCulturaImageView.image = UIImage(named: cultura.imagenNombre)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let culturaSeleccionada = culturas[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let lugaresVC = storyboard.instantiateViewController(withIdentifier: "LugaresViewController") as? LugaresViewController {
            lugaresVC.cultura = culturaSeleccionada
            navigationController?.pushViewController(lugaresVC, animated: true)
        }
    }
}
