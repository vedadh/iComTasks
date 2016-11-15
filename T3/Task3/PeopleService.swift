//
//  PeopleService.swift
//  Task3
//
//  Created by Vedad Hasanagic on 11/15/16.
//  Copyright © 2016 Vedad H. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import Unbox

class PeopleService {
    
    static let service = PeopleService()
    private init() {}
    
    fileprivate func all() -> Promise<[Person]> {
        return Promise { fulfill, reject in
            Alamofire.request(PeopleRouter.Get).responseArray(completionHandler: { (response: DataResponse<[Person]>) in
                switch response.result {
                case .success:
                    return fulfill(response.result.value ?? [])
                case .failure(let error):
                    print(error)
                    reject(error)
                }
            })
        }
    }
    
    fileprivate func allCached() -> [Person] {

        let asset = NSDataAsset(name: "people", bundle: Bundle.main)
        var peopleList: [Person]?
        do {
            let json = LineToJsonConverter.convert(data: asset!.data)
            peopleList = try unbox(data: json!)
        } catch(let error) {
            print(error)
        }
        return peopleList ?? []
    }
    
    public func fetchAll(_ completion: @escaping ([Person]) -> Void) {
 
        completion(allCached())
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let _ = all().then { (people) -> Void in
            completion(people)
        }.catch { (error) in
            print(error)
        }.always {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
    }
    
}
