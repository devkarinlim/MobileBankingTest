//
//  RegisterViewController.swift
//  MobileBanking
//
//  Created by Karin Lim on 12/03/22.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var regUsernameField: UITextField!
    @IBOutlet weak var usernameValidLbl: UILabel!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var passValidLbl: UILabel!
    @IBOutlet weak var passConfirmField: UITextField!
    @IBOutlet weak var passConfirmValidLbl: UILabel!
    @IBOutlet weak var regButton: UIButton!
    
    var username: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var pageTitle = "Register"
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        clearForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupForm()
        setupRegistrationBtn()
        initializeHideKeyboard()
    }
    
    func setupForm(){
        regUsernameField.delegate = self
        regUsernameField.textContentType = .oneTimeCode
        regUsernameField.tag = 1
        regUsernameField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passField.delegate = self
        passField.tag = 2
        passField.isSecureTextEntry = true
        passField.textContentType = .oneTimeCode
        passField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passConfirmField.delegate = self
        passConfirmField.tag = 3
        passConfirmField.isSecureTextEntry = true
        passConfirmField.textContentType = .oneTimeCode
        passConfirmField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        clearValidLabels()
    }
    
    func clearForm(){
        regUsernameField.text = ""
        passField.text = ""
        passConfirmField.text = ""
        clearValidLabels()
    }
    
    
    func clearValidLabels(){
        usernameValidLbl.text = ""
        passValidLbl.text = ""
        passConfirmValidLbl.text = ""
    }
    
    func setupRegistrationBtn(){
        regButton.setRoundedRed()
        regButton.setTitle(pageTitle.uppercased(), for: .normal)
    }
    
    func setupHeader(){
        if let iconImage = UIImage(named: "logo_transparent"){
            imageView.image = iconImage
        }
        titleLabel.text = pageTitle.capitalized
    }
    @IBAction func regButtonTapped(_ sender: Any) {
        register()
    }
    
    func register(){
        if(validateForm()){
            self.showSpinner(onView: self.view)
            let authUser = AuthenticationSend(username: username, password: password)
            AuthenticationApi.register(userData: authUser) { response in
                DispatchQueue.main.async {
                    AlertHelper.shared.showSuccess(title: "Registration Success",
                                                   message: "You've been registered. \nPlease login first.",
                                                   sender: self) {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            } failCompletion: { error in
                DispatchQueue.main.async {
                    AlertHelper.shared.showError(title: "Login Failed", message: error, sender: self)
                }
            }
        }
    }
    
    func validateForm()->Bool{
        clearValidLabels()
        username = regUsernameField.text!
        password = passField.text!
        confirmPassword = passConfirmField.text!
        if(username.isEmpty){
            usernameValidLbl.text = "Username is Required"
        }
        if(password.isEmpty){
            passValidLbl.text = "Password is Required"
        }
        if(confirmPassword.isEmpty){
            passConfirmValidLbl.text = "Password is Required"
        }
        var validated = !username.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
        if validated{
            validated = password == confirmPassword ? true : false
            if !validated {
                passConfirmValidLbl.text = "Password confirmation doesn't match!"
            }
        }
        return validated
    }
    
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(false)
    }

}

extension RegisterViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
         nextField.becomeFirstResponder()
        }
        else {
         textField.resignFirstResponder()
        }
        return false
    }
}
