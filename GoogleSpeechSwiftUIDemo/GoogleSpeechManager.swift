//
//  GoogleSpeechManager.swift
//  GoogleSTTTest
//
//  Created by Athul Acharya on 5/22/23.
//

import SwiftUI
import googleapis

class GoogleSpeechManager: ObservableObject {
    @Published var transcript = ""
    var prevTranscript = ""
    @Published var isFinal = false
    
    var audioData: NSMutableData!
    let SAMPLE_RATE = 16000
    
    func startRecording() {
        audioData = NSMutableData()
        _ = AudioController.sharedInstance.prepare(specifiedSampleRate: SAMPLE_RATE, processSampleDataCallback: processSampleData)
        SpeechRecognitionService.sharedInstance.sampleRate = SAMPLE_RATE
        _ = AudioController.sharedInstance.start()
    }
    
    func stopRecording() {
        _ = AudioController.sharedInstance.stop()
        SpeechRecognitionService.sharedInstance.stopStreaming()
    }
    
    func getPrevTranscript() -> String {
        isFinal = false
        return prevTranscript
    }
    
    func processSampleData(_ data: Data) -> Void {
        audioData.append(data)
        
        // We recommend sending samples in 100ms chunks
        let chunkSize : Int /* bytes/chunk */ = Int(0.1 /* seconds/chunk */
                                                    * Double(SAMPLE_RATE) /* samples/second */
                                                    * 2 /* bytes/sample */);
        
        if (audioData.length > chunkSize) {
            SpeechRecognitionService.sharedInstance.streamAudioData(audioData,
                                                                    completion:
                                                                        { [weak self] (response, error) in
                guard let strongSelf = self else {
                    return
                }
                
                if let error = error {
                    strongSelf.transcript = error.localizedDescription
                } else if let response = response {
                    print(response)
                    if let result = response.resultsArray[0] as? StreamingRecognitionResult {
                        if let alternative = result.alternativesArray[0] as? SpeechRecognitionAlternative {
                            strongSelf.transcript = alternative.transcript
                            
                            if result.isFinal {
                                strongSelf.prevTranscript = strongSelf.transcript
                                strongSelf.transcript = ""
                                strongSelf.isFinal = true
                            }
                        }
                    }
                }
            })
            self.audioData = NSMutableData()
        }
    }
}
