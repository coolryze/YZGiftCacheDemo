//
//  ViewController.swift
//  YZGiftCacheDemo
//
//  Created by heyuze on 2017/5/23.
//  Copyright © 2017年 heyuze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var giftContainerView: GiftContainerView = GiftContainerView()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func setupUI() {
        view.insertSubview(giftContainerView, at: 0)
        
        giftContainerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(89)
            make.centerY.equalTo(self.view)
        }
    }

    
    // MARK: - Action
    
    @IBAction func tt() {
        let gift = Gift()
        gift.user_id = 4
        gift.nickname = "cool"
        gift.header = "http://www.baidu.com"
        gift.level = 4
        gift.gift_ID = 4
        giftContainerView.insertGift(gift: gift)
    }
    
    @IBAction func flower() {
        let gift = Gift()
        gift.user_id = 1
        gift.nickname = "cool"
        gift.header = "http://www.baidu.com"
        gift.level = 1
        gift.gift_ID = 1
        giftContainerView.insertGift(gift: gift)
    }
    
    @IBAction func cucumber() {
        let gift = Gift()
        gift.user_id = 2
        gift.nickname = "HYZ"
        gift.header = "http://www.baidu.com"
        gift.level = 2
        gift.gift_ID = 2
        giftContainerView.insertGift(gift: gift)
    }
    
}

