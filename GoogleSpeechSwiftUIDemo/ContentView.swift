//
//  ContentView.swift
//  GoogleSpeechSwiftUIDemo
//
//  Created by Athul Acharya on 5/24/23.
//

import SwiftUI
import googleapis
import AVFoundation

struct ContentView: View {
    @State var isRecording = false
    @StateObject var speechManager = GoogleSpeechManager()
    @State var transcripts: [String] = []
    
    var body: some View {
        VStack {
            Button(action: run, label: { Text("Run") })
            
            ForEach($transcripts, id: \.self) { $tr in
                TextEditor(text: $tr)
            }
            
            TextEditor(text: $speechManager.transcript)
        }
        .padding()
        .onChange(of: speechManager.isFinal) { isFinal in
            if isFinal {
                transcripts.append(speechManager.getPrevTranscript())
            }
        }
    }
    
    func run() {
        isRecording = !isRecording
        
        if isRecording {
            speechManager.startRecording()
            print("Recording ...")
        } else {
            speechManager.stopRecording()
            print("Recording stopped.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
