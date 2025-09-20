//
//  UIPageControl+Style.swift
//  QRScanner
//
//  Created by George Popkich on 17.07.24.
//

import UIKit

extension UIPageControl {
    
    static func onbordingPageControl(numOfPages: Int, 
                                     currentPage: Int) -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .appWhite
        pageControl.pageIndicatorTintColor = .gray
        pageControl.numberOfPages = numOfPages
        pageControl.currentPage = currentPage
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }
    
}
