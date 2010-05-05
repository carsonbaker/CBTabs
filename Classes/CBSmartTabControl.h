#import <Foundation/Foundation.h>


@interface CBSmartTabControl : UIView {
	
	IBOutlet id delegate;
	
	NSMutableArray *tabTitles;
	int foreground_tab_index;
	
	CGFloat textFgColor[4];
	CGFloat textBgColor[4];
	CGFloat tabFgColor[4];
	CGFloat tabBgColor[4];
	CGFloat tabStrokeColor[4];
	
	Boolean expanded;

}

- (id) initWithFrame:(CGRect)aRect delegate:(id)del;

@property(retain) id delegate;

@end
