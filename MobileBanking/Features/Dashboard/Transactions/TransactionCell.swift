//
//  TransactionCell.swift
//  MobileBanking
//
//  Created by Karin Lim on 13/03/22.
//

import UIKit

class TransactionCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var transactionPerDate: TransactionPerDate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellStyle()
        setupTableView()
    }
    
    func setupCellStyle(){
        containerView.layer.masksToBounds = false
        containerView.layer.cornerRadius = 24
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.red.cgColor
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TransactionDetailCell", bundle: nil), forCellReuseIdentifier: "TransactionDetailCell")
        //        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .darkGray
    }
    
    func setupData(transactionPerDate: TransactionPerDate){
        self.transactionPerDate = transactionPerDate
        tableView.reloadData()
    }
    
}

extension TransactionCell: UITableViewDelegate{
    
}

extension TransactionCell: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionPerDate?.detail.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionDetailCell", for: indexPath) as! TransactionDetailCell
        if let dataPerDate = transactionPerDate{
            cell.setupData(detail: dataPerDate.detail[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return transactionPerDate?.formattedDate ?? ""
    }
    
    
}
