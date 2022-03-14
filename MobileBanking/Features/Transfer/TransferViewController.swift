//
//  TransferViewController.swift
//  MobileBanking
//
//  Created by Karin Lim on 14/03/22.
//

import UIKit

class TransferViewController: UIViewController {
    
    
    let pageTitle = "Transfer"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = pageTitle
    }

}
