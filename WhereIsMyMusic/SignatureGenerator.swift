//
//  SignatureGenerator.swift
//  SignatureGenerator
//
//  Created by Gordon Choi on 2021/09/14.
//

import Foundation
import ShazamKit

@available(iOS 15.0, *)
struct SignatureGenerator {
    
    // Return the signature of an audio file.
    static func generateSignature(from audioURL: URL) -> SHSignature? {
        // Step 1.
        // Create an audio format that's compatible with ShazamKit.
        guard let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1) else {
            // Handle an error in creating the audio format.
            return nil
        }
        
        // Create a signature generator to generate the final signature.
        let signatureGenerator = SHSignatureGenerator()
        
        // Create an object for reading the audio file.
        guard let audioFile = try? AVAudioFile(forReading: audioURL) else { return nil }
        
        // Step 2.
        // Convert the audio to a supported format.
        convert(audioFile: audioFile, outputFormat: audioFormat) { buffer in
            do {
                // Step 3.
                // Append portions of the converted audio to the signature generator.
                try? signatureGenerator.append(buffer, at: nil)
            } catch {
                // Handle an error generating the signature.
                return
            }
        }
        
        // Step 4.
        // Generate the signature.
        return signatureGenerator.signature()
    }
    
    // Convert an audio file to a new format one chunk at a time.
    private static func convert(audioFile: AVAudioFile,
                        outputFormat: AVAudioFormat,
                        processConvertedBlock: (AVAudioPCMBuffer) -> Void) {
        // Set the size of the conversion buffer.
        let frameCount = AVAudioFrameCount(
            (1024 * 64) / (audioFile.processingFormat.streamDescription.pointee.mBytesPerFrame)
        )
        // Calculate the number of frames for the output buffer.
        let outputFrameCapacity = AVAudioFrameCount(
            round(Double(frameCount) * (outputFormat.sampleRate / audioFile.processingFormat.sampleRate))
        )
        
        // Create the input and output buffers for converting the file.
        guard let inputBuffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: frameCount),
              let outputBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: outputFrameCapacity/10) else {
                  return
              }
        
        // Create the format for the converter.
        guard let converter = AVAudioConverter(from: audioFile.processingFormat, to: outputFormat) else {
            return
        }
        
        // Code to convert the file goes here. See the next listing.
        // Convert the audio file.
        while true {
            // Convert frames in the input buffer, writing them to the output buffer.
            let status = converter.convert(to: outputBuffer, error: nil) { inNumPackets, outStatus in
                do {
                    // Read a frame from the audio file into the input buffer.
                    try audioFile.read(into: inputBuffer)
                    outStatus.pointee = .haveData
                    return inputBuffer
                } catch {
                    // Check if it's the end of the file or if an error occurred.
                    if audioFile.framePosition >= audioFile.length {
                        outStatus.pointee = .endOfStream
                        return nil
                    } else {
                        outStatus.pointee = .noDataNow
                        return nil
                    }
                }
            }
            
            switch status {
            case .error:
                // An error occurred during conversion; handle the error.
                return
                
            case .endOfStream:
                // All of the input is converted.
                return
                
            case .inputRanDry:
                // Some data was converted, but no more is available.
                processConvertedBlock(outputBuffer)
                return
                
            default:
                processConvertedBlock(outputBuffer)
            }
            
            // Reset the size of the buffers.
            inputBuffer.frameLength = 0
            outputBuffer.frameLength = 0
        }
    }
}
