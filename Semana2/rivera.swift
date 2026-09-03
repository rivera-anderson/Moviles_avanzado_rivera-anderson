import Foundation

#if os(Linux)
import Glibc
#else
import Darwin
#endif

print("=== REGISTRO DE PRESTAMO - BIBLIOTECA ===")

let formatter = DateFormatter()
formatter.dateFormat = "dd/MM/yyyy"

// 1. Datos básicos del préstamo
print("Ingresa el titulo del libro:")
let titulo = readLine() ?? "Sin titulo"

// 2. Tipo de usuario
print("Tipo de usuario:")
print("1: Alumno [Max 7d]")
print("2: Docente [Max 15d]")
print("3: Admin [Max 10d]")
print("4: Coordinador [Max 15d]")

let tipoInput = readLine() ?? "1"

// 3. Definición de límites por usuario
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
    
} else if tipoInput == "4" {
    maxDias = 15
    tarifaBase = 4.00
    nombreTipo = "Coordinador"
}

let limiteAtraso = (nombreTipo == "Coordinador") ? 20 : 10

print("")
print("Limite normal para \(nombreTipo): \(maxDias) dias.")
print("Tarifa base: S/ \(String(format: "%.2f", tarifaBase))")
print("Limite de atraso: \(limiteAtraso) dias.")

// 4. Bucle para ingresar fechas válidas
var fechasValidas = false

while !fechasValidas {

    print("")
    print("-----------------------------------------------")
    print("Fecha de prestamo (dd/MM/yyyy):")
    let fechaInicioStr = readLine() ?? ""

    guard let fechaInicio = formatter.date(from: fechaInicioStr) else {
        print("ERROR: Fecha de prestamo invalida.")
        continue
    }

    print("Fecha de devolucion real (dd/MM/yyyy):")
    let fechaFinStr = readLine() ?? ""

    guard let fechaFin = formatter.date(from: fechaFinStr) else {
        print("ERROR: Fecha de devolucion invalida.")
        continue
    }

    // 5. Logica de dias transcurridos
    let calendar = Calendar.current
    let inicio = calendar.startOfDay(for: fechaInicio)
    let fin = calendar.startOfDay(for: fechaFin)

    if fin < inicio {
        print("ERROR: La fecha de devolucion no puede ser anterior.")
        continue
    }

    let diff = calendar.dateComponents(
        [.day],
        from: inicio,
        to: fin
    )

    let diasTotales = max(1, (diff.day ?? 0) + 1)
    let diasAtraso = max(0, diasTotales - maxDias)

    // 6. VALIDACION DE SUSPENSION

    if diasAtraso >= limiteAtraso {

        print("")
        print("---------------------------------------------------")
        print("ERROR: FECHA INVALIDA / USUARIO SUSPENDIDO")
        print("---------------------------------------------------")
        print("Libro:              \(titulo)")
        print("Usuario:            \(nombreTipo)")
        print("Dias prestados:     \(diasTotales) dias.")
        print("Dias de atraso:     \(diasAtraso) dias.")
        print("Estado:             SUSPENDIDO.")
        print("---------------------------------------------------")
        print("El usuario alcanzo o supero el limite de atraso.")
        print("El programa se cerrara.")
        print("---------------------------------------------------")

        exit(0)
    }

    // 7. Fechas correctas
    fechasValidas = true

    let estadoPrestamo = (diasAtraso > 0)
        ? "Devuelto con atraso"
        : "Devuelto a tiempo"

    // 8. BOLETA

    print("")
    print("=================================")
    print("        BOLETA DE PRESTAMO")
    print("=================================")
    print("Libro:             \(titulo)")
    print("Usuario:           \(nombreTipo)")
    print("Limite Permitido:  \(maxDias) dias")
    print("Fecha Prestamo:    \(formatter.string(from: fechaInicio))")
    print("Fecha Devolucion:  \(formatter.string(from: fechaFin))")
    print("Dias Totales:      \(diasTotales) dias")
    print("Dias de Atraso:    \(diasAtraso) dias")
    print("Estado Prestamo:   \(estadoPrestamo)")
    print("Estado Usuario:    ACTIVO")
    print("---------------------------------")

    // 9. TABLA DE MULTAS PROGRESIVAS

    var totalMulta = 0.0

    if diasAtraso > 0 {

        print("TABLA DE DÍAS DE ATRASO:")
        print("Día Atraso | Fecha      | Costo Día  | Acumulado")
        print("-----------------------------------------------")

        for dia in 1...diasAtraso {

            let diaAbsoluto = maxDias + dia

            let fechaDia = calendar.date(
                byAdding: .day,
                value: diaAbsoluto - 1,
                to: inicio
            ) ?? inicio

            var costoDia = tarifaBase

            // REGLAS DEL COORDINADOR

            if nombreTipo == "Coordinador" {

                if dia >= 1 && dia <= 3 {
                    // 1 - 3: sin aumento
                    costoDia = tarifaBase

                } else if dia >= 4 && dia <= 6 {
                    // 4 - 6: 20%
                    costoDia = tarifaBase * 1.25

                } else if dia >= 7 && dia <= 10 {
                    // 7 - 10: 50%
                    costoDia = tarifaBase * 1.50

                } else if dia >= 11 && dia <= 20 {
                    // 11 - 20: 100%
                    costoDia = tarifaBase * 2.00
                }
            }
else {

                // REGLAS DE LOS DEMAS USUARIOS

                // 1 - 3 días: tarifa normal
                if dia >= 1 && dia <= 3 {
                    costoDia = tarifaBase

                // 4 - 6 días: 50% adicional
                } else if dia >= 4 && dia <= 6 {
                    costoDia = tarifaBase * 1.50

                // 7 días en adelante: 100% adicional
                } else if dia >= 7 {
                    costoDia = tarifaBase * 2.00
                }
            }

            totalMulta += costoDia

            let fechaStr = formatter.string(from: fechaDia)

            print(
                String(
                    format: "Día %-7d | %-10@ | S/ %-7.2f | S/ %.2f",
                    dia,
                    fechaStr,
                    costoDia,
                    totalMulta
                )
            )
        }

    } else {

        print("Sin días de atraso registrados. Devolución realizada a tiempo.")
    }

    // 10. TOTAL

    print("-----------------------------------------------")

    print(
        String(
            format: "TOTAL MULTA ACUMULADA: S/ %.2f",
            totalMulta
        )
    )

    print("===============================================\n")
}
