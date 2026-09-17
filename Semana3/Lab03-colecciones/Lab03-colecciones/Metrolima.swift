// Desarrollado por: rivera anderson
import Foundation

var tarjetasLinea: Set<String> = []

var numerosTarjeta: [String: String] = [:]

var saldosTarjeta: [String: Double] = [:]

// Tarifa del pasaje.
let tarifaPasaje: Double = 1.50
// ================================================================
// ESTADO DE ESTACIONES Y LINEAS
// ================================================================

// Guarda las estaciones que estan temporalmente deshabilitadas.
var estacionesDeshabilitadas: Set<String> = []

// Guarda las lineas que estan temporalmente deshabilitadas.
var lineasDeshabilitadas: Set<String> = []

// 1. DICCIONARIOS DE DATOS
var redMetro: [String: [String]] = [
    "L1": ["Bayobar", "Santa Rosa", "San Martin", "San Carlos", "Los Postes", "Los Jardines", "Piramides del Sol", "Caja de Agua", "Presbitero Maestro", "El Angel", "Grau", "28 de Julio", "N. Arriola", "La Cultura", "S. Borja Sur", "Angamos", "Cabitos", "Jorge Chavez", "Atocongo", "San Juan", "Maria Auxiliadora", "Villa Maria", "Pumacahua", "Parque Industrial", "Villa El Salvador"],
    "L2": ["Puerto del Callao", "Buenos Aires", "Juan Pablo II", "Insurgentes", "Carmen de la Legua", "Oscar R. Benavides", "UNMSM", "Elio", "La Alborada", "Tingo Maria", "Pza. Murillo", "Pza. Bolognesi", "Est. Central", "P. Manco Capac", "Cangallo", "28 de Julio", "N. Ayllon", "Circunvalacion", "San Juan de Dios", "Evitamiento", "Ov. Santa Anita", "Colectora Industrial", "Los Ingenieros", "Mercado Santa Anita", "Vista Alegre", "Prolongacion Javier Prado", "Municipalidad de Ate"],
    "L3": ["Chimpu Ocllo", "San Felipe", "Los Incas", "Sinchi Roca", "Victor Andres Belaunde", "Santa Luzmila", "Las Palmeras", "Carlos Izaguirre", "Megaplaza Norte", "Plaza Lima Norte", "Habich", "Caqueta", "Plaza de Armas", "Est. Central", "G. Escobedo", "Salaverry", "Las Flores", "Pardo", "Cte. Espinar", "Angamos", "Benavides", "Via Expresa", "La Merced", "Rep. de Panama"],
    "L4": ["Nestor Gambetta", "Canta Callao", "Bocanegra", "Aeropuerto", "El Olivar", "Quilca", "Morales Duarez", "Carmen de la Legua", "Venezuela", "Precursores", "Faucett", "Pque. de las Leyendas", "PUCP", "Universitaria", "Sucre", "Brasil", "Salaverry", "Canevaro", "L. Prado", "Guardia Civil", "La Cultura", "Rosa Toro", "Trebol", "Ov. Monitor Huascar", "La Molina", "Los Frutales", "Ingenieros", "Estadio Monumental"],
    "L5": ["Cuartel San Martin", "Lima", "Pque. de la Media Luna", "Magdalena", "Ejercito", "Ov. de Miraflores", "Saenz Peña", "Alejandro Iglesias", "Condores", "Conchan"],
    "L6": ["Naranjal", "Los Alisos", "Los Olivos", "Santiago Antunez de Mayolo", "Angelica Gamarra", "Tomas Valle", "San German", "Jose Granda", "Peru", "Mdo. Surquillo", "Caminos del Inca", "Velasco Astete", "Primavera", "Panamericana Sur", "La Encalada", "UPC", "Ov. Monitor Huascar"],
    "BRT": ["Naranjal", "Caqueta", "Est. Central", "Cabitos", "Matellini"]
]

var avenidasMetro: [String: [String]] = [
    "L1": ["San Juan de Lurigancho", "Av. Fernando Wise", "Av. Paseo de la Independencia", "Av. Aviacion", "Av. Tomas Marsano", "Av. Pachacutec", "Separadora Industrial", "Villa El Salvador"],
    "L2": ["Callao", "Av. Guardia Civil", "Av. Colonial", "Av. Venezuela", "Av. Arica", "Av. 28 de Julio", "Av. Nicolas Ayllon", "Av. Haya de la Torre", "Ate Vitarte"],
    "L3": ["Comas", "Av. Universitaria", "Av. Tupac Amaru", "Av. Pizarro", "Av. Tacna", "Av. Arequipa", "Av. Larco", "Av. Benavides", "Santiago de Surco"],
    "L4": ["Ate Vitarte", "Av. Javier Prado", "Av. Tupac Amaru", "Av. S. Carrion", "Av. La Marina", "Av. Elmer Faucett", "Callao"],
    "L5": ["Santiago de Surco", "Av. Miguel Grau", "Av. Paseo de la Republica", "Chorrillos", "Av. Huaylas", "Villa El Salvador"],
    "L6": ["Los Olivos", "Av. Universitaria", "Av. La Paz", "Av. Angamos", "Av. Primavera", "Surco"]
]

