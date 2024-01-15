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
    
    public static let api = PaperMC.APIv2()

    public static let apiV2 = PaperMCAPIClient()

    public static let hanger = HangarAPIClient()

}
