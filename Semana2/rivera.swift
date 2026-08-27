import Foundation

print("=== REGISTRO DE DEVOLUCIÓN - BIBLIOTECA REY ===")

let formatter = DateFormatter()
formatter.dateFormat = "dd/MM/yyyy"

// 1. Datos básicos del préstamo
print("Ingresa el titulo del libro:")
let titulo = readLine() ?? "Sin titulo"

print("Tipo de usuario (1: Alumno [Max 7d], 2: Docente [Max 15d], 3: Admin [Max 10d]):")
let tipoInput = readLine() ?? "1"

// 2. Definición de límites por usuario
var maxDias = 7
var tarifaBase = 1.50
var nombreTipo = "Alumno"

if tipoInput == "2" {
    maxDias = 15
    tarifaBase = 2.00
    nombreTipo = "Docente"
} else if tipoInput == "3" {
    maxDias = 10
    tarifaBase = 3.00
    nombreTipo = "Administrador"
}

let limiteMaximoAbsoluto = maxDias + 10
print("\n📌 Límite normal para \(nombreTipo): \(maxDias) días. Límite máximo total (con atraso permitidos < 10d): \(limiteMaximoAbsoluto - 1) días.")

// 3. Bucle interactivo para ingresar fechas válidas
var fechasValidas = false

while !fechasValidas {
    print("\n-----------------------------------------------")
    print("Fecha de prestamo (dd/MM/yyyy):")
    let fechaInicioStr = readLine() ?? ""
    let fechaInicio = formatter.date(from: fechaInicioStr) ?? Date()

    print("Fecha de devolucion real (dd/MM/yyyy):")
    let fechaFinStr = readLine() ?? ""
    let fechaFin = formatter.date(from: fechaFinStr) ?? Date()

    // Lógica de días transcurridos
    let calendar = Calendar.current
    let inicio = calendar.startOfDay(for: fechaInicio)
    let fin = calendar.startOfDay(for: fechaFin)
    let diff = calendar.dateComponents([.day], from: inicio, to: fin)
    let diasTotales = max(1, (diff.day ?? 0) + 1)
    let diasAtraso = max(0, diasTotales - maxDias)

    // VALIDACIÓN: Si excede o iguala los 10 días de atraso, reintenta sin cerrar el programa
    if diasAtraso >= 10 {
        print("\n❌ ---------------------------------------------------")
        print("ERROR: FECHA INVÁLIDA / USUARIO SUSPENDIDO")
        print("---------------------------------------------------")
        print("Días prestados:     \(diasTotales) días.")
        print("Días de atraso:     \(diasAtraso) días.")
        print("🚫 El usuario alcanzó o superó los 10 días de retraso permitidos.")
        print("🚫 Estado: SUSPENDIDO.")
        print("⚠️ No se puede generar la boleta. Por favor reingresa fechas válidas.")
    } else {
        // Fechas correctas: cambia la bandera para salir del bucle y mostrar la boleta
        fechasValidas = true
        let estadoPrestamo = (diasAtraso > 0) ? "Devuelto con atraso" : "Devuelto a tiempo"

        print("\n=================================")
        print("        BOLETA DE PRESTAMO       ")
        print("=================================")
        print("Libro:             \(titulo)")
        print("Usuario:           \(nombreTipo)")
        print("Limite Permitido:  \(maxDias) dias")
        print("Fecha Prestamo:    \(formatter.string(from: fechaInicio))")
        print("Fecha Devolucion:  \(formatter.string(from: fechaFin))")
        print("Dias Totales:      \(diasTotales) dias")
        print("Dias de Atraso:    \(diasAtraso) dias")
        print("Estado Prestamo:   \(estadoPrestamo)")
        print("Estado Usuario:    ACTIVO ✅")
        print("---------------------------------")

        // Tabla de Multas Progresivas
        var totalMulta = 0.0

        if diasAtraso > 0 {
            print("TABLA DE DÍAS DE ATRASO:")
            print("Día Atraso | Fecha      | Costo Día  | Acumulado")
            print("-----------------------------------------------")
            
            for dia in 1...diasAtraso {
                let diaAbsoluto = maxDias + dia
                let fechaDia = calendar.date(byAdding: .day, value: diaAbsoluto - 1, to: inicio) ?? inicio
                
                var costoDia = tarifaBase
                
                if dia >= 1 && dia <= 3 {
                    costoDia = tarifaBase
                } else if dia >= 4 && dia <= 6 {
                    costoDia = tarifaBase * 1.5
                } else if dia >= 7 {
                    costoDia = tarifaBase * 2.0
                }
                
                totalMulta += costoDia
                let fechaStr = formatter.string(from: fechaDia)
                
                print(String(format: "Día %-7d | %-10@ | S/ %-7.2f | S/ %.2f", dia, fechaStr, costoDia, totalMulta))
            }
        } else {
            print("Sin días de atraso registrados. Devolución realizada a tiempo.")
        }

        print("-----------------------------------------------")
        print(String(format: "TOTAL MULTA ACUMULADA: S/ %.2f", totalMulta))
        print("===============================================\n")
    }
}
