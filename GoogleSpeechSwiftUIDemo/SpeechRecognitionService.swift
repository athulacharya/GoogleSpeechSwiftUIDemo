//
// Copyright 2016 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import Foundation
import googleapis

let HOST = "speech.googleapis.com"

typealias SpeechRecognitionCompletionHandler = (StreamingRecognizeResponse?, NSError?) -> (Void)

class SpeechRecognitionService {
    var sampleRate: Int = 16000
    private var streaming = false
    
    private var client : Speech!
    private var writer : GRXBufferedPipe!
    private var call : GRPCProtoCall!
    
    private let apiKey: String = {
        do {
            guard let url = Bundle.main.url(forResource: "apikey", withExtension: "json") else { throw URLError(.badURL) }
            let file = try FileHandle(forReadingFrom: url)
            let apiKey = try JSONDecoder().decode(String.self, from: file.availableData)
            return apiKey
        } catch {
            fatalError("Failed to load key file.")
        }
    }()

    static let sharedInstance = SpeechRecognitionService()
    
    func streamAudioData(_ audioData: NSData, completion: @escaping SpeechRecognitionCompletionHandler) {
        if (!streaming) {
            // if we aren't already streaming, set up a gRPC connection
            client = Speech(host:HOST)
            writer = GRXBufferedPipe()
            call = client.rpcToStreamingRecognize(withRequestsWriter: writer,
                                                  eventHandler:
                                                    { (done, response, error) in
                completion(response, error as? NSError)
            })
            // authenticate using an API key obtained from the Google Cloud Console
            call.requestHeaders.setObject(NSString(string:apiKey),
                                          forKey:NSString(string:"X-Goog-Api-Key"))
            // if the API key has a bundle ID restriction, specify the bundle ID like this
            call.requestHeaders.setObject(NSString(string:Bundle.main.bundleIdentifier!),
                                          forKey:NSString(string:"X-Ios-Bundle-Identifier"))
            
            print("HEADERS:\(call.requestHeaders)")
            
            call.start()
            streaming = true
            
            // set up hints
            let speechContext = SpeechContext()
            speechContext.phrasesArray = ["jurisdiction", "extrapolate"]
            
            // send an initial request message to configure the service
            let recognitionConfig = RecognitionConfig()
            recognitionConfig.encoding =  .linear16
            recognitionConfig.sampleRateHertz = Int32(sampleRate)
            recognitionConfig.languageCode = "en-US"
            recognitionConfig.maxAlternatives = 30
            recognitionConfig.enableWordTimeOffsets = true
            recognitionConfig.speechContextsArray = [speechContext]
            
            let streamingRecognitionConfig = StreamingRecognitionConfig()
            streamingRecognitionConfig.config = recognitionConfig
            streamingRecognitionConfig.singleUtterance = false
            streamingRecognitionConfig.interimResults = true
            
            let streamingRecognizeRequest = StreamingRecognizeRequest()
            streamingRecognizeRequest.streamingConfig = streamingRecognitionConfig
            
            writer.writeValue(streamingRecognizeRequest)
        }
        
        // send a request message containing the audio data
        let streamingRecognizeRequest = StreamingRecognizeRequest()
        streamingRecognizeRequest.audioContent = audioData as Data
        writer.writeValue(streamingRecognizeRequest)
    }
    
    func stopStreaming() {
        if (!streaming) {
            return
        }
        writer.finishWithError(nil)
        streaming = false
    }
    
    func isStreaming() -> Bool {
        return streaming
    }
    
}

