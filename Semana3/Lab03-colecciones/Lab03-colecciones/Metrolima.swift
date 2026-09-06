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

let mapLineas = ["1": "L1", "2": "L2", "3": "L3", "4": "L4", "5": "L5", "6": "L6", "7": "BRT"]
let kmLineas = ["1": "37.00 km", "2": "27.00 km", "3": "31.50 km", "4": "26.00 km", "5": "13.90 km", "6": "30.00 km", "7": "Ruta Exclusiva"]