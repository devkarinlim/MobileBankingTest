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
    
    var balance: BalanceData?
    var transactionsPerDate: [TransactionPerDate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupCollectionView()
        setupTransactionContainer()
        setupBalanceCard()
        fetchBalance()
        fetchTransactions()
        setupTransferBtn()
        
        // Do any additional setup after loading the view.
    }
    
    func setupTransferBtn(){
        transferBtn.setRoundedRed()
        transferBtn.setTitle("MAKE TRANSFER", for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setupTransactionContainer(){
        transactionContainerView.layer.masksToBounds = false
        transactionContainerView.layer.cornerRadius = transactionContainerView.frame.width/8
        transactionContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setupBalanceCard(){
        balanceCardView.backgroundColor = .clear
//        balanceCardView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -16).isActive = true
        balanceCardView.bottomAnchor.constraint(equalTo: transactionContainerView.topAnchor, constant: 32).isActive = true
        balanceCardView.containerView.sizeToFit()
//        balanceCardView.containerView.frame = balanceCardView.frame
    }
    
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createLayout()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        collectionView.register(UINib(nibName: "TransactionCell", bundle: .main), forCellWithReuseIdentifier: "TransactionCell")
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
                self.collectionView.reloadData()
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
    
    
}

extension DashboardViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transactionsPerDate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        let dataPerDate = transactionsPerDate[indexPath.row]
        cell.setupData(transactionPerDate: dataPerDate)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
}

extension DashboardViewController : UICollectionViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       
    }
}
