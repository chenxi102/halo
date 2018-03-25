

//
//  F8PreViewModel.swift
//  detuf8
//
//  Created by Seth on 2018/1/18.
//  Copyright © 2018年 detu. All rights reserved.
//

import UIKit
class F8PreViewModel: NSObject {
    
    func getCameraState() {
        F8SocketAPI.shareInstance().getRecordState(result: {(_ m: F8SocketModel) -> Void in
            if m.rval == 0 {
                F8SocketAPI.shareInstance().getRecordTime(result: {(_ m: F8SocketModel) -> Void in
                    } as! socketDataCallback)
            }
            } as! socketDataCallback)
    }
    
    
}
