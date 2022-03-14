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
        containerView.layer.cornerRadius = 24
        containerView.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        
        addSubview(containerView)
        
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        accountHolderValue.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16).isActive = true
        
    }
    
    private func setupBorderedCornerdView(view: UIView){
    }
    
    public func setBalanceAmount(_ balance: Double){
        balanceAmount.text = Converter.formatToCurrency(balance, isShowSymbol: true)
    }
    
    public func setAccountNo(_ accountNo: String){
        accountNoValue.text = accountNo
    }
    
    public func setAccountHolder(_ name: String){
        accountHolderValue.text = name
    }
    
}
