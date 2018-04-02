//
//  Speed.swift
//  Dreamline
//
//  Created by BeeDream on 3/19/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @CLEANUP: Probably don't need to explicitly number cases
//           I think by default they are numbered like this
enum Speed: Int {
    case mach1 = 0
    case mach2 = 1
    case mach3 = 2
    case mach4 = 3
    case mach5 = 4
//    case mach6 = 5
//    case mach7 = 6
//    case mach8 = 7
//    case mach9 = 8
}

// @HACK: This is super awkward
//        Some pieces of code need to know how many
//        cases there are, but there's no built-in
//        way to determine that
extension Speed {
    static let count: Int = 6 // @HARDCODED
}
