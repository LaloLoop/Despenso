//
//  UserRespondedWithMock.swift
//  DespensoTests
//
//  Created by Eduardo Gutiérrez Silva on 03/05/20.
//  Copyright © 2020 Lalogs. All rights reserved.
//

import AVFoundation
@testable import Despenso

class UserRespondedWithMock: AudioSessionProtocol {
    let userSelection: Bool
    
    init(_ selection: Bool) {
        self.userSelection = selection
    }
    
    func requestRecordPermissionWith(_ category: AVAudioSession.Category, mode: AVAudioSession.Mode, active: Bool, _ response: @escaping PermissionBlock) throws {
        
        response(self.userSelection)
    }
}
