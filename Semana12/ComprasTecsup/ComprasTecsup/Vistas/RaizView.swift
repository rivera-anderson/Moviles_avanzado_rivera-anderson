import SwiftUI
import SwiftData

/// Pantalla inicial: si hay usuario en la sesión muestra las pestañas; si no, el login.
/// Al cerrar sesión (usuario = nil) la vista cambia sola al login.
struct RaizView: View {
    @Environment(Sesion.self) private var sesion

    var body: some View {
        Group {
            if let usuario = sesion.usuario {
                PrincipalView(usuario: usuario)
            } else {
                LoginView()
            }
        }
        .animation(.default, value: sesion.usuario == nil)
    }
}

/// TabView cuyas pestañas dependen del rol del usuario conectado
struct PrincipalView: View {
    let usuario: Usuario

    var body: some View {
        TabView {
            if usuario.esSupervisor {
                // Supervisor: Resumen, Aprobar, Por pagar, Productos, Proveedores
                NavigationStack { ResumenView() }
                    .tabItem { Label("Resumen", systemImage: "chart.bar.fill") }
                NavigationStack { AprobarView() }
                    .tabItem { Label("Aprobar", systemImage: "checkmark.seal.fill") }
                NavigationStack { PorPagarView() }
                    .tabItem { Label("Por pagar", systemImage: "creditcard.fill") }
                NavigationStack { ProductosView() }
                    .tabItem { Label("Productos", systemImage: "shippingbox.fill") }
                NavigationStack { ProveedoresView() }
                    .tabItem { Label("Proveedores", systemImage: "building.2.fill") }
            } else {
                // Comprador: Productos, Proveedores, Compra, Mis compras
                NavigationStack { ProductosView() }
                    .tabItem { Label("Productos", systemImage: "shippingbox.fill") }
                NavigationStack { ProveedoresView() }
                    .tabItem { Label("Proveedores", systemImage: "building.2.fill") }
                NavigationStack { NuevaCompraView() }
                    .tabItem { Label("Compra", systemImage: "cart.fill.badge.plus") }
                NavigationStack { MisComprasView() }
                    .tabItem { Label("Mis compras", systemImage: "list.bullet.rectangle.fill") }
            }
        }
    }
}
