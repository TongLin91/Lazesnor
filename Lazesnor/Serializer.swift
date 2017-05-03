//
//  Serializer.swift
//  Lazesnor
//
//  Created by Tong Lin on 5/1/17.
//  Copyright © 2017 TongLin91. All rights reserved.
//

import Foundation

protocol Request {
    func request(endPoint: URL, completion: @escaping ((Data?)->Void))
}
