//
//  LayoutConstants.swift
//  StraightSeatingLayout
//
//  Created by Ankush on 30/12/22.
//

import Foundation
import UIKit

//MARK: - Constants
class LayoutConstants: NSObject {
    
    //View Sizes
    
    static let stageWidth = 800.0
    static let centerStageHeight = 40.0
    static let doneBtnWidth = 100.0
    static let doneBtnHeight = 56.0
    
    //Seat Layout Constants
    static let seatButtonWidth: CGFloat = 44
    static let seatButtonSize: CGFloat = 30
    
    
    //Scroll View Zoom Constants
    static let maximumZoomScale: CGFloat = 3
    static let doubleTapZoomScale: CGFloat = 1
    static let minimumZoomScale: CGFloat = 0.55
    
    // Screen Size
    static let screenSize: CGRect = UIScreen.main.bounds
}

class LayoutImages : NSObject {
    //Images Strings
    static let closeStr = "close"
    static let stageStr = "festival"
}

class LayoutStrings : NSObject {
    //Procced Button String
    static let proccedStr = "Done"
}

class LayoutFonts : NSObject {
    //SEATS LAYOUT FONT AND COLORS
    static let fontNameStr = "HelveticaNeue-Bold"
}

class LayoutColors : NSObject {
    
    static let mainViewColor = UIColor.white
    static let stageViewColor = UIColor(red: 233/255, green: 109/255, blue: 88/255, alpha: 1)

    static let seatEmptyTextColor = UIColor.clear
    static let seatEmptyBackgroundColor = UIColor.clear
    static let seatEmptyBorderColor = UIColor.clear.cgColor
    
    static let seatUnselectedTextColor = UIColor.black
    static let seatUnselectedBackgroundColor = UIColor.clear
    static let seatUnselectedBorderColor = UIColor.black.cgColor
    
    static let seatSelectedTextColor = UIColor.black
    static let seatSelectedBackgroundColor = UIColor.systemPink
    static let seatSelectedBorderColor = UIColor.black.cgColor
    
    static let seatRowTitleTextColor = UIColor.red
    static let seatRowTitleBackgroundColor = UIColor.clear
    static let seatRowTitleBorderColor = UIColor.clear.cgColor
    
    static let seatUnavailableColor = UIColor.lightGray
}



