//
//  ContentView.swift
//  Despenso
//
//  Created by Eduardo Gutiérrez Silva on 02/05/20.
//  Copyright © 2020 Lalogs. All rights reserved.
//

import SwiftUI

func recordAudio() {
    
}

var recorder: Recorder!

struct RecordingView: View, RecorderDelegate {
    @State var recordingAllowed = false
    @State var showAlertError = false
    @State var alertError = ""
    
    func userPermission(_ sender: Recorder, allowed: Bool) {
        recordingAllowed = allowed
    }
    
    func setupError(_ sender: Recorder, error: String) {
        showAlertError = true
        alertError = error
    }
    
    var body: some View {
        
        VStack {
            Button(action: recordAudio) {
                Text("Record my list!")
            }
            .disabled(!recordingAllowed)
            .onAppear {
                recorder = Recorder(delegate: self)
                recorder.setupPermissions()
            }
            .alert(isPresented: $showAlertError) {
                Alert(title: Text("Error getting recording permission"), message: Text(alertError), dismissButton: .default(Text("Ok")))
            }
            
            if !recordingAllowed {
                Text("Please allow microphone permissions to record your list")
                    .multilineTextAlignment(.center)
                    .font(.callout)
                    .padding(.top, 15)
            }
        }
    }
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView()
    }
}
