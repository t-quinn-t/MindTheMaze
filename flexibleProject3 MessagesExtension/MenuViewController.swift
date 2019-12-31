//
//  MenuViewController.swift
//  flexibleProject3 MessagesExtension
//
//  Created by Qintu Tao on 2019-04-24.
//  Copyright © 2019 Qintu Tao. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    weak var delegate: MenuViewDelegate?
    
    @IBOutlet weak var inviteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Button Action Here
    @IBAction func onClickSendingText(_ sender: Any) {
        self.delegate?.composeChallenge()
    }
    @IBAction func onClickSendingButton(_ sender: Any) {
        self.delegate?.composeChallenge()
    }
}

protocol MenuViewDelegate: class {
    func composeChallenge()
}
