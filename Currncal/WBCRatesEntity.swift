//
//  WBCRatesEntity.swift
//  Currncal
//
//  Created by Tantia, Himanshu on 20/8/20.
//  Copyright © 2020 Himanshu Tantia. All rights reserved.
//

import Foundation

//https://developer.apple.com/documentation/swift/swift_standard_library/encoding_decoding_and_serialization
//We can use the CodingKey protocol to define custom coding keys


//https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/index.html
/// This struct is a entity/model for a given `currency`.
///
/// ```
/// implement date formatters !
/// ```
///
/// - Warning: the dates are not formated and can be formated using extentions.
/// - Parameter subject: The subject to be welcomed.
/// - Returns: A hello string to the `subject`.

struct Currency : Codable {
    let currencyCode: String
    let currencyName: String
    let country: String
    let buyTT: String
    let sellTT: String
    let buyTC: String
    let buyNotes: String
    let sellNotes: String
    let SpotRate_Date_Fmt: String //"20200818"
    let effectiveDate_Fmt: String //"20200818T075101,02+10:00"
    let updateDate_Fmt: String //"20200818T075101,02+10:00"
    let LASTUPDATED: String //"07:08 AM 18 Aug 2020"
}

extension Currency : CustomDebugStringConvertible {
    var debugDescription: String {
        var str = "Country: " + self.country + "\n"
        str += "Currency Name: " + self.currencyName + "\n"
        str += "Currency Code: " + self.currencyCode + "\n"
        str += "BuyTT: " + self.buyTT + "\n"
        str += "BuyTC: " + self.buyTC + "\n"
        str += "SellTT: " + self.sellTT + "\n"
        str += "BuyNotes: " + self.buyNotes + "\n"
        str += "SellNotes: " + self.sellNotes + "\n"
        return str
    }
}

extension Currency {
    func calculateRates(forInput val: Double) -> String {
        
        var str = "Country: " + self.country + "\n"
        str += "Currency Name: " + self.currencyName + "\n"
        str += "Currency Code: " + self.currencyCode + "\n"
        if let btt = isNumber(self.buyTT) {
            str += "BuyTT: \(btt * val) \n"
        }
        if let btc = isNumber(self.buyTC) {
            str += "BuyTC: \(btc * val) \n"
        }
        if let stt = isNumber(self.sellTT) {
            str += "SellTT: \(stt * val) \n"
        }
        str += "BuyNotes: " + self.buyNotes + "\n"
        str += "SellNotes: " + self.sellNotes + "\n"
        return str
    }
    
    private func isNumber(_ string: String?) -> Double? {
        guard let strv = string, !strv.isEmpty else { return nil }
        return Double(strv)
    }
}
