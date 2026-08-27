import Foundation

print("=== REGISTRO DE DEVOLUCIÓN - BIBLIOTECA REY ===")

let formatter = DateFormatter()
formatter.dateFormat = "dd/MM/yyyy"

// 1. Datos básicos
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

print("\n📌 Limite permitido para \(nombreTipo): \(maxDias) dias sin multa.")

// 3. Fechas (Préstamo y Devolución Real)
print("Fecha de prestamo (dd/MM/yyyy):")
let fechaInicioStr = readLine() ?? ""
let fechaInicio = formatter.date(from: fechaInicioStr) ?? Date()

print("Fecha de devolucion real (dd/MM/yyyy):")
let fechaFinStr = readLine() ?? ""
let fechaFin = formatter.date(from: fechaFinStr) ?? Date()

