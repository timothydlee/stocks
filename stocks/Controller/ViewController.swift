//
//  ViewController.swift
//  stocks
//
//  Created by Timothy Lee on 3/5/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PromiseKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let stocksDataModel = StocksDataModel()

    var jsonArray : Array<Any> = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let STOCKS_URL = "https://www.alphavantage.co/query"
        let APP_ID = "YF4GKFKVSW54BMH4"
        let batchStockParams : [String : String] = ["function" : "BATCH_STOCK_QUOTES", "symbols" : "SIRI,AAPL,INTL", "apikey" : APP_ID]
        getStocksData(url: STOCKS_URL, parameters: batchStockParams)
    
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell")

//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            // your code here
//        }
        cell?.textLabel?.text = self.stocksDataModel.stockInfo[indexPath.row].0
        cell?.detailTextLabel?.text = self.stocksDataModel.stockInfo[indexPath.row].1
        
        return cell!
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stocksDataModel.stockInfo.count
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: Get Initial Stock Call
    /***************************************************************/

//    func getStocksData(url: String, parameters: [String : String]) {
//        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
//            response in
//
//            if response.result.isSuccess {
//
//                let result = response.result.value!
//                let stockJSON : JSON = JSON(result)
//                let stocksArray = self.updateStockData(json: stockJSON)
//                self.jsonResult = stocksArray
//
//            } else {
//
//                print("Error \(String(describing: response.result.error))")
//
//            }
//        }
//    }
    
    
    func getStocksData(url: String, parameters: [String : String]) -> Promise<JSON> {
        return Promise { fulfill in
            Alamofire.request(url, method: .get, parameters: parameters)
                .responseJSON { response in
                    if let result = response.result.value {
                        let json = JSON(result)
                        print(json)
                    } else {
                        print("Error")
                    }
                
            }
        }
    }
    
    //MARK: Updates Stocks and Parses JSON
    /***************************************************************/
    
    func updateStockData(json: JSON) -> Array<Any> {
        
        var stocksArray = [] as Array

        for stock in 0..<json["Stock Quotes"].count {
            let stockSymbol = json["Stock Quotes"][stock]["1. symbol"].stringValue
            let stockPrice = json["Stock Quotes"][stock]["2. price"].doubleValue
            stocksArray.append((stockSymbol, stockPrice))
        }
        return stocksArray
    }
    
    

}

