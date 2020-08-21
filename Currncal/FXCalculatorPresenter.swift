//
//  FXCalculatorPresenter.swift
//  Currncal
//
//  Created by Tantia, Himanshu on 20/8/20.
//  Copyright © 2020 Himanshu Tantia. All rights reserved.
//

import UIKit

class FXCalculatorPresenter {
    
    private weak var viewController: ViewController?
    private let interactor: FXApiInteractor
    
    public var viewModel: FXCalculatorViewModel!
    
    private var currencyData: [Currency] = [] {
        didSet {
            refreshTableView()
        }
    }
    
    init(withViewController controller: ViewController) {
        self.viewController = controller
        interactor = FXApiInteractor()
        viewModel = FXCalculatorViewModel(withPresenter: self)
    }
    
    private func getAndSetAUDExchangeRates() {
        interactor.getAUDExchangeRatesFromAPI { res in
            switch res {
            case .success(let data):
                switch data as? Rates {
                case .wbc(let wbcRates):
                    self.currencyData = wbcRates
                case .none: break
                }
            case .failure(let error):
               print(error)
            }
        }
    }
    
    func asynchronouslyRefreshViewWithFxData() {
        getAndSetAUDExchangeRates()
    }
    
    func refreshTableView() {
        DispatchQueue.main.async {
            self.viewController?.currencySelectionTable.reloadData()
        }
    }
    
    //keeping two seperate fuctions here can help us change the view behaviour without having to change the view
    func didSelectRowAt(indexPath: IndexPath, withInput userInput: String?) {
        handleSelection(indexPath: indexPath, withInput: userInput)
    }
    
    //keeping two seperate fuctions here can help us change the view behaviour without having to change the view
    func accessoryButtonTappedForRowWith(indexPath: IndexPath, withInput userInput: String?) {
        handleSelection(indexPath: indexPath, withInput: userInput)
    }
    
    //For now I'm wanting to have the same behaviour for selection. I could want to change this and I can do so here without impacting the view
    func handleSelection(indexPath: IndexPath, withInput userInput: String?) {
        let o = objectAtIndex(indexPath.row)
        var input: Double = viewModel.defaultConversionValueInAUD
        if (viewModel.userEnteredValueIsValid(userInput)) {
            input = convertStringInputToDouble(userInput!)
        }
        viewController?.showAlertView(title: "UserInput: \(input)", message: o?.calculateRates(forInput: input))
    }
    
    private func convertStringInputToDouble(_ stringNumber: String) -> Double {
        return Double(String(stringNumber)) ?? viewModel.defaultConversionValueInAUD
    }
}

extension FXCalculatorPresenter {
    
    var numberOfRowsForCurrencyTableView: Int {
        return currencyData.count
    }
    
    func objectAtIndex(_ index: Int) -> Currency? {
        if !currencyData.isEmpty && currencyData.count > index {
            return currencyData[index]
        }
        return nil
    }
}
