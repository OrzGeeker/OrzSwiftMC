//
//  File.swift
//  
//
//  Created by wangzhizhou on 2021/12/25.
//

import PaperMCAPI
import HangarAPI

/// [PaperMC](https://papermc.io/)
public struct PaperMC {
    
    public static let api = APIv2()

    public static let apiV2 = PaperMCAPI()

    public static let hanger = HangarAPI()

}
