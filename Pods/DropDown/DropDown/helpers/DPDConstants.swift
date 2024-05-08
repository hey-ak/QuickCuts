//
//  Constants.swift
//  DropDown
//
//  Created by Kevin Hirsch on 28/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

internal struct DPDConstant {

    internal struct KeyPath {

        static let Frame = "frame"

    }

    internal struct ReusableIdentifier {

        static let DropDownCell = "DropDownCell"

    }

    internal struct UI {

        static let TextColor = UIColor.black
        static let SelectedTextColor = UIColor.gray
        static let TextFont = UIFont.systemFont(ofSize: 15)
        static let BackgroundColor = UIColor(white: 1, alpha: 0.85)
        static let SelectionBackgroundColor = UIColor(white: 1, alpha: 0.85)
        static let SeparatorColor = UIColor.lightGray
        static let CornerRadius: CGFloat = 13
        static let RowHeight: CGFloat = 44
        static let HeightPadding: CGFloat = 5

        struct Shadow {

            static let Color = UIColor.darkGray
            static let Offset = CGSize.zero
            static let Opacity: Float = 0.4
            static let Radius: CGFloat = 8

        }

    }

    internal struct Animation {

        static let Duration = 0.15
        static let EntranceOptions: UIView.AnimationOptions = [.allowUserInteraction, .curveEaseOut]
        static let ExitOptions: UIView.AnimationOptions = [.allowUserInteraction, .curveEaseIn]
        static let DownScaleTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)

    }

}