//
//  TransferViewController.swift
//  MobileBanking
//
//  Created by Karin Lim on 14/03/22.
//

import UIKit

class TransferViewController: UIViewController {
    
    let pageTitle = "Transfer"
    
    @IBOutlet weak var recipientField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    @IBOutlet weak var transferBtn: UIButton!
    
    var pickerView = UIPickerView()
    var recipients: [AccountData] = []
    var transferData : TransferDataSend?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupPickerView()
        setupRecipientTF()
        setupTransferBtn()
        fetchRecipients()
        initializeHideKeyboard()
        transferData = TransferDataSend(receipientAccountNo: "", amount: 0, description: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = pageTitle
    }
    
    func setupRecipientTF(){
        let overlayButton = createOverlayButton(imageSystemName: "arrowtriangle.down.fill")
        recipientField.rightView = overlayButton
        recipientField.rightViewMode = .always
        recipientField.tag = 1
        recipientField.inputView = pickerView
    }
    
    func setupOtherFields(){
        amountField.tag = 2
        descriptionField.tag = 3
    }
    
    func setupTransferBtn(){
        transferBtn.setRoundedRed()
        transferBtn.setTitle("TRANSFER", for: .normal)
        transferBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
    }
    
    func setupPickerView(){
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func createOverlayButton(imageSystemName: String)->UIButton{
        let overlayButton = UIButton(type: .custom)
        let rightImage = UIImage(systemName: imageSystemName)
        overlayButton.setImage(rightImage, for: .normal)
        overlayButton.sizeToFit()
        overlayButton.setTitleColor(.gray, for: .normal)
        let paddingBtn: CGFloat = 16
        overlayButton.contentEdgeInsets = UIEdgeInsets(top: paddingBtn, left: paddingBtn, bottom: paddingBtn, right: paddingBtn)
        return overlayButton
    }
    
    func clearForm(){
        recipientField.text = ""
        amountField.text = ""
        descriptionField.text = ""
    }
    
    func fetchRecipients(){
        TransferApi.getRecipients { datas in
            DispatchQueue.main.async {
                self.recipients = datas
            }
        } failCompletion: { error in
            
        }
    }
    
    
    @IBAction func transferBtnTapped(_ sender: Any) {
        transfer()
    }
    
    func transfer(){
        if(validateForm()){
            fillData()
            AlertHelper.shared.showConfirmation(title: "m-Transfer", message: self.constructMessage(), sender: self) {
                return self.sendTransfer()
            } cancelHandler: {
            }
        }
    }
    
    func sendTransfer(){
        if let data = transferData{
            TransferApi.saveTransfer(data: data) { response in
                DispatchQueue.main.async {
                    self.processProof(data: response)
                }
            } failCompletion: { error in
                DispatchQueue.main.async {
                    AlertHelper.shared.showError(title: "Transfer Failed", message: error, sender: self)
                }
            }
        }
    }
    
    func processProof(data: TransferDataResponse){
        AlertHelper.shared.showSuccessLeft(title: "m-Transfer SUCCESS", message: constructMessage(), sender: self) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func fillData(){
        transferData?.amount = Double(amountField.text ?? "")!
        transferData?.description = descriptionField.text ?? ""
    }
    
    func constructMessage()->String{
        let senderNo = UserDefaults.standard.string(forKey: UserDefaultKey.ACCOUNT_NO)
        let receipientNo = transferData?.receipientAccountNo
        let amountWithCurrency = Converter.formatToCurrency(Double(transferData?.amount ?? 0))
        let description = transferData?.description ?? ""
        return "FR \(senderNo!)\n"+"TO \(receipientNo!)\n"+"\(amountWithCurrency)\n"+"\(description)"
    }
    
    func validateForm()->Bool{
        var validated = true
        if recipientField.text! == ""{
            AlertHelper.shared.showError(title: "", message: "Please select the receipient.", sender: self)
            validated = false
            return validated
        }
        if amountField.text! == ""{
            AlertHelper.shared.showError(title: "", message: "Please input transfer amount.", sender: self)
            validated = false
            return validated
        }
        return validated
    }
    
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
}

extension TransferViewController : UIPickerViewDataSource{
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recipients.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recipients[row].name
    }
}

extension TransferViewController : UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        recipientField.text = recipients[row].name
        transferData?.receipientAccountNo = recipients[row].accountNo
        recipientField.resignFirstResponder()
    }
}

extension TransferViewController: UITextFieldDelegate{
    
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
