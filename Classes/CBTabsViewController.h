#import <UIKit/UIKit.h>

@class CBSmartTabControl;

@interface CBTabsViewController : UIViewController {
	
	CBSmartTabControl *stc;
	
	IBOutlet	UIView *alphaView;
	IBOutlet	UIView *betaView;
	
}

- (void) loadSubviewForIndex: (NSNumber*) index;
- (void) unloadCurrentSubview;


@end

