//
//  UIScrollView+Extension.swift
//  iChat
//
//  Created by Наталья Шарапова on 20.07.2022.
//

import UIKit

extension UIScrollView {
    
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetforBottom
    }
    
    var verticalOffsetforBottom: CGFloat {
        
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}
