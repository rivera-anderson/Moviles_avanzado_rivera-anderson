import UIKit

class ViewController: UIViewController {
    
    // Elementos de la interfaz (UI)
    let titleLabel = UILabel()
    
    let capitalTextField = UITextField()
    let interestTextField = UITextField()
    let yearsTextField = UITextField()
    
    let calculateButton = UIButton(type: .system)
    
    let monthlyPaymentLabel = UILabel()
    let totalPaymentLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        // Fondo blanco para que se vea bien en iOS
        view.backgroundColor = .systemBackground
        
        // Configuración del Título
        titleLabel.text = "Calculadora de Préstamos"
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        // Configuración de los TextFields
        setupTextField(capitalTextField, placeholder: "Capital inicial (ej. 10000)")
        setupTextField(interestTextField, placeholder: "Tasa de interés anual % (ej. 15)")
        setupTextField(yearsTextField, placeholder: "Plazo del préstamo en años (ej. 5)")
        
        // Configuración del Botón de Calcular
        calculateButton.setTitle("Calcular", for: .normal)
        calculateButton.backgroundColor = .systemBlue
        calculateButton.setTitleColor(.white, for: .normal)
        calculateButton.layer.cornerRadius = 10
        calculateButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        calculateButton.addTarget(self, action: #selector(calculateLoan), for: .touchUpInside)
        
        // Configuración de los Textos de Resultado
        monthlyPaymentLabel.text = "Cuota mensual: $0.00"
        monthlyPaymentLabel.font = .systemFont(ofSize: 18, weight: .medium)
        monthlyPaymentLabel.textAlignment = .center
        monthlyPaymentLabel.numberOfLines = 0
        
        totalPaymentLabel.text = "Monto total a pagar: $0.00"
        totalPaymentLabel.font = .systemFont(ofSize: 18, weight: .medium)
        totalPaymentLabel.textAlignment = .center
        totalPaymentLabel.numberOfLines = 0
        
        // Apilar todos los elementos verticalmente
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            capitalTextField,
            interestTextField,
            yearsTextField,
            calculateButton,
            monthlyPaymentLabel,
            totalPaymentLabel
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        // Constraints (Reglas de diseño para que se adapte a cualquier pantalla)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            capitalTextField.heightAnchor.constraint(equalToConstant: 50),
            interestTextField.heightAnchor.constraint(equalToConstant: 50),
            yearsTextField.heightAnchor.constraint(equalToConstant: 50),
            calculateButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Ocultar teclado al tocar fuera
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // Función de ayuda para darle estilo a los textfields
    func setupTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.font = .systemFont(ofSize: 16)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Lógica matemática (La fórmula de amortización)
    @objc func calculateLoan() {
        dismissKeyboard()
        
        // Validar que el usuario sí ingresó números (cambiamos coma por punto por si acaso)
        guard let capitalText = capitalTextField.text?.replacingOccurrences(of: ",", with: "."),
              let interestText = interestTextField.text?.replacingOccurrences(of: ",", with: "."),
              let yearsText = yearsTextField.text?.replacingOccurrences(of: ",", with: "."),
              let p = Double(capitalText),
              let annualInterestRate = Double(interestText),
              let years = Int(yearsText),
              p > 0, annualInterestRate > 0, years > 0 else {
            
            monthlyPaymentLabel.text = "⚠️ Por favor, ingrese valores válidos."
            totalPaymentLabel.text = ""
            return
        }
        
        // r = tasa de interés mensual
        let r = (annualInterestRate / 100.0) / 12.0
        
        // n = número total de pagos
        let n = Double(years * 12)
        
        // M = P * (r(1+r)^n) / ((1+r)^n - 1)
        let numerator = r * pow(1 + r, n)
        let denominator = pow(1 + r, n) - 1
        let m = p * (numerator / denominator)
        
        // Monto total a pagar
        let total = m * n
        
        // Formatear resultados como dinero
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$" // Puedes cambiarlo a "S/" si deseas
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        let formattedMonthly = formatter.string(from: NSNumber(value: m)) ?? "$\(String(format: "%.2f", m))"
        let formattedTotal = formatter.string(from: NSNumber(value: total)) ?? "$\(String(format: "%.2f", total))"
        
        monthlyPaymentLabel.text = "Cuota mensual:\n\(formattedMonthly)"
        totalPaymentLabel.text = "Monto total a pagar:\n\(formattedTotal)"
    }
}
