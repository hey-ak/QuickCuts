import UIKit

extension DKChainableAnimationKit {

    internal func makeAnchorFrom(x: CGFloat, y: CGFloat) {
        let anchorPoint = CGPoint(x: x, y: y)
        func action(_ view: UIView) {
            if anchorPoint.equalTo(view.layer.anchorPoint) {
                return
            }
            var newPoint = CGPoint(
                x: view.bounds.size.width * anchorPoint.x,
                y: view.bounds.size.height * anchorPoint.y
            )
            var oldPoint = CGPoint(
                x: view.bounds.size.width * view.layer.anchorPoint.x,
                y: view.bounds.size.height * view.layer.anchorPoint.y
            )
            newPoint = newPoint.applying(view.transform)
            oldPoint = oldPoint.applying(view.transform)

            var position = view.layer.position

            position.x -= oldPoint.x
            position.x += newPoint.x

            position.y -= oldPoint.y
            position.y += newPoint.y

            view.layer.position = position
            view.layer.anchorPoint = anchorPoint
        }

        if var lastCalculationActions = self.animationCalculationActions.last {
            lastCalculationActions.insert(action, at: 0)
            self.animationCalculationActions.removeLast()
            self.animationCalculationActions.append(lastCalculationActions)
        }
    }

    @discardableResult public func makeAnchor(_ x: CGFloat, _ y: CGFloat) -> DKChainableAnimationKit {
        self.makeAnchorFrom(x: x, y: y)
        return self
    }

    public var anchorDefault: DKChainableAnimationKit {
        get {
            return self.anchorCenter
        }
    }

    public var anchorCenter: DKChainableAnimationKit {
        get {
            self.makeAnchorFrom(x: 0.5, y: 0.5)
            return self
        }
    }

    public var anchorTopLeft: DKChainableAnimationKit {
        get {
            self.makeAnchorFrom(x: 0.0, y: 0.0)
            return self
        }
    }

    public var anchorTopRight: DKChainableAnimationKit {
        get {
            self.makeAnchorFrom(x: 1.0, y: 0.0)
            return self
        }
    }

    public var anchorBottomLeft: DKChainableAnimationKit {
        get {
            self.makeAnchorFrom(x: 0.0, y: 1.0)
            return self
        }
    }

    public var anchorBottomRight: DKChainableAnimationKit {
        get {
            self.makeAnchorFrom(x: 1.0, y: 1.0)
            return self
        }
    }

    public var anchorTop: DKChainableAnimationKit {
        get {
            self.makeAnchorFrom(x: 0.5, y: 0.0)
            return self
        }
    }

    public var anchorBottom: DKChainableAnimationKit {
        get {
            self.makeAnchorFrom(x: 0.5, y: 1.0)
            return self
        }
    }

    public var anchorLeft: DKChainableAnimationKit {
        get {
            self.makeAnchorFrom(x: 0.0, y: 0.5)
            return self
        }
    }

    public var anchorRight: DKChainableAnimationKit {
        get {
            self.makeAnchorFrom(x: 1.0, y: 0.5)
            return self
        }
    }

}
