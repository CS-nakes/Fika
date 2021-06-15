import UIKit

class OnboardingPageViewController: UIPageViewController {

    weak var onboardingDelegate: OnboardingPageViewControllerDelegate?
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController(name: "MakeFriends"),
                self.newViewController(name: "AutomatedScheduling"),
                self.newViewController(name: "TakeBreak")]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self

        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        onboardingDelegate?.onboardingPageViewController(onboardingPageViewController: self,
                                                         didUpdatePageCount: orderedViewControllers.count)
    }

    private func newViewController(name: String) -> UIViewController {
        UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: name)
    }

}

// MARK: - UIPageViewControllerDataSource

extension OnboardingPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0, orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1

        guard orderedViewControllers.count > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }

}

// MARK: - UIPageViewControllerDelegate

extension OnboardingPageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let firstViewcontroller = viewControllers?.first,
              let index = orderedViewControllers.firstIndex(of: firstViewcontroller) else {
            return
        }
        onboardingDelegate?.onboardingPageViewController(onboardingPageViewController: self, didUpdatePageIndex: index)
    }

}

// MARK: - PageViewController

extension OnboardingPageViewController: PageViewController {

    func toggleForward() {
        guard let firstViewcontroller = viewControllers?.first,
              let index = orderedViewControllers.firstIndex(of: firstViewcontroller) else {
            return
        }

        let nextIndex = index + 1
        if nextIndex >= orderedViewControllers.count {
            return
        }
        setViewControllers([orderedViewControllers[nextIndex]], direction: .forward, animated: true, completion: { _ in
            self.onboardingDelegate?.onboardingPageViewController(onboardingPageViewController: self,
                                                                  didUpdatePageIndex: nextIndex)
        })
    }

}
