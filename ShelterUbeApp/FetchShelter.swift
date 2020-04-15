
import UIKit

class FetchShelter: NSObject, XMLParserDelegate {
    
    var check_element: [String] = []
    var name = ""
    var lat = 0.0
    var log = 0.0
    var potalCode = ""
    var address = ""
    var phoneNumber = ""
    var emergencyEvacuationSite = false
    var evacuationSite = false
    var caseOfEarthquake = false
    var caseOfTsunami = false
    var caseOfSedimentDisaster = false
    var caseOfHighWavesIn100 = false
    var caseOfHighWavesIn500 = false
    var caseOfFlood = false
    
    func fetchData() {
        guard let url = Bundle.main.url(forResource: "ubehinanjyoic", withExtension: "xml") else {
            print(Error.self)
            return
        }
        
        guard let parser = XMLParser(contentsOf: url) else {
            print("Error: \(Error.self)")
            return
        }
        
        parser.delegate = self
        parser.parse()
        
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {}
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        check_element.append(elementName)
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        switch check_element.last {
            case "緯度":
                lat = Double(string)!
            case "経度":
                log = Double(string)!
            case "郵便番号":
                potalCode = string
            case "電話番号":
                phoneNumber = string
            case "ube:緊急避難場所":
                emergencyEvacuationSite = changeBool(str: string)
            case "ube:避難所":
                evacuationSite = changeBool(str: string)
            case "ube:地震対応":
                caseOfEarthquake = changeBool(str: string)
            case "ube:津波対応":
                caseOfTsunami = changeBool(str: string)
            case "ube:土砂災害対応":
                caseOfSedimentDisaster = changeBool(str: string)
            case "ube:高潮対応-100年に一度":
                caseOfHighWavesIn100 = changeBool(str: string)
            case "ube:高潮対応-500年に一度":
                caseOfHighWavesIn500 = changeBool(str: string)
            case "ube:洪水対応":
                caseOfFlood = changeBool(str: string)
            default:
                break
        }
        
        let arrayStatus = (check_element[check_element.count - 2], check_element.last)
        
        switch arrayStatus {
            case ("名称", "表記"):
                name = string
            case ("住所", "表記"):
                address = string
            default:
                return
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if check_element.last == elementName {
            check_element.removeLast()
        }
        
        if elementName == "ube:緊急避難場所及び避難所" && check_element.count == 1 {
            addToModelList()
        }
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {}
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Error: " + parseError.localizedDescription)
    }
    
    // MARK: Private Action
    private func changeBool(str: String) -> Bool {
        return str == "○" ? true : false
    }
    
    private func addToModelList() {
        let shelter = Shelter.init(name: name, lat: lat, log: log, potalCode: potalCode, address: address, phoneNumber: phoneNumber, emergencyEvacuationSite: emergencyEvacuationSite, evacuationSite: evacuationSite, earthquake: caseOfEarthquake, tsunami: caseOfTsunami, sedimentDisaster: caseOfSedimentDisaster, highWavesIn100: caseOfHighWavesIn100, highWavesIn500: caseOfHighWavesIn500, flood: caseOfFlood)
        
        Shelter.addList(shelter: shelter)
    }

}
