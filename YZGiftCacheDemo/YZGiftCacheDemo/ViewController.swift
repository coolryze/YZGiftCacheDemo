//
//  ViewController.swift
//  YZGiftCacheDemo
//
//  Created by heyuze on 2017/5/23.
//  Copyright © 2017年 heyuze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var giftContainerView: YZGiftContainerView = YZGiftContainerView()
    

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
        let gift = YZGift()
        gift.user_id = 1
        gift.nickname = "cool"
        gift.header = "jinxC"
        gift.level = 1
        gift.gift_id = 0
        giftContainerView.insert(gift: gift)
    }
    
    @IBAction func flower() {
        let gift = YZGift()
        gift.user_id = 2
        gift.nickname = "hyz"
        gift.header = "cdl"
        gift.level = 1
        gift.gift_id = 1
        giftContainerView.insert(gift: gift)
    }
    
    @IBAction func cucumber() {
        let gift = YZGift()
        gift.user_id = 3
        gift.nickname = "ryze"
        gift.header = "miao"
        gift.level = 1
        gift.gift_id = 2
        giftContainerView.insert(gift: gift)
    }
    
}

