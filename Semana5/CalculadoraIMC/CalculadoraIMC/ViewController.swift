import UIKit

class ViewController: UIViewController {
    
    // UI Elements
    let titleLabel = UILabel()
    
    let pesoLabel = UILabel()
    let weightTextField = UITextField()
    
    let alturaLabel = UILabel()
    let heightTextField = UITextField()
    
    let calculateButton = UIButton(type: .system)
    
    let subtitleLabel = UILabel()
    let resultLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Título
        titleLabel.text = "Calcular el IMC de una Persona"
        titleLabel.font = .systemFont(ofSize: 20, weight: .regular)
        titleLabel.textColor = .systemBlue
        titleLabel.textAlignment = .center
        
        // Labels y TextFields
        pesoLabel.text = "Peso (Kg)"
        pesoLabel.font = .systemFont(ofSize: 16)
        
        alturaLabel.text = "Altura(m)"
        alturaLabel.font = .systemFont(ofSize: 16)
        
        setupTextField(weightTextField, placeholder: "")
        setupTextField(heightTextField, placeholder: "")
        
        // Botón
        calculateButton.setTitle(" Mostrar", for: .normal)
        calculateButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        calculateButton.titleLabel?.font = .systemFont(ofSize: 18)
        calculateButton.addTarget(self, action: #selector(calculateIMC), for: .touchUpInside)
        
        // Subtítulo y Resultado
        subtitleLabel.text = "Resultado IMC"
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textAlignment = .center
        
        resultLabel.text = "IMC: 0.00 - N/A"
        resultLabel.font = .systemFont(ofSize: 20, weight: .regular)
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 0
        
        // Contenedores horizontales para los inputs
        let weightStack = UIStackView(arrangedSubviews: [pesoLabel, weightTextField])
        weightStack.axis = .horizontal
        weightStack.spacing = 20
        weightStack.distribution = .fillEqually
        
        let heightStack = UIStackView(arrangedSubviews: [alturaLabel, heightTextField])
        heightStack.axis = .horizontal
        heightStack.spacing = 20
        heightStack.distribution = .fillEqually
        
        // StackView Principal
        let mainStack = UIStackView(arrangedSubviews: [
            titleLabel,
            weightStack,
            heightStack,
            calculateButton,
            subtitleLabel,
            resultLabel
        ])
        
        mainStack.axis = .vertical
        mainStack.spacing = 30
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStack)
        
        // Constraints
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            weightTextField.heightAnchor.constraint(equalToConstant: 34),
            heightTextField.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        // Ocultar teclado
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func setupTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .line
        textField.keyboardType = .decimalPad
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func calculateIMC() {
        dismissKeyboard()
        
        guard let pesoText = weightTextField.text?.replacingOccurrences(of: ",", with: "."),
              let alturaText = heightTextField.text?.replacingOccurrences(of: ",", with: "."),
              let peso = Double(pesoText),
              let altura = Double(alturaText),
              peso > 0, altura > 0 else {
            resultLabel.text = "Por favor ingrese valores válidos."
            return
        }
        
        let imc = peso / (altura * altura)
        let formattedIMC = String(format: "%.2f", imc)
        
        var categoria = ""
        
        if imc < 18.5 {
            categoria = "Bajo peso"
        } else if imc <= 24.9 {
            categoria = "Peso normal"
        } else if imc <= 29.9 {
            categoria = "Sobrepeso"
        } else {
            categoria = "Obesidad"
        }
        
        resultLabel.text = "IMC: \(formattedIMC) - \(categoria)"
    }
}
