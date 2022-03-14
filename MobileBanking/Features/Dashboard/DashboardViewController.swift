//
//  DashboardViewController.swift
//  MobileBanking
//
//  Created by Karin Lim on 13/03/22.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var transactionContainerView: UIView!
    @IBOutlet weak var transferBtn: UIButton!
    @IBOutlet weak var balanceCardView: BalanceCard!
    @IBOutlet weak var tableView: UITableView!
    
    var balance: BalanceData?
    var transactionsPerDate: [TransactionPerDate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
//        setupCollectionView()
        setupTransactionContainer()
        setupBalanceCard()
        fetchBalance()
        fetchTransactions()
        setupTransferBtn()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TransactionDetailCell", bundle: nil), forCellReuseIdentifier: "TransactionDetailCell")
        tableView.backgroundColor = .clear
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 16
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setupTransferBtn(){
        transferBtn.setRoundedRed()
        transferBtn.setTitle("MAKE TRANSFER", for: .normal)
        transferBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setupTransactionContainer(){
        transactionContainerView.layer.masksToBounds = false
        transactionContainerView.layer.cornerRadius = 28
        transactionContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        transactionContainerView.backgroundColor = UIColor(displayP3Red: 255 , green: 255, blue: 255, alpha: 0.8)
    }
    
    func setupBalanceCard(){
        balanceCardView.backgroundColor = .clear
        balanceCardView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -16).isActive = true
        balanceCardView.bottomAnchor.constraint(equalTo: transactionContainerView.topAnchor, constant: 32).isActive = true
//        balanceCardView.containerView.frame = balanceCardView.frame
    }
    
    func createLayout()->UICollectionViewLayout{
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 10, right: 16)
        layout.itemSize = CGSize(width: screenWidth*0.85, height: screenHeight / 4)
        return layout
    }
    
    func setupNavBar(){
        navigationItem.hidesBackButton = true
        let logOutBtn = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(logoutTapped))
        navigationItem.setRightBarButton(logOutBtn, animated: true)
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc func logoutTapped(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func fetchTransactions(){
        TransactionApi.getAllTransactions { datas in
            DispatchQueue.main.async {
                self.transactionsPerDate = self.groupPerDate(datas: datas)
                self.tableView.reloadData()
            }
        } failCompletion: { error in
            AlertHelper.shared.showError(title: "Transactions Error", message: error, sender: self)
        }
        
    }
    
    func groupPerDate(datas: [TransactionData])->[TransactionPerDate]{
        var results: [TransactionPerDate] = []
        datas.forEach { data in
            let dateString = DateHelper.getFormattedDate(dateString: data.transactionDate, format: "dd MMM yyyy")
            if let idx = results.firstIndex(where: {$0.formattedDate == dateString}){
                results[idx].detail.append(data)
            }
            else{
                results.append(TransactionPerDate(formattedDate: dateString, detail:[data]))
            }
        }
        return results
    }
    
    func fetchBalance(){
        BalanceApi.getBalance { data in
            DispatchQueue.main.async {
                self.balance = data
                self.balanceCardView.setAccountNo(data.accountNo ?? "")
                //I hope you put Account Holder Name when I fetch Balance Data
                self.balanceCardView.setAccountHolder(UserDefaults.standard.string(forKey: UserDefaultKey.USERNAME)?.capitalized ?? "")
                self.balanceCardView.setBalanceAmount(data.balance!)
            }
        } failCompletion: { error in
            AlertHelper.shared.showError(title: "Balance Error", message: error, sender: self)
        }
    }
    
    @IBAction func transferBtnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: SegueManager.TRANSFER, sender: self)
    }
    
}

extension DashboardViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionsPerDate.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsPerDate[section].detail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionDetailCell", for: indexPath) as! TransactionDetailCell
        let dataPerDate = transactionsPerDate[indexPath.section]
        cell.setupData(detail: dataPerDate.detail[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return transactionsPerDate[section].formattedDate
    }
    
}

extension DashboardViewController : UITableViewDelegate{
    
}
