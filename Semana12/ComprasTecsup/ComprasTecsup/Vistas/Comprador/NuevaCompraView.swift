import SwiftUI
import SwiftData
import Foundation

/// B5 · Nueva compra (solo comprador)
struct NuevaCompraView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion

    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]
    @Query(sort: \Producto.nombre) private var productos: [Producto]

    @State private var proveedor: Proveedor?
    @State private var producto: Producto?
    @State private var cantidadTexto = ""
    @State private var costoTexto = ""
    @State private var alCredito = false
    @State private var fecha = Date()

    @State private var mostrarAviso = false
    @State private var tituloAviso = ""
    @State private var mensajeAviso = ""

    // MARK: - Resumen calculado (no se guarda hasta registrar)

    private var cantidad: Int { Int(cantidadTexto.limpio) ?? 0 }
    private var costoUnitario: Double {
        Double(costoTexto.limpio.replacingOccurrences(of: ",", with: ".")) ?? 0
    }
    private var subtotal: Double { ReglasCompra.subtotal(cantidad: cantidad, costoUnitario: costoUnitario) }
    private var igv: Double { ReglasCompra.igv(de: subtotal) }
    private var total: Double { ReglasCompra.redondear(subtotal + igv) }
    private var requiereAprobacion: Bool { ReglasCompra.requiereAprobacion(total: total) }
    private var esValida: Bool { proveedor != nil && producto != nil && cantidad > 0 && costoUnitario > 0 }

    var body: some View {
        Form {
            Section {
                // ② Proveedor
                Picker("Proveedor", selection: $proveedor) {
                    Text("Selecciona").tag(Optional<Proveedor>.none)
                    ForEach(proveedores) { item in
                        Text(item.nombre).tag(Optional(item))
                    }
                }
                // ③ Producto
                Picker("Producto", selection: $producto) {
                    Text("Selecciona").tag(Optional<Producto>.none)
                    ForEach(productos) { item in
                        Text(item.nombre).tag(Optional(item))
                    }
                }
                // ④ Cantidad
                HStack {
                    Text("Cantidad")
                    Spacer()
                    TextField("0", text: $cantidadTexto)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 120)
                }
                HStack {
                    Text("Costo unitario")
                    Spacer()
                    TextField("0.00", text: $costoTexto)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 120)
                }
                DatePicker("Fecha", selection: $fecha, in: ...Date(), displayedComponents: .date)
            } footer: {
                if let producto {
                    Text("Stock actual: \(producto.stock) u. · costo promedio \(Formato.soles(producto.costoPromedio))")
                }
            }
            .pickerStyle(.navigationLink)

            Section {
                // ⑤ Contado o Crédito 30 días
                Picker("Condición de pago", selection: $alCredito) {
                    Text("Contado").tag(false)
                    Text("Crédito 30 días").tag(true)
                }
                .pickerStyle(.segmented)
                .labelsHidden()

                filaMonto("Subtotal", subtotal)
                filaMonto("IGV 18%", igv)
                filaMonto("Total", total, destacado: true)
                if alCredito {
                    filaTexto("Vence", Formato.diaMes(ReglasCompra.fechaVencimiento(desde: fecha)))
                }
            }

            // ⑥ Aviso cuando el total llega a S/ 5,000
            if requiereAprobacion {
                Section {
                    Label {
                        Text("Supera S/ 5,000: quedará **pendiente de aprobación** del supervisor. No cambia stock ni costo promedio todavía.")
                    } icon: {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(Color.ambar)
                    }
                    .font(.footnote)
                }
                .listRowBackground(Color.ambar.opacity(0.15))
            }

            // ⑦ Enviar a aprobación (si es menor, el botón dice Registrar compra)
            Section {
                Button(action: registrar) {
                    Text(requiereAprobacion ? "Enviar a aprobación" : "Registrar compra")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!esValida)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
        }
        .navigationTitle("Nueva compra")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                AvatarMenu() // ① Avatar de la sesión
            }
        }
        .alert(tituloAviso, isPresented: $mostrarAviso) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(mensajeAviso)
        }
    }

    // MARK: - Filas del resumen

    private func filaMonto(_ titulo: String, _ valor: Double, destacado: Bool = false) -> some View {
        HStack {
            Text(titulo)
            Spacer()
            Text(Formato.soles(valor))
                .foregroundStyle(destacado ? Color.primary : Color.secondary)
        }
        .fontWeight(destacado ? .bold : .regular)
    }

    private func filaTexto(_ titulo: String, _ valor: String) -> some View {
        HStack {
            Text(titulo)
            Spacer()
            Text(valor).foregroundStyle(.secondary)
        }
    }

    // MARK: - Registrar

    private func registrar() {
        guard let comprador = sesion.usuario, let proveedor, let producto, esValida else { return }
        do {
            let compra = try ServicioCompras.registrar(
                fecha: fecha,
                cantidad: cantidad,
                costoUnitario: costoUnitario,
                alCredito: alCredito,
                comprador: comprador,
                proveedor: proveedor,
                producto: producto,
                en: modelContext
            )
            if compra.estado == EstadoCompra.aprobada {
                tituloAviso = "Compra aprobada"
                let pago = compra.alCredito ? "Vence el \(Formato.diaMes(compra.vence))." : "Quedó pagada (contado)."
                mensajeAviso = "Total \(Formato.soles(compra.total)). Stock de \(producto.nombre): \(producto.stock) u. · costo promedio \(Formato.soles(producto.costoPromedio)). \(pago)"
            } else {
                tituloAviso = "Enviada a aprobación"
                mensajeAviso = "Total \(Formato.soles(compra.total)). Queda Pendiente hasta que el supervisor la apruebe; el stock no cambia todavía."
            }
            limpiarFormulario()
        } catch {
            tituloAviso = "No se pudo registrar"
            mensajeAviso = error.localizedDescription
        }
        mostrarAviso = true
    }

    private func limpiarFormulario() {
        cantidadTexto = ""
        costoTexto = ""
        alCredito = false
        fecha = Date()
    }
}
