#import "CBTabsViewController.h"
#import "CBSmartTabControl.h"


@implementation CBTabsViewController

- (void) unloadCurrentSubview {
	UIView *subview = [[stc subviews] lastObject];
	[UIView beginAnimations:nil context:nil];
	subview.alpha = 0;
	
	[UIView commitAnimations];
	
//	[subview removeFromSuperview];
}

- (void) loadSubviewForIndex: (NSNumber*) index {
	UIView *replacement = nil;
	
	switch([index intValue]) {
		case 0:	replacement = alphaView;	break;
		case 1:	replacement = betaView; break;
	}
	
	if(replacement != nil) {
		[stc addSubview: replacement];
		
		replacement.alpha = 0;
		[UIView beginAnimations:nil context:nil];
		replacement.alpha = 1;
		
		[UIView commitAnimations];
	}
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	float width = [self.view bounds].size.width;
	float height = [self.view bounds].size.height;
	
	stc = [[CBSmartTabControl alloc] initWithFrame: CGRectMake(0, 400, width, height-400) delegate: self];
	[stc addSubview: alphaView];
	
	[self.view addSubview: stc];

	
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[stc dealloc];
    [super dealloc];
}

@end
