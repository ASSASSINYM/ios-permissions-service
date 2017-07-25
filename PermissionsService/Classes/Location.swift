//
//  Location.swift
//
//  Created by Orest Grabovskyi on 12/28/16.
//  Copyright © 2016 Lemberg Solution. All rights reserved.
//

import Foundation
import CoreLocation

public final class Location: NSObject, PermissionService {
    
  internal var locationManager = CLLocationManager()
  internal let dispatchGroup = DispatchGroup()
 
  let type: CLAuthorizationStatus =  CLAuthorizationStatus.authorizedWhenInUse

  public func test<T: PermissionConfiguration>(with configuration: T)
        where T: LocationConfiguration {
            
        print(configuration.permissionType.rawValue)
    }
  
    
  public required init(with configuration: PermissionConfiguration) {
    
//    guard let config = configuration as? LocationConfiguration else {
//        print("#ERROR - 001 Not correct Configuration")
//        return
//    }
//    
//    self.type = config.permissionType.rawValue
//    if let config = configuration as? LocationConfiguration {
//        self.type = CLAuthorizationStatus(rawValue: Int32(config.permissionType.rawValue))
//    } else {
//        self.type = CLAuthorizationStatus.authorizedWhenInUse
//    }
    
    super.init()
    test(with: configuration as! LocationConfiguration)
    
  }

  public func status() -> PermissionStatus {
    let statusInt = Int(CLLocationManager.authorizationStatus().rawValue)
    guard let status = PermissionStatus(rawValue: statusInt), (0...4) ~= statusInt else {
      assertionFailure("Impossible status")
      return .notDetermined
    }
    return status
  }

  public func requestPermission(_ callback: @escaping (_ success: Bool) -> Void) {
    
    locationManager.delegate = self
    
    dispatchGroup.enter()
    locationManager.requestWhenInUseAuthorization()

    dispatchGroup.notify(queue: DispatchQueue.main) {
        
        var permissionGranted = false
        let status = CLLocationManager.authorizationStatus()
        self.locationManager.delegate = nil
        
        switch (status) {
        case .authorizedAlways, .authorizedWhenInUse:
            permissionGranted = true
            break
        case .denied,.restricted:
            permissionGranted = false
            break
        case .notDetermined:
            permissionGranted = false
            break
        }
        
        callback(permissionGranted)
    }

  }
    
    
}

extension Location: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .notDetermined {
            dispatchGroup.leave()
        }
        
    }
}
