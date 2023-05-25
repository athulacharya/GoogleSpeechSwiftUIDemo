# Google Speech-to-Text Streaming Demo — SwiftUI

This app demonstrates how to use Google's Speech-to-Text API (v1) in a SwiftUI app. 
It is based on Google's demo code available [here](https://github.com/GoogleCloudPlatform/ios-docs-samples/tree/master/speech/Swift/Speech-gRPC-Streaming). 
Google's demo hasn't been updated in years and no longer builds, so I forked it to bring it up-to-date. 
This code builds in Xcode 14.3 with an iOS 16.4 target.

## Prerequisites
- An API key for the Cloud Speech API (get it [here](https://cloud.google.com/speech-to-text/docs/before-you-begin) if you don't have one already)
- A macOS machine
- Xcode 14.3 or later
- Cocoapods

## Quickstart
- Clone this repo and `cd` into this directory
- edit `GoogleSpeechSwiftUIDemo/Resources/apikey.json` to contain your API key
- Run `pod install`
- Open `GoogleSpeechSwiftUIDemo.xcworkspace`
- Build & run
