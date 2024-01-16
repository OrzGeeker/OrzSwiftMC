//
//  Shell+Utils.swift
//
//
//  Created by joker on 2024/1/16.
//

import Foundation


public extension Shell {

    @discardableResult
    /// 结束进程
    /// - Parameter pid: 进程PID
    /// - Returns: 是否结束成功
    static func kill(with pid: String) async -> Bool {

        let ret = await run(path: "/bin/kill", args: ["-9", pid])
        
        return ret
    }

}
