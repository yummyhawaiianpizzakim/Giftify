//
//  Vision.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/28.
//

import Foundation
import UIKit
import VisionKit
import Vision
import CoreML
import RxSwift
import RxRelay

class Vision {
    
    let testText = BehaviorRelay<[String]>(value: [])
    let filteredText = BehaviorRelay<[String]>(value: [])
    let testBarcode = BehaviorRelay<String>(value: "")
        
    func recognizeText(data: Data?){
        guard let data = data else { return }
        let image = UIImage(data: data, scale: 0.9)
        guard let cgImage = image?.cgImage else {
            fatalError("could not get image")
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest{ [weak self]request, error in
            
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else{
                return
            }
            
            let testText = observations.compactMap { observer in
                observer.topCandidates(1).first?.string
            }
            let lines = observations.map { $0.topCandidates(1).first?.string }.compactMap { $0 }.filter { !$0.isEmpty }
            print(lines)
            self?.filteredText.accept(lines)
            print(testText)
            self?.testText.accept(testText)
            print(error)
//            let text = observations.compactMap({
//                $0.topCandidates(1).first?.string
//            }).joined(separator: "\n")
//
//            DispatchQueue.main.async {
//                self?.label.text = text
//            }
        }
   
        if #available(iOS 16.0, *) {
            let revision3 = VNRecognizeTextRequestRevision3
            request.revision = revision3
            request.recognitionLevel = .accurate
//            request.recognitionLanguages =  [commonVisionLang]
            request.recognitionLanguages =  ["ko-KR", "en-US"]

            request.usesLanguageCorrection = true

//            do {
//                var possibleLanguages: Array<String> = []
//                possibleLanguages = try request.supportedRecognitionLanguages()
//                print(possibleLanguages)
//            } catch {
//                print("Error getting the supported languages.")
//            }
        } else {
            // Fallback on earlier versions
            request.recognitionLanguages =  ["en-US"]
            request.usesLanguageCorrection = true
        }
    
        do{
            try handler.perform([request])
        } catch {
//            label.text = "\(error)"
            print(error)
        }
    }
    
    func recognizeBarcode(data: Data?){
        guard let data = data else { return }
        let image = UIImage(data: data, scale: 0.9)
        guard let cgImage = image?.cgImage else {
            fatalError("could not get image")
        }
        
//        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage,
//                                                        orientation: .up,
//                                                        options: [:])
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        let requset = VNDetectBarcodesRequest { [weak self] request, error in
//            guard let observations = request.results as? [VNBarcodeObservation],
//                  error == nil else { return }
//
//
            guard let observations = request.results as? [VNDetectedObjectObservation] else {
                return
            }
            
            let result = (observations.first as? VNBarcodeObservation)?.payloadStringValue
//            completion(result)
            self?.testBarcode.accept(result!)
//            print(self?.testBarcode.value)
        }
        
        requset.symbologies = [.code128]
        requset.preferBackgroundProcessing = true
//        requset
   
        if #available(iOS 16.0, *) {
            let revision3 = VNDetectBarcodesRequestRevision2
            requset.revision = revision3
            
        }
        
        do{
            try imageRequestHandler.perform([requset])
        } catch {
//            label.text = "\(error)"
            print(error)
        }
    }
}
