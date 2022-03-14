//
//  LoginViewController.swift
//  MobileBanking
//
//  Created by Karin Lim on 12/03/22.
//

import UIKit

class LoginViewController: UIViewController {
    public let pageTitle: String = "LOGIN"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var usernameValidLabel : UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordValidLabel : UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registBtn: UIButton!
    
    private var username: String!
    private var password: String!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        clearCache()
    }
    
    func clearCache(){
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.AUTH_TOKEN)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.USERNAME)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.ACCOUNT_NO)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        clearForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupForm()
        setupLoginBtn()
        setupRegistrationBtn()
        initializeHideKeyboard()
    }
    
    func setupForm(){
        usernameField.delegate = self
        passwordField.delegate = self
        usernameField.textContentType = .oneTimeCode
        usernameField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        usernameField.tag = 1
        passwordField.tag = 2
        passwordField.isSecureTextEntry = true
        passwordField.textContentType = .oneTimeCode
        passwordField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        clearValidLabels()
    }
    
    func clearForm(){
        usernameField.text = ""
        passwordField.text = ""
        clearValidLabels()
    }
    
    
    func clearValidLabels(){
        usernameValidLabel.text = ""
        passwordValidLabel.text = ""
    }
    
    func setupLoginBtn(){
        loginBtn.setRoundedRed()
        loginBtn.setTitle(pageTitle, for: .normal)
    }
    
    func setupRegistrationBtn(){
        registBtn.setRoundedBorderRed()
        registBtn.setTitle("REGISTER", for: .normal)
    }
    
    func setupHeader(){
        if let iconImage = UIImage(named: "logo_transparent"){
            imageView.image = iconImage
        }
        titleLabel.text = pageTitle.capitalized
    }

    @IBAction func loginBtnTapped(_ sender: Any) {
        login()
    }
    
    func login(){
        if(validateForm()){
            self.showSpinner(onView: self.view)
            let authUser = AuthenticationSend(username: username, password: password)
            AuthenticationApi.login(userData: authUser) { response in
                UserDefaults.standard.set(response.token, forKey: UserDefaultKey.AUTH_TOKEN)
                UserDefaults.standard.set(self.username, forKey: UserDefaultKey.USERNAME)
                UserDefaults.standard.set(response.accountNo, forKey: UserDefaultKey.ACCOUNT_NO)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: SegueManager.DASHBOARD, sender: self)
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
        username = usernameField.text
        password = passwordField.text!
        if(username.isEmpty){
            usernameValidLabel.text = "Username is Required"
            
        }
        if(password.isEmpty){
            passwordValidLabel.text = "Password is Required"
        }
        let validated = !username.isEmpty && !password.isEmpty
        return validated
    }
    
    @IBAction func regBtnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: SegueManager.REGISTRATION, sender: self)
    }
    
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(false)
    }
    
    
}

extension LoginViewController: UITextFieldDelegate{
    
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

