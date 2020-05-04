//
//  ContentView.swift
//  Despenso
//
//  Created by Eduardo Gutiérrez Silva on 02/05/20.
//  Copyright © 2020 Lalogs. All rights reserved.
//

import SwiftUI

var recorder: Recorder!

func startRecording() {
    recorder.startRecording()
}

func stopRecording() {
    recorder.stopRecording()
}

func stopPlaying() {
    recorder.stopPlaying()
}

func startPlaying() {
    recorder.startPlaying()
}

struct RecordingView: View, RecorderDelegate {
    
    @State var recordingAllowed = false
    
    @State var recording = false
    @State var playing = false
    
    @State var showAlertError = false
    @State var alertError = ""
    
    var body: some View {
        
        VStack {
            Button(action: recording ? stopRecording : startRecording) {
                Text(recording ? "Stop recording" : "Record my list!")
            }
            .disabled(!recordingAllowed || playing)
            .alert(isPresented: $showAlertError) {
                Alert(title: Text("Error getting recording permission"), message: Text(alertError), dismissButton: .default(Text("Ok")))
            }
            
            if !recordingAllowed {
                Text("Please allow microphone permissions to record your list")
                    .multilineTextAlignment(.center)
                    .font(.callout)
                    .padding(.top, 15)
            }
            
            Button(action: playing ? stopPlaying : startPlaying) {
                Text(playing ? "Stop Playing" : "Start Playing")
            }
            .disabled(recording)
            .padding(.top, 20)
        }
        .onAppear {
            recorder = Recorder(delegate: self)
            recorder.setupPermissions()
        }
    }
    
    // MARK: Record Delegate methods
    
    func userPermission(_ sender: Recorder, allowed: Bool) {
        recordingAllowed = allowed
    }
    
    func setupError(_ sender: Recorder, error: String) {
        showAlertError = true
        alertError = error
    }
    
    func recordingStarted(_ sender: Recorder) {
        recording = true
    }
    
    func recordingFinished(_ sender: Recorder, successfully: Bool) {
        recording = false
    }
    
    func recordingErrorDidOccur(_ sender: Recorder, error: String) {
        alertError = error
        showAlertError = true
    }
    
    func playingStarted(_ sender: Recorder) {
        playing = true
    }
    
    func playingFinished(_ sender: Recorder, successfully: Bool) {
        playing = false
    }
    
    func playingErrorDidOccur(_ sender: Recorder, error: String) {
        alertError = error
        showAlertError = true
    }
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView()
    }
}
