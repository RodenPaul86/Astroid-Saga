//
//  CGSizeExtensions.swift
//  Astroid Saga
//
//  Created by Paul on 10/17/19.
//  Copyright © 2019 Studio4Designsoftware. All rights reserved.
//

import UIKit

extension CGSize {
    func asepctFill(_ target: CGSize) -> CGSize {
        let baseAspect = self.width / self.height
        let targetAspect = target.width / target.height
        if baseAspect > targetAspect {
            return CGSize(width: (target.height * width) / height, height: target.height)
        } else {
            return CGSize(width: target.width, height: (target.width * height) / width)
        }
    }
}
