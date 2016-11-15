import Foundation

func arrayFromObject(obj: Any...) -> [Any] {
    return obj
}

func nestedList(obj: Any, current: Int, level: Int) -> Any {
    return current < level ? arrayFromObject(nestedList(obj, current: current + 1, level: level)) : obj
}

func randomNestedList(obj: Any) -> Any {
    return nestedList(obj, current: 0, level: Int(arc4random_uniform(4)))
}

func flat<R>(list: [Any]) -> [R] {
    var result = [R]()
    
    for item in list {
        switch item {
        case let singleVal as R:
            result.append(singleVal)
        case let arrayVal as [Any]:
            result += flat(arrayVal)
        default:
            print("Value does not conform")
        }
    }
    return result
}

var nestedArray: [Any] = []
for num in (0..<10) {
    nestedArray.append(randomNestedList(num))
}
print(nestedArray)

let output: [Int] = flat(nestedArray)

print(output)


extension Double {
    
    func radians() -> Double {
        return (M_PI * self / 180)
    }
    
    func degrees() -> Double {
        return self * 180 / M_PI
    }
}

public struct SphericalCoordinates {
    
    private static let R = 6371000.0
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var latitudeRadians: Double  {
        return self.latitude.radians()
    }
    var longitudeRadians: Double {
        return self.longitude.radians()
    }
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public init(latitudeRadians: Double, longitudeRadians: Double) {
        self.latitude = latitude.degrees()
        self.longitude = longitude.degrees()
    }
    
    func distanceMeters(toPoint: SphericalCoordinates) -> Double {
        let φ1 = latitudeRadians
        let φ2 = toPoint.latitudeRadians
        let Δλ = (toPoint.longitude-longitude).radians()
        
        return acos(sin(φ1) * sin(φ2) + cos(φ1) * cos(φ2) * cos(Δλ) ) * SphericalCoordinates.R
    }
    
    func distanceKiloMeters(toPoint: SphericalCoordinates) -> Double {
        return distanceMeters(toPoint) / 1000.0
    }
    
}

let coords1 = SphericalCoordinates(latitude: 52.986375, longitude: -6.043701)
let coords2 = SphericalCoordinates(latitude: 53.3393, longitude: -6.2576841)


print(coords1.distanceKiloMeters(coords2))

