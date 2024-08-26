//
//  ViewController.swift
//  AtlysiOSTest
//
//  Created by Shivang on 26/08/24.
//

import UIKit
class ViewController: UIViewController, UIScrollViewDelegate {

    lazy var centerViewWidth: CGFloat = {
        return scrollView.bounds.width * 0.7
    }()
    
    lazy var sideViewWidth: CGFloat = {
        return scrollView.bounds.width * 0.2
    }()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    let imageNames = ["Agra", "Coorg", "delhi", "Goa", "Manali", "Munnar", "OOTY", "udaipur"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupImages()
        
        scrollView.delegate = self
    }
    
    private func setupScrollView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = false
        scrollView.alwaysBounceHorizontal = true
    }
    
    private func setupImages() {
        imageNames.map({ UIImageView(image: UIImage(named: $0)) })
            .forEach { imageView in
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.widthAnchor.constraint(equalToConstant: centerViewWidth).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: centerViewWidth).isActive = true
                stackView.addArrangedSubview(imageView)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = (scrollView.bounds.width - centerViewWidth) / 2
        stackView.distribution = .equalSpacing
        
        // Adjust the scrollView's content size
        let contentWidth = centerViewWidth * CGFloat(imageNames.count) + (stackView.spacing * CGFloat(imageNames.count - 1))
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.bounds.height)
    }
    
    // UIScrollViewDelegate methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = scrollView.bounds.width / 2 + scrollView.contentOffset.x
        
        for (index, imageView) in stackView.arrangedSubviews.enumerated() {
            let imageViewCenterX = imageView.center.x
            let distance = abs(centerX - imageViewCenterX)
            let scale = 1 - min(distance / (scrollView.bounds.width / 2), 0.3) // Adjust scaling factor
            
            UIView.animate(withDuration: 0.3, animations: {
                imageView.transform = CGAffineTransform(scaleX: scale + 0.7, y: scale + 0.7) // Scale image
                imageView.alpha = max(1 - distance / (scrollView.bounds.width / 2), 0.5) // Adjust alpha for side images
            })
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            snapToNearestImage()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapToNearestImage()
    }
    
    private func snapToNearestImage() {
        let centerX = scrollView.bounds.width / 2 + scrollView.contentOffset.x
        let closestIndex = Int(round(centerX / centerViewWidth))
        let targetOffset = CGPoint(x: CGFloat(closestIndex) * (centerViewWidth + stackView.spacing) - scrollView.bounds.width / 2 + centerViewWidth / 2, y: 0)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.setContentOffset(targetOffset, animated: false)
        })
    }
}





