import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet private var pageControl: UIPageControl!
    private var pageViewController: PageViewController?
    @IBOutlet private var nextButton: UIButton!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let onboardingPageViewController = segue.destination as? OnboardingPageViewController {
            onboardingPageViewController.onboardingDelegate = self
            self.pageViewController = onboardingPageViewController
        }
    }

}

// MARK: - OnboardingPageViewControllerDelegate

extension OnboardingViewController: OnboardingPageViewControllerDelegate {

    func onboardingPageViewController(onboardingPageViewController: OnboardingPageViewController,
                                      didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }

    func onboardingPageViewController(onboardingPageViewController: OnboardingPageViewController,
                                      didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
        nextButton.setTitle(index == 2 ? "Get Started" : "Next", for: .normal)
    }

}

// MARK: - IBActions

extension OnboardingViewController {

    @IBAction private func onNextButtonPress(_ sender: UIButton) {
        pageViewController?.toggleForward()
    }

}
