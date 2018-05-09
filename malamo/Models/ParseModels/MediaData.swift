//
//  MediaData.swift
//  malamo
//
//  Created by AppsCreationTech on 12/14/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import Foundation
import UIKit

struct MediaData {
    
    var type: String
    var photo: UIImage
    var path: String
    
    init(type: String, photo: UIImage, path: String) {
        self.type = type
        self.photo = photo
        self.path = path
    }
}
