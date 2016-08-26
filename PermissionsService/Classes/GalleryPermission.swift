//
//  GalleryPermission.swift
//
//  Created by Volodymyr Hyrka on 2/9/16.
//  Copyright © 2016 LembergSolutions. All rights reserved.
//

import Foundation
import Photos

public final class GalleryPermission: PermissonConfiguration {
  
  public init() {
    
  }
  
  public func checkStatus() -> PermissonStatus {
    let statusInt = PHPhotoLibrary.authorizationStatus().rawValue
    guard let status = PermissonStatus(rawValue: statusInt) where (0...3) ~= statusInt else {
      assertionFailure("Impossible status")
      return .NotDetermined
    }
    return status
  }
  
  public func requestStatus(requestGranted: (successRequestResult: Bool) -> Void) {
    PHPhotoLibrary.requestAuthorization({ (newStatus) -> Void in
      let success = newStatus == PHAuthorizationStatus.Authorized
      requestGranted(successRequestResult: success)
    })
  }
  
  public func restrictedAlertMessage() -> String {
    return "This app does not have access to your photos and videos"
  }
}