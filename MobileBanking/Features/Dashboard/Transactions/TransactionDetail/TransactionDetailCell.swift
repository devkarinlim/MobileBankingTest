//
//  TransactionDetailCell.swift
//  MobileBanking
//
//  Created by Karin Lim on 13/03/22.
//

import UIKit

class TransactionDetailCell: UITableViewCell {
    
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var accountHolderLbl: UILabel!
    @IBOutlet weak var accountNoLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupContraints(){
    }

    func setupData(detail: TransactionData){
        let amount = String(format: "%.2f", detail.amount)
        let isTransfer = detail.transactionType == TransactionType.TRANSFER.rawValue ? true : false
        amountLbl.text = isTransfer ? "- " + "\(amount)" : "\(amount)"
        amountLbl.textColor = isTransfer  ? .darkGray : .systemGreen
        accountHolderLbl.text = detail.receipient.accountHolder
        accountNoLbl.text = detail.receipient.accountNo
    }
}
