
import UIKit
import CoreLocation

class Shelter {
    
    // MARK: Properties
    
    let name: String
    let location: CLLocation
    let potalCode: String
    let address: String
    let phoneNumber: String
    let emergencyEvacuationSite: Bool
    let evacuationSite: Bool
    let caseOfEarthquake: Bool
    let caseOfTsunami: Bool
    let caseOfSedimentDisaster: Bool
    let caseOfHighWavesIn100: Bool
    let caseOfHighWavesIn500: Bool
    let caseOfFlood: Bool
    
    static var list: [Shelter] = []
    
    private(set) var distance: CLLocationDistance?
     
    var targetLocation: CLLocation? {
        didSet {
            guard let location = targetLocation else {
                distance = nil
                return
            }
            if location.isEqual(location: oldValue) {
                return
            }
            distance = self.location.distance(from: location)
        }
    }
    
    // MARK: Initialize
    
    init(name: String, lat: CLLocationDegrees, log: CLLocationDegrees, potalCode: String,
         address: String, phoneNumber: String, emergencyEvacuationSite: Bool, evacuationSite: Bool,
         earthquake: Bool, tsunami: Bool, sedimentDisaster: Bool, highWavesIn100: Bool, highWavesIn500: Bool, flood: Bool) {
        
        self.name = name
        self.location = CLLocation(latitude: lat, longitude: log)
        self.potalCode = potalCode
        self.address = address
        self.phoneNumber = phoneNumber
        self.emergencyEvacuationSite = emergencyEvacuationSite
        self.evacuationSite = evacuationSite
        self.caseOfEarthquake = earthquake
        self.caseOfTsunami = tsunami
        self.caseOfSedimentDisaster = sedimentDisaster
        self.caseOfHighWavesIn100 = highWavesIn100
        self.caseOfHighWavesIn500 = highWavesIn100
        self.caseOfFlood = flood
    }
    
    // MARK: Class Method
    
    static func find_by_name(string: String) -> Shelter? {
        
        let indexOfString = list.map{ $0.name }.firstIndex(of: string)
        guard let index = indexOfString else {
            return nil
        }
        
        return list[index]
    }
    
    static func addList(shelter: Shelter) {
        self.list.append(shelter)
    }
    
    static func sortedList(nearFrom location: CLLocation) -> [Shelter] {
        return self.list.sorted(by: { shelter1, shelter2 in
            shelter1.targetLocation = location
            shelter2.targetLocation = location
            return shelter1.distance! < shelter2.distance!
        })
    }
    
    static func whereShelter(list: [Shelter], conditions: [ConditionType]) -> [Shelter] {
        guard !conditions.isEmpty else { return list }
        var filterdList = list
        
        if conditions.contains(.emergencyEvacuationSite) {
            filterdList = filterdList.filter { $0.emergencyEvacuationSite }
        }
        if conditions.contains(.evacuationSite) {
            filterdList = filterdList.filter { $0.evacuationSite }
        }
        if conditions.contains(.caseOfEarthquake) {
            filterdList = filterdList.filter { $0.caseOfEarthquake }
        }
        if conditions.contains(.caseOfTsunami) {
            filterdList = filterdList.filter { $0.caseOfTsunami }
        }
        if conditions.contains(.caseOfSedimentDisaster) {
            filterdList = filterdList.filter { $0.caseOfSedimentDisaster }
        }
        if conditions.contains(.caseOfHighWavesIn100) {
            filterdList = filterdList.filter { $0.caseOfHighWavesIn100 }
        }
        if conditions.contains(.caseOfHighWavesIn500) {
            filterdList = filterdList.filter { $0.caseOfHighWavesIn500 }
        }
        if conditions.contains(.caseOfFlood) {
            filterdList = filterdList.filter { $0.caseOfFlood }
        }
        
        return filterdList
    }
    
    // MARK: Instance Methods
    
    func showDistance() -> String {
        guard let dis = self.distance else {
            return "データがありません"
        }
        return (dis > 1000) ? "\(round(dis / 10) / 100)km" : "\(Int(dis))m"
    }
}

extension CLLocation {
     
    func isEqual(location: CLLocation?) -> Bool {
        if let location = location {
            return self.coordinate.latitude  == location.coordinate.latitude
                && self.coordinate.longitude == location.coordinate.longitude
        }
        return false
    }
}
