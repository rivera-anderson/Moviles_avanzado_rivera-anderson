import UIKit

/// Todas las pantallas viven en Main.storyboard. Aquí se instancian por su Storyboard ID.
enum Pantallas {
    static let storyboard = UIStoryboard(name: "Main", bundle: nil)

    /// Navegación con el login (A1) y el segue a Crear cuenta (A2)
    static func acceso() -> UIViewController {
        storyboard.instantiateViewController(withIdentifier: "Acceso")
    }

    /// UITabBarController del rol: Supervisor o Vendedor
    static func pestanas(para usuario: Usuario) -> UIViewController {
        storyboard.instantiateViewController(withIdentifier: usuario.esSupervisor ? "TabsSupervisor" : "TabsVendedor")
    }

    /// Las siguientes escenas reciben datos, por eso usan init(coder:dato:)
    static func productoForm(_ producto: Producto?) -> UIViewController {
        storyboard.instantiateViewController(identifier: "ProductoForm") { coder in
            ProductoFormViewController(coder: coder, producto: producto)
        }
    }

    static func clienteForm(_ cliente: Cliente?) -> UIViewController {
        storyboard.instantiateViewController(identifier: "ClienteForm") { coder in
            ClienteFormViewController(coder: coder, cliente: cliente)
        }
    }

    static func seleccion(titulo: String, opciones: [SeleccionViewController.Opcion], vacio: String,
                          alElegir: @escaping (Int) -> Void) -> UIViewController {
        storyboard.instantiateViewController(identifier: "Seleccion") { coder in
            SeleccionViewController(coder: coder, titulo: titulo, opciones: opciones, vacio: vacio, alElegir: alElegir)
        }
    }
}
