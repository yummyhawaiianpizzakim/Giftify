//
//  TextRecognizer.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/29.
//

import Foundation
import UIKit
import Vision

class TextRecognizer {
    func recognize(bitmap: UIImage, completion: @escaping ([String]) -> Void) {
        // UIImage를 VNImageRequestHandler에 맞는 형태로 변환
        guard let cgImage = bitmap.cgImage else {
            print("Failed to get CGImage.")
            return
        }
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        // Text recognition 요청 생성 및 처리
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print("Error in text recognition: \(error.localizedDescription)")
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("Failed to get recognized text.")
                return
            }

            // 결과를 라인별로 추출하고, 빈 라인은 제거
            let lines = observations.map { $0.topCandidates(1).first?.string }.compactMap { $0 }.filter { !$0.isEmpty }
            completion(lines)
        }
        request.recognitionLevel = .accurate

        do {
            try requestHandler.perform([request])
        } catch {
            print("Failed to perform request: \(error.localizedDescription)")
        }
    }
}

struct BarcodeParserResult {
    let barcode: String
    let barcodeFiltered: [String]
}

class BarcodeParser {
    private let barcodeFilterRegex: [NSRegularExpression] = [
        try! NSRegularExpression(pattern: "\\b(\\d{4}[- ]+\\d{4}[- ]+\\d{4}[- ]+\\d{4}[- ]+\\d{4}[- ]+\\d{4})\\b"),
        try! NSRegularExpression(pattern: "\\b(\\d{4}[- ]+\\d{4}[- ]+\\d{4}[- ]+\\d{4}[- ]+\\d{4}[- ]+\\d{2})\\b"),
        try! NSRegularExpression(pattern: "\\b(\\d{4}[- ]+\\d{4}[- ]+\\d{4}[- ]+\\d{4}[- ]+\\d{4})\\b"),
        try! NSRegularExpression(pattern: "\\b(\\d{4}[- ]+\\d{4}[- ]+\\d{4}[- ]+\\d{4}[- ]+\\d{2})\\b"),
        try! NSRegularExpression(pattern: "\\b(\\d{4}[- ]+\\d{4}[- ]+\\d{4}[- ]+\\d{4})\\b"),
        try! NSRegularExpression(pattern: "\\b(\\d{4}[- ]+\\d{4}[- ]+\\d{4}[- ]+\\d{2})\\b"),
        try! NSRegularExpression(pattern: "\\b(\\d{4}[- ]+\\d{4}[- ]+\\d{4})\\b"),
        
        try! NSRegularExpression(pattern: "\\b(\\d{4}\\s+\\d{4}\\s+\\d{4}\\s+\\d{4}\\s+\\d{4}\\s+\\d{4})\\b"),
        try! NSRegularExpression(pattern: "\\b(\\d{4}\\s+\\d{4}\\s+\\d{4}\\s+\\d{4}\\s+\\d{4}\\s+\\d{2})\\b"),
        try! NSRegularExpression(pattern: "\\b(\\d{4}\\s+\\d{4}\\s+\\d{4}\\s+\\d{4}\\s+\\d{4})\\b"),
        try! NSRegularExpression(pattern: "\\b(\\d{4}\\s+\\d{4}\\s+\\d{4}\\s+\\d{4}\\s+\\d{2})\\b"),
        try! NSRegularExpression(pattern: "\\b(\\d{4}\\s+\\d{4}\\s+\\d{4}\\s+\\d{4})\\b"),
        try! NSRegularExpression(pattern: "\\b(\\d{4}\\s+\\d{4}\\s+\\d{4}\\s+\\d{2})\\b"),
        try! NSRegularExpression(pattern: "\\b(\\d{4}\\s+\\d{4}\\s+\\d{4})\\b"),

        try! NSRegularExpression(pattern: "\\b(\\d{16})\\b"),
        try! NSRegularExpression(pattern: "\\b(\\d{14})\\b"),
        try! NSRegularExpression(pattern: "\\b(\\d{12})\\b")
    ]

    func parseBarcode(inputs: [String]) -> BarcodeParserResult {
        var barcode = ""
        var barcodeFiltered: [String] = []
        
        for text in inputs {
            var found: NSTextCheckingResult?
            
            for regex in barcodeFilterRegex {
                let matches = regex.matches(in: text, range: NSRange(location: 0, length: text.utf16.count))
                
                if let firstMatch = matches.first {
                    found = firstMatch
                    break
                }
            }
            
            if let found = found, let range = Range(found.range(at: 1), in: text) {
                if barcode.isEmpty {
                    barcode = String(text[range]).filter { $0.isNumber }
                }
            } else {
                barcodeFiltered.append(text)
            }
        }
        
        return BarcodeParserResult(barcode: barcode, barcodeFiltered: barcodeFiltered)
    }
}
//
//class GifticonRecognizer {
//    private let barcodeParser = BarcodeParser()
//    private let expiredParser = ExpiredParser()
//    private let balanceParser = BalanceParser()
//
//    private let textRecognizer = TextRecognizer()
//
//    private let templateRecognizerList: [TemplateRecognizer] = [
//        KakaoRecognizer(),
//        SyrupRecognizer(),
//        GiftishowRecognizer(),
//        SmileConRecognizer()
//    ]
//
//    private func getTemplateRecognizer(inputs: [String]) -> TemplateRecognizer? {
//        return templateRecognizerList.first {
//            $0.match(inputs: inputs)
//        }
//    }
//
//    func recognize(bitmap: UIImage, completion: @escaping (GifticonRecognizeInfo) -> ()) {
//        DispatchQueue.global(qos: .background).async {
//            let inputs = self.textRecognizer.recognize(bitmap: bitmap)
//            let barcodeResult = self.barcodeParser.parseBarcode(inputs: inputs)
//            let expiredResult = self.expiredParser.parseExpiredDate(inputs: barcodeResult.filtered)
//            var info = GifticonRecognizeInfo(candidate: expiredResult.filtered)
//            self.getTemplateRecognizer(inputs: info.candidate)?.run {
//                info = $0.recognize(bitmap: bitmap, candidate: info.candidate)
//            }
//            let balanceResult = self.balanceParser.parseCashCard(inputs: info.candidate)
//            let finalInfo = info.copy(
//                barcode: barcodeResult.barcode,
//                expiredAt: expiredResult.expired,
//                isCashCard: balanceResult.balance > 0,
//                balance: balanceResult.balance
//            )
//            DispatchQueue.main.async {
//                completion(finalInfo)
//            }
//        }
//    }
//}
