/*
 IntroViewController.swift
 PVOnboardKitExample
 
 Copyright 2017 Victor Peschenkov
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import UIKit
import PVOnboardKit

class IntroViewController: UIViewController {
    private (set) lazy var model: IntroModel! = {
        return IntroModel()
    }()
    
    private (set) lazy var introView: IntroView! = {
        return IntroView()
    }()
    
    override func loadView() {
        view = self.introView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        setUpOnboard()
    }
    
    private func setUpOnboard() {
        let setUpActionButtonBlock: OnboardViewConfigureActionButtonBlock = {
            (button) in
            
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            button.setTitleColor(UIColor.white, for: .normal)
            button.setTitleColor(UIColor.white, for: .highlighted)
        }
        
        introView.onboardView.delegate = self
        introView.onboardView.dataSource = self
        
        introView.onboardView.dotImage = #imageLiteral(resourceName: "IntroDotImage")
        introView.onboardView.currentDotImage = #imageLiteral(resourceName: "IntroCurrentDotImage")
        
        introView.onboardView.setUpLeftActionButtonWith(setUpActionButtonBlock)
        introView.onboardView.setUpRightActionButtonWith(setUpActionButtonBlock)
        
        introView.onboardView.reloadData()
    }
}

extension IntroViewController: OnboardViewDelegate {
    func onboardView(_ onboardView: OnboardView, didTouchOnLeftActionButtonAt index: Int) {
        NSLog(NSLocalizedString("SKIP", comment: ""))
    }
    
    func onboardView(_ onboardView: OnboardView, didTouchOnRightActionButtonAt index: Int) {
        if index < 2 {
            onboardView.scrollToNextPage(animated: true)
        }
        else {
            NSLog(NSLocalizedString("START", comment: ""))
        }
    }
}

extension IntroViewController: OnboardViewDataSource {
    func numberOfPages(in onboardView: OnboardView) -> Int {
        return model.numberOfPages()
    }

    func onboardView(_ onboardView: OnboardView, viewForPageAtIndex index: Int) -> UIView & OnboardPage {
        let pageModel = model.pageModel(forPageAtIndex: index)
        
        let page = IntroPage()
        page.title = pageModel.title
        page.subtitle = pageModel.subtitle
        page.image = UIImage(named: pageModel.imageName)
        
        return page
    }
    
    public func onboardView(_ onboardView: OnboardView, shouldHideRightActionButtonForPageAt index: Int) -> Bool {
        return model.shouldHideRightActionButton(forPageAtIndex: index)
    }
    
    public func onboardView(_ onboardView: OnboardView, titleForRightActionButtonAt index: Int) -> String?  {
        return model.rightActionButtonTitle(atIndex: index)
    }
    
    public func onboardView(_ onboardView: OnboardView, shouldHideLeftActionButtonForPageAt index: Int) -> Bool {
        return model.shouldHideLeftActionButton(forPageAtIndex: index)
    }
    
    public func onboardView(_ onboardView: OnboardView, titleForLeftActionButtonAt index: Int) -> String? {
        return model.leftActionButtonTitle(atIndex: index)
    }
}
