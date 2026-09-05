// Desarrollado por: rivera anderson
import Foundation

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

// Mapeos auxiliares
let mapLineas = ["1": "L1", "2": "L2", "3": "L3", "4": "L4", "5": "L5", "6": "L6", "7": "BRT"]
let kmLineas = ["1": "37.00 km", "2": "27.00 km", "3": "31.50 km", "4": "26.00 km", "5": "13.90 km", "6": "30.00 km", "7": "Ruta Exclusiva"]

// 2. PANTALLA DE INICIO (SPLASH SCREEN LOGO)
// Usamos #""" para que Swift no explote con las barras invertidas del dibujo
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

// 3. MENU PRINCIPAL (TIPO DASHBOARD)
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
    print(" 5) Salir del sistema")
    print("==========================================================")
    print("Seleccione una opcion [1-5]: ", terminator: "")
    
    let opcion = Int(readLine() ?? "0") ?? 0
    
    switch opcion {
    case 1:
        print("\nSeleccione la linea a consultar (1-6, o 7 para BRT): ", terminator: "")
        let input = readLine() ?? ""
        if let lineaClave = mapLineas[input], let estaciones = redMetro[lineaClave] {
            let extension = kmLineas[input] ?? ""
            print("\n----------------------------------------")
            print(" REPORTE DE ESTACIONES: LINEA \(input) (\(extension))")
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
        
        // Buscamos ignorando mayúsculas/minúsculas
        for (nombreLinea, estaciones) in redMetro {
            for est in estaciones {
                if est.lowercased() == buscar.lowercased() {
                    if !lineasEncontradas.contains(nombreLinea) {
                        lineasEncontradas.append(nombreLinea)
                    }
                }
            }
        }
        
        print("\n----------------------------------------")
        print(" RESULTADO DE BUSQUEDA")
        print("----------------------------------------")
        print("Estacion consultada : \(buscar)")
        if lineasEncontradas.count > 0 {
            print("Lineas disponibles  : \(lineasEncontradas.joined(separator: " - "))")
            print("Estado              : OPERATIVO")
        } else {
            print("Estado              : NO ENCONTRADA")
        }
        print("----------------------------------------")
        
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
            
            print("\n----------------------------------------")
            print(" REPORTE DE TRANSBORDOS")
            print("----------------------------------------")
            print("Linea origen  : Linea \(input1)")
            print("Linea destino : Linea \(input2)")
            
            if cruces.isEmpty {
                print("Conexion      : SIN CONEXION DIRECTA")
            } else {
                print("Conexion      : DISPONIBLE")
                print("Punto(s)      : \(cruces.joined(separator: ", "))")
            }
            print("----------------------------------------")
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
        print("\nFinalizando procesos del sistema...")
        print("Cerrando aplicacion.")
        salir = true
        continue
        
    default:
        print("\n[ERROR] Comando no reconocido.")
    }
    
    // Pausa antes de regresar al menu principal
    print("\nPresione ENTER para regresar al menu principal...")
    _ = readLine()
}