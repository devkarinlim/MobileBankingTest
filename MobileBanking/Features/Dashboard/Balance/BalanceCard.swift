//
//  BalanceCard.swift
//  MobileBanking
//
//  Created by Karin Lim on 13/03/22.
//

import UIKit

class BalanceCard: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accountNoTitle: UILabel!
    @IBOutlet weak var accountNoValue: UILabel!
    @IBOutlet weak var accountHolderTitle: UILabel!
    @IBOutlet weak var accountHolderValue: UILabel!
    @IBOutlet weak var balanceAmount: UILabel!
    
    static let identifier = "BalanceCard"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("BalanceCard", owner: self, options: nil)
        
//        containerView.translatesAutoresizingMaskIntoConstraints = true
        containerView.layer.cornerRadius = 24
//        containerView.bottomAnchor.constraint(equalTo: self.bounds, constant: 0).isActive = true
//        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
//        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        
        addSubview(containerView)
    }
    
    private func setupBorderedCornerdView(view: UIView){
    }
    
    public func setBalanceAmount(_ balance: Double){
        balanceAmount.text = "SGD " + String(format: "%.2f", balance)
    }
    
    public func setAccountNo(_ accountNo: String){
        accountNoValue.text = accountNo
    }
    
    public func setAccountHolder(_ name: String){
        accountHolderValue.text = name
    }
    
}
