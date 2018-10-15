//
//  ViewController.swift
//  Busan
//
//  Created by D7703_24 on 2018. 10. 15..
//  Copyright © 2018년 D7703_24. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var table: UITableView!
    var items = [AirData]()
    var item = AirData()
    var myPm10 = ""
    var mySite = ""
    var myPm10Cai = ""
    var current = ""
    var cuTime = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Timer 호출
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(ViewController.myParse), userInfo: nil, repeats: true)
        table.delegate = self
        table.dataSource = self
        myParse()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "RE", for: indexPath)
      
        
        let name = cell.viewWithTag(3) as! UILabel
        let color = cell.viewWithTag(2) as! UILabel
        let site = cell.viewWithTag(1) as! UILabel
        
        name.text = items[indexPath.row].dPm10
        color.text = items[indexPath.row].dPm10Cai
        site.text = items[indexPath.row].dSite
        
        return cell
    }
    
    @objc func myParse() {
        // Do any additional setup after loading the view, typically from a nib.
        let key = "%2FEi2tJ5ijF6ETHr9rLQ3pvaqG4b63fSVSypJQKGFyeAttP6jucVPAIW35jU4i9xMbwJLx5OFSwiZcuuhNEsmGA%3D%3D"
        
        let strURL = "http://opendata.busan.go.kr/openapi/service/AirQualityInfoService/getAirQualityInfoClassifiedByStation?ServiceKey=\(key)&Date_hour=2018091520&numOfRows=21"
        
        if let url = URL(string: strURL) {
            if let parser = XMLParser(contentsOf: url) {
                parser.delegate = self
                
                if (parser.parse()) {
                    print("parsing success")
                    print("PM 10 in Busan")
                    
                    let date: Date = Date()
                    let dayTimePeriodFormatter = DateFormatter()
                    dayTimePeriodFormatter.dateFormat = "YYYY/MM/dd HH시"
                    cuTime = dayTimePeriodFormatter.string(from: date)
                    print(cuTime)
                    print("PM10")
                    for i in 0..<items.count {
                        switch items[i].dPm10Cai {
                        case "1" : items[i].dPm10Cai = "좋음"
                        case "2" : items[i].dPm10Cai = "보통"
                        case "3" : items[i].dPm10Cai = "좋음"
                        case "4" : items[i].dPm10Cai = "매우좋음"
                        default : break
                        }
                        
                        print("\(items[i].dSite) : \(items[i].dPm10)  \(items[i].dPm10Cai)")
                    }
                    
                    print("-----------------------")
                    
                    print("-----------------------")
                    
                } else {
                    print("parsing fail")
                }
            } else {
                print("url error")
            }
        }
    }
    
    // XML Parser Delegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        current = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if !data.isEmpty {
            //            print("data = \(data)")
            switch current {
            case "pm10" : myPm10 = data
            case "pm10Cai" : myPm10Cai = data
            case "site" : mySite = data
            default : break
            }
            //            print("pm10Cai = \(myPm10Cai)")
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let myItem = AirData()
            myItem.dPm10 = myPm10
            myItem.dPm10Cai = myPm10Cai
            myItem.dSite = mySite
            items.append(myItem)
        }
    }
}

