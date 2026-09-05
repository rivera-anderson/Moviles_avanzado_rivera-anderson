// Desarrollado por: rivera anderson
import Foundation // Importamos la librería básica de Swift

print("¿Cuántos alumnos vas a registrar?") // Pedimos al usuario la cantidad de alumnos
let cantidadAlumnos = Int(readLine() ?? "0") ?? 0 // Leemos el dato y lo convertimos a número entero

var registroNotas: [String: [Double]] = [:] // Creamos un diccionario para guardar el nombre como clave y un arreglo de notas como valor

if cantidadAlumnos > 0 { // Verificamos que haya ingresado al menos 1 alumno
    for i in 1...cantidadAlumnos { // Iniciamos un bucle desde 1 hasta la cantidad indicada
        print("Nombre del alumno \(i):") // Pedimos el nombre del alumno actual
        let nombre = readLine() ?? "" // Leemos el nombre escrito en la consola
        
        var notasDelAlumno: [Double] = [] // Creamos un arreglo temporal vacío para almacenar las 3 notas
        for j in 1...3 { // Hacemos un bucle para pedir exactamente 3 notas
            print("Ingrese nota \(j) para \(nombre):") // Solicitamos cada nota
            let nota = Double(readLine() ?? "0") ?? 0.0 // Convertimos lo ingresado a un número decimal
            notasDelAlumno.append(nota) // Agregamos la nota al arreglo temporal del alumno
        }
        registroNotas[nombre] = notasDelAlumno // Asignamos el arreglo de 3 notas al nombre del alumno en el diccionario
    }
}

var promedios: [String: Double] = [:] // Creamos un diccionario para guardar el promedio final de cada alumno
var sumaPromediosGlobal = 0.0 // Inicializamos la suma de todos los promedios en cero
var aprobadosCount = 0 // Inicializamos el contador de alumnos aprobados
var notaMasAlta = 0.0 // Inicializamos la variable de la nota más alta con el valor mínimo posible
var notaMasBaja = 20.0 // Inicializamos la variable de la nota más baja con el valor máximo posible

print("\n--- REPORTE DE ALUMNOS ---") // Imprimimos el título del reporte
for (nombre, notas) in registroNotas { // Recorremos cada elemento del diccionario de notas
    var suma = 0.0 // Variable local para sumar las notas del alumno
    for nota in notas { // Recorremos el arreglo de las 3 notas del alumno actual
        suma += nota // Sumamos la nota a la variable suma
        if nota > notaMasAlta { notaMasAlta = nota } // Si esta nota es mayor a la guardada, actualizamos la más alta
        if nota < notaMasBaja { notaMasBaja = nota } // Si esta nota es menor a la guardada, actualizamos la más baja
    }
    
    let promedio = suma / 3.0 // Calculamos el promedio dividiendo la suma entre 3
    promedios[nombre] = promedio // Guardamos el promedio calculado en el diccionario de promedios
    sumaPromediosGlobal += promedio // Agregamos el promedio a la suma global para la estadística
    
    var clasificacion = "" // Variable para guardar el texto de la clasificación
    switch promedio { // Usamos un switch para evaluar el promedio
    case 18...20: clasificacion = "Excelente" // Si está entre 18 y 20, es Excelente
    case 15..<18: clasificacion = "Bueno" // Si está entre 15 y 17.9, es Bueno
    case 13..<15: clasificacion = "Aprobado" // Si está entre 13 y 14.9, es Aprobado
    default: clasificacion = "Desaprobado" // Cualquier nota menor a 13 es Desaprobado
    }
    
    if promedio >= 13.0 { aprobadosCount += 1 } // Si el promedio es mayor o igual a 13, incrementamos el contador de aprobados
    print("\(nombre) - Promedio: \(promedio) - Estado: \(clasificacion)") // Imprimimos el resultado final del alumno
}

let promedioGeneral = sumaPromediosGlobal / Double(cantidadAlumnos) // Calculamos el promedio de todo el salón
let porcentajeAprobados = (Double(aprobadosCount) / Double(cantidadAlumnos)) * 100 // Calculamos el porcentaje matemático de aprobados

print("\n--- ESTADÍSTICAS ---") // Imprimimos el título de la sección de estadísticas
print("Promedio General: \(promedioGeneral)") // Mostramos el promedio general calculado
print("Nota más alta registrada: \(notaMasAlta)") // Mostramos la nota más alta de todo el registro
print("Nota más baja registrada: \(notaMasBaja)") // Mostramos la nota más baja de todo el registro
print("Porcentaje de aprobados: \(porcentajeAprobados)%") // Mostramos el porcentaje de alumnos aprobados

print("\n--- ORDENADOS POR PROMEDIO ---") // Imprimimos el título de la sección de ordenamiento
let promediosOrdenados = promedios.sorted { $0.value > $1.value } // Ordenamos el diccionario comparando los valores de mayor a menor
for (nombre, promedio) in promediosOrdenados { // Recorremos el nuevo arreglo de promedios ordenados
    print("\(nombre): \(promedio)") // Imprimimos el nombre del alumno y su respectivo promedio
}

