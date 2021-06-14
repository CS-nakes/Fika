protocol OnboardingPageViewControllerDelegate: AnyObject {

    /// Informs the delegate that the number of pages is updated.
    ///
    /// - Parameter onboardingPageViewController: The OnboardingPageViewController instance
    /// - Parameter count: The total number of pages.
    func onboardingPageViewController(onboardingPageViewController: OnboardingPageViewController,
                                      didUpdatePageCount count: Int)

    /// Informs the delegate that the current index has changed.
    ///
    /// - Parameter onboardingPageViewController: The OnboardingPageViewController instance.
    /// - Parameter index: The index of the currently visible page.
    func onboardingPageViewController(onboardingPageViewController: OnboardingPageViewController,
                                      didUpdatePageIndex index: Int)

}
