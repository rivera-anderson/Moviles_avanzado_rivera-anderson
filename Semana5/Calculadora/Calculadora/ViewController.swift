import UIKit

class ViewController: UIViewController {
    
    // UI Elements
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
        view.backgroundColor = .systemBackground
        
        // Title
        titleLabel.text = "Calculadora de Préstamos"
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        // TextFields
        setupTextField(capitalTextField, placeholder: "Capital inicial (ej. 10000)")
        setupTextField(interestTextField, placeholder: "Tasa de interés anual % (ej. 15)")
        setupTextField(yearsTextField, placeholder: "Plazo del préstamo en años (ej. 5)")
        yearsTextField.keyboardType = .numberPad // Better for years
        
        // Button
        calculateButton.setTitle("Calcular", for: .normal)
        calculateButton.backgroundColor = .systemBlue
        calculateButton.setTitleColor(.white, for: .normal)
        calculateButton.layer.cornerRadius = 10
        calculateButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        calculateButton.addTarget(self, action: #selector(calculateLoan), for: .touchUpInside)
        
        // Result Labels
        monthlyPaymentLabel.text = "Cuota mensual: $0.00"
        monthlyPaymentLabel.font = .systemFont(ofSize: 18, weight: .medium)
        monthlyPaymentLabel.textAlignment = .center
        monthlyPaymentLabel.numberOfLines = 0
        
        totalPaymentLabel.text = "Monto total a pagar: $0.00"
        totalPaymentLabel.font = .systemFont(ofSize: 18, weight: .medium)
        totalPaymentLabel.textAlignment = .center
        totalPaymentLabel.numberOfLines = 0
        
        // StackView
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
        
        // Constraints
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            capitalTextField.heightAnchor.constraint(equalToConstant: 50),
            interestTextField.heightAnchor.constraint(equalToConstant: 50),
            yearsTextField.heightAnchor.constraint(equalToConstant: 50),
            calculateButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func setupTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.font = .systemFont(ofSize: 16)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func calculateLoan() {
        dismissKeyboard()
        
        // Validate inputs
        guard let capitalText = capitalTextField.text?.replacingOccurrences(of: ",", with: "."),
              let interestText = interestTextField.text?.replacingOccurrences(of: ",", with: "."),
              let yearsText = yearsTextField.text?.replacingOccurrences(of: ",", with: "."),
              let p = Double(capitalText),
              let annualInterestRate = Double(interestText),
              let years = Double(yearsText), // changed to Double to allow 1.5 years for example
              p > 0, annualInterestRate > 0, years > 0 else {
            
            monthlyPaymentLabel.text = "Por favor, ingrese valores válidos mayores a 0."
            totalPaymentLabel.text = ""
            return
        }
        
        // r = tasa de interés mensual (interés anual dividido entre 12)
        // Se asume que el usuario ingresa un porcentaje, ej. 15. Así que se divide entre 100.
        let r = (annualInterestRate / 100.0) / 12.0
        
        // n = número total de pagos (número de años multiplicado por 12)
        let n = years * 12.0
        
        // M = P * (r(1+r)^n) / ((1+r)^n - 1)
        let numerator = r * pow(1.0 + r, n)
        let denominator = pow(1.0 + r, n) - 1.0
        let m = p * (numerator / denominator)
        
        // Monto total a pagar = cuota mensual * número total de pagos
        let total = m * n
        
        // Formatting
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$" 
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        let formattedMonthly = formatter.string(from: NSNumber(value: m)) ?? "$\(String(format: "%.2f", m))"
        let formattedTotal = formatter.string(from: NSNumber(value: total)) ?? "$\(String(format: "%.2f", total))"
        
        monthlyPaymentLabel.text = "Cuota mensual:\n\(formattedMonthly)"
        totalPaymentLabel.text = "Monto total a pagar:\n\(formattedTotal)"
    }
}
