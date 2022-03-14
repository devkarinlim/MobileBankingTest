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
        let amount = Converter.formatToCurrency(detail.amount, isShowSymbol: false)
        let isTransfer = detail.transactionType == TransactionType.TRANSFER.rawValue ? true : false
        if isTransfer{
            accountHolderLbl.text = detail.receipient?.accountHolder
            accountNoLbl.text = detail.receipient?.accountNo
        }
        else{
            accountHolderLbl.text = detail.sender?.accountHolder
            accountNoLbl.text = detail.sender?.accountNo
        }
        amountLbl.text = isTransfer ? "- " + "\(amount)" : "\(amount)"
        amountLbl.textColor = isTransfer  ? .darkGray : .systemGreen
        
        
    }
}
