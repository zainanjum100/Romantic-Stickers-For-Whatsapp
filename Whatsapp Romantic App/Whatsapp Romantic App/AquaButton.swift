//
// Copyright (c) WhatsApp Inc. and its affiliates.
// All rights reserved.
//
// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//

import UIKit

class RoundedButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        adjustsImageWhenHighlighted = false

        layer.masksToBounds = true
        layer.cornerRadius = 10.0

        titleLabel?.font = UIFont.boldSystemFont(ofSize: titleLabel!.font.pointSize)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AquaButton: RoundedButton {

    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }

        set (newHighlighted) {
            super.isHighlighted = newHighlighted

            imageView?.tintColor = newHighlighted ? UIColor.white.withAlphaComponent(0.5) : .white
        }
    }
    
    override var isEnabled: Bool {
        didSet{
            if self.isEnabled {
                  imageView!.tintColor = .white
            }
            else{
                  imageView!.tintColor = .lightGray
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        adjustsImageWhenHighlighted = false

        backgroundColor = #colorLiteral(red: 0.3700218797, green: 0.01926613413, blue: 0.3201488256, alpha: 1)

        imageView!.tintColor = .white
        setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        setTitleColor(UIColor.lightGray.withAlphaComponent(1.0), for: .disabled)
        imageEdgeInsets.left = -25
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GrayRoundedButton: RoundedButton {
    private let aquaColor: UIColor = .white

    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }

        set (newHighlighted) {
            super.isHighlighted = newHighlighted

            imageView?.tintColor = newHighlighted ? aquaColor.withAlphaComponent(0.5) : aquaColor
        }
    }
    
    override var isEnabled: Bool {
        didSet{
            if self.isEnabled {
                self.tintColor = UIColor.white
            }
            else{
                self.tintColor = UIColor.gray
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        adjustsImageWhenHighlighted = false

        backgroundColor = #colorLiteral(red: 0.3700218797, green: 0.01926613413, blue: 0.3201488256, alpha: 1)
        layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        layer.borderWidth = 1.0

        imageView!.tintColor = aquaColor
        setTitleColor(aquaColor, for: .normal)
        setTitleColor(aquaColor.withAlphaComponent(0.5), for: .highlighted)
        imageEdgeInsets.left = -25
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
