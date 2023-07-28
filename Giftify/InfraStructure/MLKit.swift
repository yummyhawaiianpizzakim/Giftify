//
//  MLKit.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/26.
//

import Foundation
//import MLKitVision
//import MLKitTextRecognitionKorean
import UIKit
//import MLImage
import RxSwift
import RxRelay
import AVFoundation

class MLKit {
    let text = BehaviorRelay<[String]>(value: [])
//
////    func reconizeTextKorean() -> Observable<String> {
////        return Observable<String>.create {[weak self] observer in
////            guard let self = self else { return Disposables.create() }
////
////            let koreanOptions = KoreanTextRecognizerOptions()
////            let koreanTextRecognizer = TextRecognizer.textRecognizer(options: koreanOptions)
////            let testImage = UIImage(named: "testImageBBQ")
////            let visionImage = VisionImage(image: testImage!)
////            visionImage.orientation = self.imageOrientation(deviceOrientation: UIDevice.current.orientation, cameraPosition: .back)
////
////            koreanTextRecognizer.process(visionImage) { features, error in
////                koreanTextRecognizer.process(visionImage) { result, error in
////                    guard error == nil, let result = result else {
////                        // Error handling
////                        print("Error")
//////                        observer.onError(error)
////                        return
////                    }
////                    let resultText = result.text
////                    DispatchQueue.main.async {
//////                        self.label.text = resultText
////                        observer.onNext(resultText)
////                    }
////                }
////            }
////            observer.onCompleted()
////            return Disposables.create()
////        }
////    }
//
//    func reconizeTextKorean() {
//
//        let koreanOptions = KoreanTextRecognizerOptions()
//        let koreanTextRecognizer = TextRecognizer.textRecognizer(options: koreanOptions)
//        let testImage = UIImage(named: "testImageBBQ")
//        let visionImage = VisionImage(image: testImage!)
//        visionImage.orientation = self.imageOrientation(deviceOrientation: UIDevice.current.orientation, cameraPosition: .back)
//
//        koreanTextRecognizer.process(visionImage) {[weak self] features, error in
//            guard let self = self else { return }
//            koreanTextRecognizer.process(visionImage) { result, error in
//                guard error == nil, let result = result else {
//                    // Error handling
//                    print("Error")
//                    //                        observer.onError(error)
//                    return
//                }
////                let resultText = result.text
//                let blocksTexts = result.blocks.map { textBlock in
//                    return textBlock.text
//                }
////                for block in result.blocks {
////                    print( block.text)
////
////                }
//
//                self.text.accept(blocksTexts)
//                DispatchQueue.main.async {
////                    self.text.accept(blocksTexts)
//                }
//            }
//        }
//
//    }
//
//    func imageOrientation(
//        deviceOrientation: UIDeviceOrientation,
//        cameraPosition: AVCaptureDevice.Position
//    ) -> UIImage.Orientation {
//        switch deviceOrientation {
//        case .portrait:
//            return cameraPosition == .front ? .leftMirrored : .right
//        case .landscapeLeft:
//            return cameraPosition == .front ? .downMirrored : .up
//        case .portraitUpsideDown:
//            return cameraPosition == .front ? .rightMirrored : .left
//        case .landscapeRight:
//            return cameraPosition == .front ? .upMirrored : .down
//        case .faceDown, .faceUp, .unknown:
//            return .up
//        @unknown default:
//            fatalError()
//        }
//    }
}
