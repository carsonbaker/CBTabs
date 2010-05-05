#import <UIKit/UIKit.h>

@class CBTabsViewController;

@interface CBTabsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CBTabsViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CBTabsViewController *viewController;

@end