// Desarrollado por: rivera anderson
import Foundation // Importamos la librería base para funcionalidades básicas

var nombresProd: [String] = [] // Arreglo para almacenar los nombres de los productos
var preciosProd: [Double] = [] // Arreglo para almacenar los precios de los productos
var stocksProd: [Int] = [] // Arreglo para almacenar la cantidad en stock de cada producto

print("¿Cuántos productos registrará al inicio?") // Pedimos la cantidad inicial de productos a ingresar
let cantidadProductos = Int(readLine() ?? "0") ?? 0 // Leemos el dato de la consola y lo convertimos a entero

if cantidadProductos > 0 { // Verificamos que la cantidad sea mayor a cero
    for i in 1...cantidadProductos { // Iniciamos un bucle para registrar producto por producto
        print("Producto \(i) - Nombre:") // Solicitamos el nombre del producto
        nombresProd.append(readLine() ?? "") // Leemos y guardamos el nombre en su arreglo
        print("Precio:") // Solicitamos el precio del producto
        preciosProd.append(Double(readLine() ?? "0") ?? 0.0) // Leemos, convertimos a decimal y guardamos en su arreglo
        print("Stock:") // Solicitamos el stock disponible
        stocksProd.append(Int(readLine() ?? "0") ?? 0) // Leemos, convertimos a entero y guardamos en su arreglo
    }
}

var salir = false // Variable booleana que servirá como bandera para mantener o cerrar el menú

while !salir { // Iniciamos un bucle while que se repetirá mientras 'salir' sea falso
    print("\n--- MENÚ DE INVENTARIO ---") // Imprimimos el título del menú principal
    print("1) Ver inventario") // Mostramos la opción 1
    print("2) Buscar") // Mostramos la opción 2
    print("3) Stock bajo") // Mostramos la opción 3
    print("4) Valor total") // Mostramos la opción 4
    print("5) Salir") // Mostramos la opción 5
    print("Elige una opción:") // Pedimos al usuario que seleccione un número
    
    let opcion = Int(readLine() ?? "0") ?? 0 // Leemos la opción elegida y la convertimos a entero
    
    switch opcion { // Usamos un switch para ejecutar el código según la opción elegida
    case 1: // Caso 1: Mostrar todo el inventario
        print("\nINVENTARIO ACTUAL:") // Imprimimos subtítulo
        for i in 0..<nombresProd.count { // Recorremos los arreglos usando el total de elementos
            print("\(nombresProd[i]) - Precio: S/.\(preciosProd[i]) - Stock: \(stocksProd[i])") // Imprimimos los datos enlazando los índices
        }
    case 2: // Caso 2: Buscar un producto específico
        print("\nIngrese el nombre a buscar:") // Solicitamos el nombre a buscar
        let buscar = readLine() ?? "" // Leemos el nombre escrito por el usuario
        var encontrado = false // Bandera local para saber si el producto existe
        for i in 0..<nombresProd.count { // Recorremos la lista de nombres
            if nombresProd[i].lowercased() == buscar.lowercased() { // Comparamos en minúsculas para evitar errores
                print("Encontrado: \(nombresProd[i]) - S/.\(preciosProd[i]) - Stock: \(stocksProd[i])") // Mostramos la información si coincide
                encontrado = true // Cambiamos la bandera a verdadero
                break // Rompemos el bucle para no buscar más
            }
        }
        if !encontrado { print("Producto no encontrado en el sistema.") } // Si la bandera sigue falsa, avisamos que no existe
    case 3: // Caso 3: Mostrar productos con poco stock
        print("\nPRODUCTOS CON STOCK BAJO (<5):") // Imprimimos subtítulo
        for i in 0..<nombresProd.count { // Recorremos todos los elementos
            if stocksProd[i] < 5 { // Verificamos si el stock de la posición actual es menor a 5
                print("\(nombresProd[i]) tiene solo \(stocksProd[i]) unidades disponibles") // Imprimimos el aviso del producto
            }
        }
    case 4: // Caso 4: Calcular el valor de toda la mercancía
        var totalInventario = 0.0 // Variable para ir sumando el dinero total
        for i in 0..<nombresProd.count { // Recorremos todos los productos
            totalInventario += preciosProd[i] * Double(stocksProd[i]) // Multiplicamos el precio por el stock de cada uno y lo sumamos
        }
        print("\nValor total del inventario: S/.\(totalInventario)") // Imprimimos el gran total
    case 5: // Caso 5: Salir del programa
        print("Saliendo del sistema...") // Imprimimos mensaje de despedida
        salir = true // Cambiamos la bandera 'salir' a verdadero para que el while termine
    default: // Caso por defecto para ingresos incorrectos
        print("Opción inválida. Intente de nuevo.") // Mensaje de error si marca algo distinto del 1 al 5
    }
}