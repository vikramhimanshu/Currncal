//
//  ViewController.swift
//  Currncal
//
//  Created by Tantia, Himanshu on 20/8/20.
//  Copyright © 2020 Himanshu Tantia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currencySelectionTable: UITableView!
    var inputValueText: UITextField?
    
    private var presenter: FXCalculatorPresenter?
    private var viewModel: FXCalculatorViewModel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        presenter = FXCalculatorPresenter(withViewController: self)
        viewModel = presenter?.viewModel
        presenter?.asynchronouslyRefreshViewWithFxData()
        
        inputValueText = UITextField(frame: CGRect(x: 0, y: 0, width: currencySelectionTable.frame.width, height: 44))
        inputValueText?.textAlignment = .center
        inputValueText?.borderStyle = .roundedRect
        
        currencySelectionTable.tableHeaderView = inputValueText
        inputValueText?.placeholder = String("\(viewModel!.defaultConversionValueInAUD)")
    }
    
    func showAlertView(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true) {
            
        }
    }
}

extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        presenter?.accessoryButtonTappedForRowWith(indexPath: indexPath, withInput: inputValueText?.text)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRowAt(indexPath: indexPath, withInput: inputValueText?.text)
    }
    
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsForCurrencyTableView ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel?.textForView(atIndex: indexPath.row)
        cell.detailTextLabel?.text = viewModel?.detailTextForView(atIndex: indexPath.row)
        return cell
    }
}

struct FXCalculatorViewModel {
    
    private var presenter: FXCalculatorPresenter
    
    public let defaultConversionValueInAUD: Double = 1.0
    
    init(withPresenter presenter: FXCalculatorPresenter) {
        self.presenter = presenter
    }
    
    func textForView(atIndex index: Int) -> String? {
        let c = presenter.objectAtIndex(index)
        //do whatever formatting you wish and pass the data forward
        let formattedString = c?.country
        return formattedString
    }
    
    func detailTextForView(atIndex index: Int) -> String? {
        let c = presenter.objectAtIndex(index)
        //do whatever formatting you wish and pass the data forward
        let formattedString = c?.currencyCode
        return formattedString
    }
    
    func userEnteredValueIsValid(_ string: String?) -> Bool {
        guard let strv = string, !strv.isEmpty else { return false }
        //we can check if the entered input is a number as we expect it to be - I'm checking to see if its a number
        
        guard let val = UInt(strv) else { return false }
        
        return val > 0
    }
    
    
}