var mapLineas = ["1": "L1", "2": "L2", "3": "L3", "4": "L4", "5": "L5", "6": "L6", "7": "BRT"]
var kmLineas = ["1": "37.00 km", "2": "27.00 km", "3": "31.50 km", "4": "26.00 km", "5": "13.90 km", "6": "30.00 km", "7": "Ruta Exclusiva"]


// 2. PANTALLA DE INICIO (SPLASH SCREEN LOGO)
print(#"""
   __  __ _____ _____ ____   ___    ____  _____   _     ___ __  __    _    
  |  \/  | ____|_   _|  _ \ / _ \  |  _ \| ____| | |   |_ _|  \/  |  / \   
  | |\/| |  _|   | | | |_) | | | | | | | |  _|   | |    | || |\/| | / _ \  
  | |  | | |___  | | |  _ <| |_| | | |_| | |___  | |___ | || |  | |/ ___ \ 
  |_|  |_|_____| |_| |_| \_\\___/  |____/|_____| |_____|___|_|  |_/_/   \_\
"""#)
print("=======================================================================")
print("                 SISTEMA INTEGRADO DE TRANSPORTE V1.0                  ")
print("=======================================================================")
print("\nPresione ENTER para iniciar el sistema...")
_ = readLine()

var salir = false


// 3. MENU PRINCIPAL Y LOGICA DE BUSQUEDA
while !salir {
    print("\n==========================================================")
    print("           PANEL DE CONTROL - METRO DE LIMA             ")
    print("==========================================================")
    print(" [ INFO DE RED VIGENTE ]")
    print(" L1: 37.00 km  |  L2: 27.00 km  |  L3: 31.50 km")
    print(" L4: 26.00 km  |  L5: 13.90 km  |  L6: 30.00 km")
    print("----------------------------------------------------------")
    print(" [ OPCIONES DEL SISTEMA ]")
    print(" 1) Ver estaciones de una linea")
    print(" 2) Buscar estacion en la red")
    print(" 3) Consultar cruces / transbordos")
    print(" 4) Ver distritos y avenidas de linea")
    print(" 5) Planificar viaje / estaciones restantes")
    print(" 6) Gestionar tarjeta de transporte")
    print(" 7) Modo Administrador")
    print(" 8) Salir del sistema")
    print("==========================================================")
    print("Seleccione una opcion [1-5]: ", terminator: "")
    
    let opcion = Int(readLine() ?? "0") ?? 0
    
    switch opcion {
    case 1:
        print("\nSeleccione la linea a consultar (1-6, o 7 para BRT): ", terminator: "")
        let input = readLine() ?? ""
        if let lineaClave = mapLineas[input], let estaciones = redMetro[lineaClave] {
            let kilometros = kmLineas[input] ?? ""
            print("\n----------------------------------------")
            print(" REPORTE DE ESTACIONES: LINEA \(input) (\(kilometros))")
            print("----------------------------------------")
            for (indice, estacion) in estaciones.enumerated() {
                let num = String(indice + 1)
                let padding = String(repeating: " ", count: max(0, 3 - num.count))
                print("[\(num)\(padding)] \(estacion)")
            }
        } else {
            print("\n[ERROR] Linea no identificada.")
        }
        
    case 2:
        print("\nIngrese la estacion a buscar: ", terminator: "")
        let buscar = readLine() ?? ""
        var lineasEncontradas: [String] = []
        for (nombreLinea, estaciones) in redMetro {
            for est in estaciones {
                if est.lowercased() == buscar.lowercased() {
                    if !lineasEncontradas.contains(nombreLinea) { lineasEncontradas.append(nombreLinea) }
                }
            }
        }
        print("\n----------------------------------------\n RESULTADO DE BUSQUEDA\n----------------------------------------")
        print("Estacion consultada : \(buscar)")
        if lineasEncontradas.count > 0 {
            print("Lineas disponibles  : \(lineasEncontradas.joined(separator: " - "))\nEstado              : OPERATIVO")
        } else {
            print("Estado              : NO ENCONTRADA")
        }


          case 3:
        print("\nSeleccione la PRIMERA linea (1-6): ", terminator: "")
        let input1 = readLine() ?? ""
        print("Seleccione la SEGUNDA linea (1-6): ", terminator: "")
        let input2 = readLine() ?? ""
        
        if let key1 = mapLineas[input1], let key2 = mapLineas[input2],
           let array1 = redMetro[key1], let array2 = redMetro[key2] {
            
            let set1 = Set(array1)
            let set2 = Set(array2)
            let cruces = set1.intersection(set2)
            
            print("\n----------------------------------------\n REPORTE DE TRANSBORDOS\n----------------------------------------")
            print("Linea origen  : Linea \(input1)\nLinea destino : Linea \(input2)")
            
            if cruces.isEmpty {
                print("Conexion      : SIN CONEXION DIRECTA")
            } else {
                print("Conexion      : DISPONIBLE\nPunto(s)      : \(cruces.joined(separator: ", "))")
            }
        } else {
            print("\n[ERROR] Datos de linea invalidos.")
        }
        
    case 4:
        print("\nSeleccione la linea a consultar avenidas (1-6): ", terminator: "")
        let input = readLine() ?? ""
        
        if let key = mapLineas[input], let avenidas = avenidasMetro[key] {
            print("\n+-------+---------------------------------------------+")
            print("| ORDEN | DISTRITO / AVENIDA (LINEA \(input))                  |")
            print("+-------+---------------------------------------------+")
            
            for (index, avenida) in avenidas.enumerated() {
                let numStr = String(index + 1)
                let paddingNum = String(repeating: " ", count: max(0, 5 - numStr.count))
                let paddingAv = String(repeating: " ", count: max(0, 43 - avenida.count))
                print("| \(numStr)\(paddingNum) | \(avenida)\(paddingAv) |")
            }
            print("+-------+---------------------------------------------+")
        } else {
            print("\n[ERROR] Linea no identificada en el sistema de avenidas.")
        }
    case 5:

        // Función auxiliar para formatear celdas de tabla en la consola
        func celda(_ texto: String, ancho: Int) -> String {
            if texto.count >= ancho {
                return String(texto.prefix(ancho))
            }
            return texto + String(repeating: " ", count: ancho - texto.count)
        }

        print("""

        ┌──────────────────────────────────────────────────────────┐
        │                     PLANIFICAR VIAJE                     │
        └──────────────────────────────────────────────────────────┘
        """)

        // ------------------------------------------------------
        // SELECCIONAR LINEA DE ORIGEN
        // ------------------------------------------------------

        print("➜ Seleccione la LÍNEA DE ORIGEN (1-6): ", terminator: "")
        let lineaOrigenInput = readLine() ?? ""

        if let lineaOrigen = mapLineas[lineaOrigenInput],
           let estacionesOrigen = redMetro[lineaOrigen] {

            print("\n┌──────┬───────────────────────────────────────────────────┐")
            print("│  #   │ ESTACIONES DE LA LÍNEA \(celda(lineaOrigenInput, ancho: 26))│")
            print("├──────┼───────────────────────────────────────────────────┤")

            for (indice, estacion) in estacionesOrigen.enumerated() {
                let num = celda("\(indice + 1)", ancho: 4)
                let nom = celda(estacion, ancho: 49)
                print("│ \(num) │ \(nom) │")
            }
            print("└──────┴───────────────────────────────────────────────────┘")

            // --------------------------------------------------
            // SELECCIONAR ESTACION DE ORIGEN
            // --------------------------------------------------

            print("\n➜ Seleccione el número de su estación actual: ", terminator: "")
            let estacionOrigenInput = Int(readLine() ?? "0") ?? 0

            if estacionOrigenInput >= 1 && estacionOrigenInput <= estacionesOrigen.count {

                let origen = estacionesOrigen[estacionOrigenInput - 1]
                print("\n  [✓] Estación actual: \(origen)")

                // --------------------------------------------------
                // SELECCIONAR LINEA DE DESTINO
                // --------------------------------------------------

                print("\n➜ Seleccione la LÍNEA DE DESTINO (1-6): ", terminator: "")
                let lineaDestinoInput = readLine() ?? ""

                if let lineaDestino = mapLineas[lineaDestinoInput],
                   let estacionesDestino = redMetro[lineaDestino] {

                    print("\n┌──────┬───────────────────────────────────────────────────┐")
                    print("│  #   │ ESTACIONES DE LA LÍNEA \(celda(lineaDestinoInput, ancho: 26))│")
                    print("├──────┼───────────────────────────────────────────────────┤")

                    for (indice, estacion) in estacionesDestino.enumerated() {
                        let num = celda("\(indice + 1)", ancho: 4)
                        let nom = celda(estacion, ancho: 49)
                        print("│ \(num) │ \(nom) │")
                    }
                    print("└──────┴───────────────────────────────────────────────────┘")

                    // --------------------------------------------------
                    // SELECCIONAR ESTACION DE DESTINO
                    // --------------------------------------------------

                    print("\n➜ Seleccione el número de su destino: ", terminator: "")
                    let estacionDestinoInput = Int(readLine() ?? "0") ?? 0

                    if estacionDestinoInput >= 1 && estacionDestinoInput <= estacionesDestino.count {

                        let destino = estacionesDestino[estacionDestinoInput - 1]
                        print("\n  [✓] Destino seleccionado: \(destino)")

                        // ==================================================
                        // RUTA DIRECTA
                        // ==================================================

                        if lineaOrigen == lineaDestino {

                            let cantidadEstaciones = abs(estacionDestinoInput - estacionOrigenInput)

                            print("\n┌──────────────────────────────────────────────────────────┐")
                            print("│                        RUTA DIRECTA                      │")
                            print("├──────────────────────────────┬───────────────────────────┤")
                            print("│ Línea                        │ \(celda(lineaOrigenInput, ancho: 25)) │")
                            print("│ Estación Origen              │ \(celda(origen, ancho: 25)) │")
                            print("│ Estación Destino             │ \(celda(destino, ancho: 25)) │")
                            print("│ Estaciones Faltantes         │ \(celda("\(cantidadEstaciones)", ancho: 25)) │")
                            print("└──────────────────────────────┴───────────────────────────┘")

                            if cantidadEstaciones == 0 {
                                print("\n  [!] Estado: YA SE ENCUENTRA EN EL DESTINO.")
                            } else {
                                print("\n┌──────────────────────────────────────────────────────────┐")
                                print("│ RECORRIDO DE LA RUTA                                     │")
                                print("├──────┬───────────────────────────────────────────────────┤")

                                if estacionDestinoInput > estacionOrigenInput {
                                    for i in estacionOrigenInput..<estacionDestinoInput {
                                        let num = celda("\(i + 1)", ancho: 4)
                                        let nom = celda(estacionesOrigen[i], ancho: 49)
                                        print("│ \(num) │ \(nom) │")
                                    }
                                } else {
                                    for i in stride(from: estacionOrigenInput - 2, through: estacionDestinoInput - 1, by: -1) {
                                        let num = celda("\(i + 1)", ancho: 4)
                                        let nom = celda(estacionesOrigen[i], ancho: 49)
                                        print("│ \(num) │ \(nom) │")
                                    }
                                }
                                print("└──────┴───────────────────────────────────────────────────┘")
                            }

                        } else {

                            // ==================================================
                            // RUTA CON TRANSBORDO
                            // ==================================================

                            let conjuntoOrigen = Set(estacionesOrigen)
                            let conjuntoDestino = Set(estacionesDestino)
                            let cruces = conjuntoOrigen.intersection(conjuntoDestino)

                            if cruces.isEmpty {

                                print("""

                                ┌──────────────────────────────────────────────────────────┐
                                │ [ERROR] NO EXISTE CONEXIÓN DIRECTA ENTRE ESTAS LÍNEAS.   │
                                └──────────────────────────────────────────────────────────┘
                                """)

                            } else {

                                let transbordo = cruces.first!

                                if let posicionTransbordoOrigen = estacionesOrigen.firstIndex(of: transbordo),
                                   let posicionTransbordoDestino = estacionesDestino.firstIndex(of: transbordo) {

                                    let estacionesPrimerTramo = abs(posicionTransbordoOrigen - (estacionOrigenInput - 1))
                                    let estacionesSegundoTramo = abs((estacionDestinoInput - 1) - posicionTransbordoDestino)
                                    let totalEstaciones = estacionesPrimerTramo + estacionesSegundoTramo

                                    print("\n┌──────────────────────────────────────────────────────────┐")
                                    print("│                   RUTA CON TRANSBORDO                    │")
                                    print("├──────────────────────────────┬───────────────────────────┤")
                                    print("│ Estación Origen              │ \(celda(origen, ancho: 25)) │")
                                    print("│ Línea Origen                 │ \(celda(lineaOrigenInput, ancho: 25)) │")
                                    print("│ Punto de Transbordo          │ \(celda(transbordo, ancho: 25)) │")
                                    print("│ Línea Destino                │ \(celda(lineaDestinoInput, ancho: 25)) │")
                                    print("│ Estación Destino             │ \(celda(destino, ancho: 25)) │")
                                    print("├──────────────────────────────┼───────────────────────────┤")
                                    print("│ Estaciones Tramo 1           │ \(celda("\(estacionesPrimerTramo)", ancho: 25)) │")
                                    print("│ Estaciones Tramo 2           │ \(celda("\(estacionesSegundoTramo)", ancho: 25)) │")
                                    print("│ Total Estaciones             │ \(celda("\(totalEstaciones)", ancho: 25)) │")
                                    print("└──────────────────────────────┴───────────────────────────┘")

                                    // TRAMO 1
                                    print("\n┌──────┬───────────────────────────────────────────────────┐")
                                    print("│  #   │ TRAMO 1: LÍNEA \(celda(lineaOrigenInput, ancho: 34))│")
                                    print("├──────┼───────────────────────────────────────────────────┤")

                                    if posicionTransbordoOrigen > estacionOrigenInput - 1 {
                                        for i in estacionOrigenInput...posicionTransbordoOrigen {
                                            let num = celda("\(i + 1)", ancho: 4)
                                            let nom = celda(estacionesOrigen[i], ancho: 49)
                                            print("│ \(num) │ \(nom) │")
                                        }
                                    } else {
                                        for i in stride(from: estacionOrigenInput - 2, through: posicionTransbordoOrigen, by: -1) {
                                            let num = celda("\(i + 1)", ancho: 4)
                                            let nom = celda(estacionesOrigen[i], ancho: 49)
                                            print("│ \(num) │ \(nom) │")
                                        }
                                    }
                                    print("└──────┴───────────────────────────────────────────────────┘")

                                    // NOTIFICACIÓN DE TRANSBORDO
                                    print("\n  🔄 TRANSBORDO EN ESTACIÓN: [ \(transbordo) ]\n")

                                    // TRAMO 2
                                    print("┌──────┬───────────────────────────────────────────────────┐")
                                    print("│  #   │ TRAMO 2: LÍNEA \(celda(lineaDestinoInput, ancho: 34))│")
                                    print("├──────┼───────────────────────────────────────────────────┤")

                                    if estacionDestinoInput - 1 > posicionTransbordoDestino {
                                        for i in (posicionTransbordoDestino + 1)..<estacionDestinoInput {
                                            let num = celda("\(i + 1)", ancho: 4)
                                            let nom = celda(estacionesDestino[i], ancho: 49)
                                            print("│ \(num) │ \(nom) │")
                                        }
                                    } else if estacionDestinoInput - 1 < posicionTransbordoDestino {
                                        for i in stride(from: posicionTransbordoDestino - 1, through: estacionDestinoInput - 1, by: -1) {
                                            let num = celda("\(i + 1)", ancho: 4)
                                            let nom = celda(estacionesDestino[i], ancho: 49)
                                            print("│ \(num) │ \(nom) │")
                                        }
                                    }
                                    print("└──────┴───────────────────────────────────────────────────┘")
                                }
                            }
                        }

                    } else {
                        print("\n ERROR: Número de estación inválido.")
                    }

                } else {
                    print("\n ERROR: Línea de destino no encontrada.")
                }

            } else {
                print("\n  ERROR: Número de estación inválido.")
            }

        } else {
            print("\n ERROR: Línea de origen no encontrada.")
        }
        
        // ==========================================================
        // 6) GESTIONAR TARJETA DE TRANSPORTE
        // Permite adquirir tarjeta, consultar saldo, recargar
        // y pagar el pasaje.
        // ==========================================================

    case 6:

            var salirTarjeta = false

            while !salirTarjeta {

                print("\n========================================")
                print("       TARJETAS DE TRANSPORTE")
                print("========================================")
                print("1) Adquirir tarjeta de una linea")
                print("2) Consultar saldo")
                print("3) Recargar saldo")
                print("4) Pagar pasaje")
                print("5) Ver tarjetas adquiridas")
                print("6) Regresar")
                print("========================================")
                print("Seleccione una opcion: ", terminator: "")

                let opcionTarjeta = Int(readLine() ?? "0") ?? 0

                switch opcionTarjeta {

                // ==================================================
                // 1) ADQUIRIR TARJETA
                // ==================================================

                case 1:

                    print("\nSeleccione la linea de la tarjeta (1-6): ", terminator: "")
                    let numeroLinea = readLine() ?? ""

                    if let linea = mapLineas[numeroLinea] {

                        if linea == "BRT" {

                            print("\n[ERROR] El BRT no utiliza tarjeta propia.")

                        } else if tarjetasLinea.contains(linea) {

                            print("\n[ERROR] Ya posee una tarjeta para \(linea).")
                            print("Numero de tarjeta: \(numerosTarjeta[linea] ?? "")")

                        } else {

                            let numeroNuevo = Int.random(in: 10000...99999)

                            let numeroTarjetaNueva = "METRO-\(linea)-\(numeroNuevo)"

                            tarjetasLinea.insert(linea)

                            numerosTarjeta[linea] = numeroTarjetaNueva

                            saldosTarjeta[linea] = 0.00

                            print("\n[OK] Tarjeta adquirida correctamente.")
                            print("Linea: \(linea)")
                            print("Numero de tarjeta: \(numeroTarjetaNueva)")
                            print("Saldo inicial: S/ 0.00")
                        }

                    } else {

                        print("\n[ERROR] Linea no encontrada.")
                    }


                // ==================================================
                // 2) CONSULTAR SALDO
                // ==================================================

                case 2:

                    print("\nSeleccione la linea de la tarjeta (1-6): ", terminator: "")
                    let numeroLinea = readLine() ?? ""

                    if let linea = mapLineas[numeroLinea] {

                        if tarjetasLinea.contains(linea) {

                            let numeroTarjeta = numerosTarjeta[linea] ?? ""
                            let saldo = saldosTarjeta[linea] ?? 0.00

                            print("\n----------------------------------------")
                            print("          CONSULTA DE SALDO")
                            print("----------------------------------------")
                            print("Linea: \(linea)")
                            print("Tarjeta: \(numeroTarjeta)")

                            print(
                                String(
                                    format: "Saldo actual: S/ %.2f",
                                    saldo
                                )
                            )

                        } else {

                            print("\n[ERROR] No posee tarjeta para \(linea).")
                            print("Seleccione la opcion 1 para adquirir una.")
                        }

                    } else {

                        print("\n[ERROR] Linea no encontrada.")
                    }


                // ==================================================
                // 3) RECARGAR SALDO
                // ==================================================

                case 3:

                    print("\nSeleccione la linea de la tarjeta (1-6): ", terminator: "")
                    let numeroLinea = readLine() ?? ""

                    if let linea = mapLineas[numeroLinea] {

                        if tarjetasLinea.contains(linea) {

                            print("Ingrese monto de recarga: ", terminator: "")

                            if let recarga = Double(readLine() ?? ""),
                               recarga > 0 {

                                saldosTarjeta[linea, default: 0.00] += recarga

                                let nuevoSaldo = saldosTarjeta[linea] ?? 0.00

                                print("\n[OK] Recarga realizada.")

                                print(
                                    String(
                                        format: "Saldo actual: S/ %.2f",
                                        nuevoSaldo
                                    )
                                )

                            } else {

                                print("\n[ERROR] Monto de recarga invalido.")
                            }

                        } else {

                            print("\n[ERROR] No posee tarjeta para \(linea).")
                            print("Primero debe adquirirla.")
                        }

                    } else {

                        print("\n[ERROR] Linea no encontrada.")
                    }


                // ==================================================
                // 4) PAGAR PASAJE
                // ==================================================

                case 4:

                    print("\nSeleccione la linea de la tarjeta (1-6): ", terminator: "")
                    let numeroLinea = readLine() ?? ""

                    if let linea = mapLineas[numeroLinea] {

                        if tarjetasLinea.contains(linea) {

                            let saldoActual = saldosTarjeta[linea] ?? 0.00

                            print("\n----------------------------------------")
                            print("            PAGO DE PASAJE")
                            print("----------------------------------------")
                            print("Linea: \(linea)")

                            print(
                                String(
                                    format: "Tarifa: S/ %.2f",
                                    tarifaPasaje
                                )
                            )

                            if saldoActual >= tarifaPasaje {

                                saldosTarjeta[linea] = saldoActual - tarifaPasaje

                                let saldoRestante = saldosTarjeta[linea] ?? 0.00

                                print("\n[OK] Pasaje pagado correctamente.")

                                print(
                                    String(
                                        format: "Saldo restante: S/ %.2f",
                                        saldoRestante
                                    )
                                )

                            } else {

                                print("\n[ERROR] Saldo insuficiente.")

                                print(
                                    String(
                                        format: "Saldo actual: S/ %.2f",
                                        saldoActual
                                    )
                                )

                                print("Realice una recarga para continuar.")
                            }

                        } else {

                            print("\n[ERROR] No posee tarjeta para \(linea).")
                            print("Primero debe adquirir una tarjeta.")
                        }

                    } else {

                        print("\n[ERROR] Linea no encontrada.")
                    }


                // ==================================================
                // 5) VER TARJETAS ADQUIRIDAS
                // ==================================================

                case 5:

                    print("\n----------------------------------------")
                    print("       TARJETAS ADQUIRIDAS")
                    print("----------------------------------------")

                    if tarjetasLinea.isEmpty {

                        print("No posee tarjetas actualmente.")

                    } else {

                        for linea in tarjetasLinea.sorted() {

                            let numero = numerosTarjeta[linea] ?? ""
                            let saldo = saldosTarjeta[linea] ?? 0.00

                            print("\nLinea: \(linea)")
                            print("Tarjeta: \(numero)")

                            print(
                                String(
                                    format: "Saldo: S/ %.2f",
                                    saldo
                                )
                            )
                        }
                    }


                // ==================================================
                // 6) REGRESAR
                // ==================================================

                case 6:

                    salirTarjeta = true


                default:

                    print("\n[ERROR] Opcion invalida.")
                }

                if !salirTarjeta {

                    print("\nPresione ENTER para continuar...")
                    _ = readLine()
                }
            }


    case 7:
                print("\n========================================")
                print("          MODO ADMINISTRADOR")
                print("========================================")
                print("Ingrese contraseña: ", terminator: "")

                let contraseñaAdmin = readLine() ?? ""

                if contraseñaAdmin != "admin123" {

                    print("\n[ERROR] Contraseña incorrecta.")

                } else {

                    var salirAdmin = false

                    while !salirAdmin {

                        print("\n========================================")
                        print("          PANEL ADMINISTRADOR")
                        print("========================================")
                        print("1) Agregar estacion")
                        print("2) Agregar nueva linea")
                        print("3) Deshabilitar estacion")
                        print("4) Habilitar estacion")
                        print("5) Deshabilitar linea")
                        print("6) Habilitar linea")
                        print("7) Ver estado de la red")
                        print("8) Regresar")
                        print("========================================")
                        print("Seleccione una opcion: ", terminator: "")

                        let opcionAdmin = Int(readLine() ?? "0") ?? 0

                        switch opcionAdmin {

                        // ==================================================
                        // 1) AGREGAR ESTACION
                        // ==================================================

                        case 1:

                            print("\nIngrese numero de linea (1-6): ", terminator: "")
                            let numeroLinea = readLine() ?? ""

                            if let claveLinea = mapLineas[numeroLinea],
                               let estaciones = redMetro[claveLinea] {

                                print("\nLinea seleccionada: \(claveLinea)")
                                print("Ingrese nombre de la nueva estacion: ", terminator: "")

                                let nuevaEstacion = readLine() ?? ""

                                if nuevaEstacion.isEmpty {

                                    print("\n[ERROR] El nombre no puede estar vacio.")

                                } else if estaciones.contains(nuevaEstacion) {

                                    print("\n[ERROR] Esa estacion ya existe en la linea.")

                                } else {

                                    redMetro[claveLinea]?.append(nuevaEstacion)

                                    print("\n[OK] Estacion agregada correctamente.")
                                    print("Linea: \(claveLinea)")
                                    print("Estacion: \(nuevaEstacion)")
                                }

                            } else {

                                print("\n[ERROR] Linea no encontrada.")
                            }


                        // ==================================================
                        // 2) AGREGAR NUEVA LINEA
                        // ==================================================

                        case 2:

                            print("\nIngrese numero de la nueva linea: ", terminator: "")
                            let numeroNuevaLinea = readLine() ?? ""

                            if numeroNuevaLinea.isEmpty {

                                print("\n[ERROR] Numero de linea invalido.")

                            } else if mapLineas[numeroNuevaLinea] != nil {

                                print("\n[ERROR] Esa linea ya existe.")

                            } else {

                                let nuevaLinea = "L\(numeroNuevaLinea)"

                                print("Ingrese primera estacion: ", terminator: "")
                                let primeraEstacion = readLine() ?? ""

                                if primeraEstacion.isEmpty {

                                    print("\n[ERROR] Debe ingresar una estacion.")

                                } else {

                                    redMetro[nuevaLinea] = [primeraEstacion]
                                    mapLineas[numeroNuevaLinea] = nuevaLinea
                                    kmLineas[numeroNuevaLinea] = "Por determinar"

                                    print("\n[OK] Nueva linea creada.")
                                    print("Linea: \(nuevaLinea)")
                                    print("Primera estacion: \(primeraEstacion)")
                                }
                            }


                        // ==================================================
                        // 3) DESHABILITAR ESTACION
                        // ==================================================

                        case 3:

                            print("\nIngrese numero de linea: ", terminator: "")
                            let numeroLinea = readLine() ?? ""

                            if let claveLinea = mapLineas[numeroLinea],
                               let estaciones = redMetro[claveLinea] {

                                if lineasDeshabilitadas.contains(claveLinea) {

                                    print("\n[ERROR] La linea completa esta deshabilitada.")

                                } else {

                                    print("\nEstaciones de \(claveLinea):")

                                    for (indice, estacion) in estaciones.enumerated() {

                                        if estacionesDeshabilitadas.contains(estacion) {

                                            print(" \(indice + 1)) [CERRADA] \(estacion)")

                                        } else {

                                            print(" \(indice + 1)) \(estacion)")
                                        }
                                    }

                                    print("\nSeleccione numero de estacion: ", terminator: "")
                                    let numeroEstacion = Int(readLine() ?? "0") ?? 0

                                    if numeroEstacion >= 1 &&
                                       numeroEstacion <= estaciones.count {

                                        let estacion = estaciones[numeroEstacion - 1]

                                        estacionesDeshabilitadas.insert(estacion)

                                        print("\n[OK] Estacion deshabilitada.")
                                        print("Linea: \(claveLinea)")
                                        print("Estacion: \(estacion)")
                                        print("Motivo: Accidente / mantenimiento")

                                    } else {

                                        print("\n[ERROR] Numero de estacion invalido.")
                                    }
                                }

                            } else {

                                print("\n[ERROR] Linea no encontrada.")
                            }


                        // ==================================================
                        // 4) HABILITAR ESTACION
                        // ==================================================

                        case 4:

                            if estacionesDeshabilitadas.isEmpty {

                                print("\nNo existen estaciones deshabilitadas.")

                            } else {

                                print("\n========================================")
                                print("     ESTACIONES DESHABILITADAS")
                                print("========================================")

                                for estacion in estacionesDeshabilitadas.sorted() {

                                    print(" - \(estacion)")
                                }

                                print("\nIngrese nombre exacto de la estacion: ", terminator: "")
                                let estacion = readLine() ?? ""

                                if estacionesDeshabilitadas.contains(estacion) {

                                    estacionesDeshabilitadas.remove(estacion)

                                    print("\n[OK] Estacion habilitada nuevamente.")
                                    print("Estacion: \(estacion)")

                                } else {

                                    print("\n[ERROR] Esa estacion no esta deshabilitada.")
                                }
                            }


                        // ==================================================
                        // 5) DESHABILITAR LINEA
                        // ==================================================

                        case 5:

                            print("\nIngrese numero de linea: ", terminator: "")
                            let numeroLinea = readLine() ?? ""

                            if let claveLinea = mapLineas[numeroLinea] {

                                if lineasDeshabilitadas.contains(claveLinea) {

                                    print("\n[ERROR] Esa linea ya esta deshabilitada.")

                                } else {

                                    lineasDeshabilitadas.insert(claveLinea)

                                    print("\n[OK] Linea deshabilitada.")
                                    print("Linea: \(claveLinea)")
                                    print("Motivo: Fuera de horario / mantenimiento / incidente")
                                }

                            } else {

                                print("\n[ERROR] Linea no encontrada.")
                            }


                        // ==================================================
                        // 6) HABILITAR LINEA
                        // ==================================================

                        case 6:

                            if lineasDeshabilitadas.isEmpty {

                                print("\nNo existen lineas deshabilitadas.")

                            } else {

                                print("\n========================================")
                                print("        LINEAS DESHABILITADAS")
                                print("========================================")

                                for linea in lineasDeshabilitadas.sorted() {

                                    print(" - \(linea)")
                                }

                                print("\nIngrese numero de linea: ", terminator: "")
                                let numeroLinea = readLine() ?? ""

                                if let claveLinea = mapLineas[numeroLinea] {

                                    if lineasDeshabilitadas.contains(claveLinea) {

                                        lineasDeshabilitadas.remove(claveLinea)

                                        print("\n[OK] Linea habilitada nuevamente.")
                                        print("Linea: \(claveLinea)")

                                    } else {

                                        print("\n[ERROR] Esa linea no esta deshabilitada.")
                                    }

                                } else {

                                    print("\n[ERROR] Linea no encontrada.")
                                }
                            }


                        // ==================================================
                        // 7) VER ESTADO DE LA RED
                        // ==================================================

                        case 7:

                            print("\n========================================")
                            print("          ESTADO DE LA RED")
                            print("========================================")

                            let lineasOrdenadas = redMetro.keys.sorted()

                            for linea in lineasOrdenadas {

                                if lineasDeshabilitadas.contains(linea) {

                                    print("\n\(linea) -> [X] LINEA DESHABILITADA")

                                } else {

                                    print("\n\(linea) -> [OK] LINEA OPERATIVA")
                                }

                                if let estaciones = redMetro[linea] {

                                    for estacion in estaciones {

                                        if estacionesDeshabilitadas.contains(estacion) {

                                            print("    [X] \(estacion) -> CERRADA")

                                        } else {

                                            print("    [OK] \(estacion) -> OPERATIVA")
                                        }
                                    }
                                }
                            }


                        // ==================================================
                        // 8) REGRESAR
                        // ==================================================

                        case 8:

                            salirAdmin = true
                            print("\nRegresando al menu principal...")


                        // ==================================================
                        // OPCION INVALIDA
                        // ==================================================

                        default:

                            print("\n[ERROR] Opcion invalida.")
                        }

                        if !salirAdmin {

                            print("\nPresione ENTER para continuar...")
                            _ = readLine()
                        }
                    }
                }
        
    case 8:
        print("\nFinalizando procesos del sistema...\nCerrando aplicacion.")
        salir = true
        continue
        
    default:
        print("\n[ERROR] Opcion invalida o en construccion.")
    }
    
    print("\nPresione ENTER para regresar al menu principal...")
    _ = readLine()
}
