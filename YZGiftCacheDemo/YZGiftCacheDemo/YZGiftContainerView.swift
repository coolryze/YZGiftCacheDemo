//
//  YZGiftContainerView.swift
//  YZGiftCacheDemo
//
//  Created by heyuze on 16/8/9.
//  Copyright © 2016年 HYZ. All rights reserved.
//

import UIKit

class YZGiftContainerView: UIView {
    
    // 礼物视图数组
    var giftViews: [YZGiftView] = [YZGiftView]()
    // 礼物模型数组
    var gifts: [YZGift] = [YZGift]()

    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        printLog("GiftContainerView deinit")
    }

    
    // MARK: - Set up

    private func setupUI() {
        backgroundColor = UIColor.clear
        
        let giftView1 = YZGiftView()
        giftView1.index = 0
        giftView1.hidenCompleteBlock = { [weak self] giftView in
            guard let strongSelf = self else {
                return
            }
            strongSelf.nextGift(with: giftView)
        }
        let giftView2 = YZGiftView()
        giftView2.index = 1
        giftView2.hidenCompleteBlock = { [weak self] giftView in
            guard let strongSelf = self else {
                return
            }
            strongSelf.nextGift(with: giftView)
        }
        self.addSubview(giftView1)
        self.addSubview(giftView2)
        self.giftViews.append(giftView1)
        self.giftViews.append(giftView2)
    }
    
    
    // MARK: - Func
    
    // 插入礼物
    func insert(gift: YZGift) {
        let giftView = examineGiftView(with: gift)
        if giftView != nil {
            giftView?.shakeAnimation(number: 1)
        } else {
            self.gifts.append(gift)
            let freeGiftViews = examineFreeGiftViews()
            if freeGiftViews.count != 0 {
                guard let giftView = freeGiftViews.first else {
                    return
                }
                let gifts = subarray(with: gift)
                giftView.showGiftView(with: gift, complete: {
                    giftView.shakeAnimation(number: gifts.count)
                })
            }
        }
    }
    
    private func nextGift(with giftView: YZGiftView) {
        if self.gifts.count != 0 {
            guard let gift = self.gifts.first else {
                return
            }
            let gifts = subarray(with: gift)
            giftView.showGiftView(with: gift, complete: {
                giftView.shakeAnimation(number: gifts.count)
            })
        }
    }
    
    // 检测当前是否有同样类型的礼物在展示
    private func examineGiftView(with gift: YZGift) -> YZGiftView? {
        for giftView: YZGiftView in self.giftViews {
            // 如果赠送者相同，且礼物也相同
            if (giftView.gift?.user_id == gift.user_id) && (giftView.gift?.gift_id == gift.gift_id) {
                //当前正在展示动画并且不是隐藏动画
                if (giftView.state != .none) && (giftView.state != .hiding) {
                    return giftView
                }
            }
        }
        return nil
    }
    
    // 检测当前是否有空闲的礼物视图
    private func examineFreeGiftViews() -> [YZGiftView] {
        var freeGiftViews = [YZGiftView]()
        for giftView in self.giftViews {
            if giftView.state == .none {
                freeGiftViews.append(giftView)
            }
        }
        return freeGiftViews
    }
    
    // 取缓存中取出和gift类型相同的礼物
    private func subarray(with gift: YZGift) -> [YZGift] {
        var gifts = [YZGift]()
        var indexArr = [Int]()
        for i in 0..<self.gifts.count {
            let currentGift = self.gifts[i]
            if (currentGift.user_id == gift.user_id) && (currentGift.gift_id == gift.gift_id) {
                gifts.append(currentGift)
                indexArr.append(i)
            }
        }
        for i in indexArr.reversed() {
            self.gifts.remove(at: i)
        }
        return gifts
    }
    
}
