//
//  Util.swift
//  customLayout
//
//  Created by 김경환 on 2022/11/02.
//

import Foundation
import UIKit

class Util {
    public static func getSuperView<T>(currentView: UIView, targetView: T) -> T? {
        var view = currentView.superview
        
        while let v = view, (v as? T) == nil {
            view = v.superview
        }
        
        return view as? T
    }
    
}
