import UIKit

/// Cuenta: nombre, usuario, rol y Cerrar sesión (ambos roles)
final class CuentaViewController: UITableViewController {
    private enum Seccion: Int, CaseIterable { case datos, sesion }

    private var usuario: Usuario? { Sesion.shared.usuario }

    /// Se crea desde Main.storyboard
    required init?(coder: NSCoder) { super.init(coder: coder) }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cuenta"
        navigationItem.largeTitleDisplayMode = .never
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "celda")
        tableView.tableHeaderView = cabecera()
    }

    private func cabecera() -> UIView {
        let nombre = usuario?.nombreMostrado ?? ""
        let avatar = InicialesView(tamano: 84)
        avatar.mostrar(nombre)
        let etiquetaNombre = UILabel()
        etiquetaNombre.text = nombre
        etiquetaNombre.font = .systemFont(ofSize: 22, weight: .bold)
        let rol = InsigniaLabel()
        rol.mostrar(usuario?.rol, color: usuario?.esSupervisor == true ? .systemPurple : .marca)

        let pila = UIStackView(vertical: [avatar, etiquetaNombre, rol], espaciado: 8, alineacion: .center)
        pila.translatesAutoresizingMaskIntoConstraints = false
        let contenedor = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 180))
        contenedor.addSubview(pila)
        NSLayoutConstraint.activate([
            pila.centerXAnchor.constraint(equalTo: contenedor.centerXAnchor),
            pila.centerYAnchor.constraint(equalTo: contenedor.centerYAnchor)
        ])
        return contenedor
    }

    override func numberOfSections(in tableView: UITableView) -> Int { Seccion.allCases.count }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Seccion(rawValue: section) == .datos ? 3 : 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        if Seccion(rawValue: indexPath.section) == .datos {
            var contenido = UIListContentConfiguration.valueCell()
            let filas: [(String, String, String)] = [
                ("Nombre", usuario?.nombreMostrado ?? "", "person"),
                ("Usuario", "@\(usuario?.usuario ?? "")", "at"),
                ("Rol", usuario?.rol ?? "", "briefcase")
            ]
            let fila = filas[indexPath.row]
            contenido.text = fila.0
            contenido.secondaryText = fila.1
            contenido.image = UIImage(systemName: fila.2)
            contenido.imageProperties.tintColor = .marca
            celda.contentConfiguration = contenido
            celda.selectionStyle = .none
        } else {
            var contenido = UIListContentConfiguration.cell()
            contenido.text = "Cerrar sesión"
            contenido.textProperties.color = .systemRed
            contenido.textProperties.font = .systemFont(ofSize: 17, weight: .semibold)
            contenido.image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
            contenido.imageProperties.tintColor = .systemRed
            celda.contentConfiguration = contenido
            celda.selectionStyle = .default
        }
        return celda
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        Seccion(rawValue: section) == .sesion ? "Al cerrar sesión vuelves a la pantalla de inicio de sesión." : nil
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard Seccion(rawValue: indexPath.section) == .sesion else { return }
        let alerta = UIAlertController(title: "¿Cerrar sesión?", message: nil, preferredStyle: .actionSheet)
        alerta.addAction(UIAlertAction(title: "Cerrar sesión", style: .destructive) { _ in
            Sesion.shared.cerrar() // usuario = nil → la app vuelve al login
        })
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)
        present(alerta, animated: true)
    }
}
