//
//  FXApiInteractor.swift
//  Currncal
//
//  Created by Tantia, Himanshu on 20/8/20.
//  Copyright © 2020 Himanshu Tantia. All rights reserved.
//

import Foundation
import Combine

protocol FXRates {
    
}

enum Rates : FXRates {
    case wbc([Currency])
}
//The Interactor is a mediator between the presenter and the data. Interactor could have the cache component or deals with other networking aspects of the module and it largely dances to the tunes of the Presenter.
class FXApiInteractor {

// We could be doing some data manipulation if required in this class.
    
    //Backward compatibility can be a expensive. We might potentially write extra lines of code:
    //1. Cater to our existing customers.
    //2. At times its about convenience to avoid change (Why touch when its working? - A: Because we needed to add new stuff)
    //3. Announce that old method/API/etc is being migrated to new one - like Apple does
    
    /*We can also do stuff like
    // @available(iOS 13.0, *)

    and support older version by wrapping it with

    #if canImport(SwiftUI)
     .
     .
     .
    #endif
*/
    
    //https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/index.html
    /// This struct is a entity/model for a given `currency`.
    ///
    /// ```
    /// This is a good place to give an example of how to use this method! We normally use this mark-up for frameworks
    /// ```
    ///
    /// - Warning: the dates are not formated and can be formated using extentions.
    /// - Parameter handler: completionHandler: @escaping (Result<Products, Error>) -> Void.
    /// - Returns: nothing `completionHandler`.
    
    func getAUDExchangeRatesFromAPI(handler completionHandler: @escaping (Result<FXRates, Error>) -> Void) {
        URLSession.shared.request(.rates()) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let resultVal = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
                    let resultVal2 = resultVal?["data"] as? [String : Any]
                    let resultVal3 = resultVal2?["Brands"] as? [String : Any]
                    let resultVal4 = resultVal3?["WBC"] as? [String : Any]
                    let resultVal5 = resultVal4?["Portfolios"] as? [String : Any]
                    let resultVal6 = resultVal5?["FX"] as? [String : Any]
                    let resultVal7 = resultVal6?["Products"] as? Dictionary<String, Any>
                    
                    var array: [Currency] = []
                    
                    for v in resultVal7!.values {
                        let val: [String : Any] = v as! [String : Any]
                        let rates = val["Rates"] as? Dictionary<String, Any>
                        let res = rates?.values.first
                        let d = try JSONSerialization.data(withJSONObject: res as Any, options: .prettyPrinted)
                        let returnVal:Currency = try JSONDecoder().decode(Currency.self, from: d)
                        array.append(returnVal)
                    }
                    
                    completionHandler(.success(Rates.wbc(array)))
                } catch let err {
                    completionHandler(.failure(err))
                }
            }
        }
    }
    
    @available(*, deprecated, message: "See wiki for migrating to 'getAUDExchangeRatesFromAPI'")
    func getAUDExchangeRatesFromInternet(handler completionHandler: @escaping (Result<FXRates, Error>) -> Void) {
        getAUDExchangeRatesFromAPI(handler: completionHandler)
    }
}
