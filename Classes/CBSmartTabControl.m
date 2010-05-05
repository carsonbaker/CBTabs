#import "CBSmartTabControl.h"

void CGContextAddRoundedRect (CGContextRef c, CGRect rect, int corner_radius) {
	int x_left = rect.origin.x;
	int x_left_center = rect.origin.x + corner_radius;
	int x_right_center = rect.origin.x + rect.size.width - corner_radius;
	int x_right = rect.origin.x + rect.size.width;
	int y_top = rect.origin.y;
	int y_top_center = rect.origin.y + corner_radius;
	int y_bottom_center = rect.origin.y + rect.size.height - corner_radius;
	int y_bottom = rect.origin.y + rect.size.height;
	
	/* Begin! */
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, x_left, y_top_center);
	
	/* First corner */
	CGContextAddArcToPoint(c, x_left, y_top, x_left_center, y_top, corner_radius);
	CGContextAddLineToPoint(c, x_right_center, y_top);
	
	/* Second corner */
	CGContextAddArcToPoint(c, x_right, y_top, x_right, y_top_center, corner_radius);
	CGContextAddLineToPoint(c, x_right, y_bottom_center);
	
	/* Third corner */
	CGContextAddArcToPoint(c, x_right, y_bottom, x_right_center + 10, y_bottom, corner_radius);
	CGContextAddLineToPoint(c, x_left_center - 10, y_bottom);
	
	/* Fourth corner */
	CGContextAddArcToPoint(c, x_left, y_bottom, x_left, y_bottom_center, corner_radius);
	CGContextAddLineToPoint(c, x_left, y_top_center);
	
	/* Done */
	CGContextClosePath(c);
	
}

@implementation CBSmartTabControl

@synthesize delegate;


- (void) dealloc {

	[tabTitles release];
	
	[super dealloc];
	
}

- (void) switchToSubview: (int) index {
		
	foreground_tab_index = index;
	
	if ([delegate respondsToSelector:@selector(unloadCurrentSubview)]) {
		[delegate performSelector: @selector(unloadCurrentSubview)];
	}
	
	if ([delegate respondsToSelector:@selector(loadSubviewForIndex:)]) {
		[delegate performSelector: @selector(loadSubviewForIndex:) withObject: [NSNumber numberWithInt: index]];
	}
	
	[self layoutSubviews];
	[self setNeedsDisplay];
	
}

- (id) initWithFrame: (CGRect)aRect delegate: (id) del {
	if (self=[super initWithFrame: (CGRect)aRect]) {
		
		[self setDelegate: del];
		
		expanded = NO;
		
		tabTitles = [[NSMutableArray array] retain];
		
		[tabTitles addObject: @"Alpha"];
		[tabTitles addObject: @"Beta"];
		[tabTitles addObject: @"Gamma"];
		[tabTitles addObject: @"Delta"];
		[tabTitles addObject: @"Epsilon"];
		[tabTitles addObject: @"Zeta"];
		
		textFgColor[0]	= 0.3;	textFgColor[1]	= 0.3;	textFgColor[2]	= 0.3;	textFgColor[3]	= 1.0;
		textBgColor[0]	= 1.0;	textBgColor[1]	= 1.0;	textBgColor[2]	= 1.0;	textBgColor[3]	= 1.0;
		tabFgColor[0]	= 0.4;	tabFgColor[1]	= 0.4;	tabFgColor[2]	= 0.4;	tabFgColor[3]	= 1.0;
		tabBgColor[0]	= 0.8;	tabBgColor[1]	= 0.8;	tabBgColor[2]	= 0.8;	tabBgColor[3]	= 1.0;
		tabStrokeColor[0] = 0.6; tabStrokeColor[1] = 0.6;	tabStrokeColor[2] = 0.6; tabStrokeColor[3] = 1.0;

		[self setBackgroundColor: [UIColor colorWithRed: 0.82 green: 0.84 blue: 0.86 alpha: 1.0]];
		
		foreground_tab_index = 0;
	}
	return self;		
}

- (float) cellWidth {
	return [self bounds].size.width / [tabTitles count];
}

- (float) cellHeight {
	return 40;
}

- (CGGradientRef) backGradient {
	CGGradientRef gradie;
	CGColorSpaceRef cspace;
	size_t num_locations	= 2;
	CGFloat locations[2]	= { 0.0, 1.0 };
	CGFloat components[8]	= { 0.65, 0.67, 0.69, 1.0,  // Start color
								0.32, 0.34, 0.36, 1.0 }; // End color
	
	cspace = CGColorSpaceCreateDeviceRGB();
	gradie = CGGradientCreateWithColorComponents (cspace, components, locations, num_locations);
	
	return gradie;
}

- (CGGradientRef) buttonGradient {
	CGGradientRef gradie;
	CGColorSpaceRef cspace;
	size_t num_locations	= 2;
	CGFloat locations[2]	= { 0.0, 1.0 };
	CGFloat components[8]	= { 1.0, 1.0, 1.0, 1.0,  // Start color
		0.82, 0.84, 0.86, 1.0 }; // End color
	
	cspace = CGColorSpaceCreateDeviceRGB();
	gradie = CGGradientCreateWithColorComponents (cspace, components, locations, num_locations);
	
	return gradie;
}

- (void) drawBackground2: (CGRect) rect {
	
	CGContextRef myContext = UIGraphicsGetCurrentContext();
	
	CGPoint myStartPoint, myEndPoint;
	myStartPoint.x = 0.0;
	myStartPoint.y = 0.0;
	myEndPoint.x = 0.0;
	myEndPoint.y = 40.0;
	CGContextDrawLinearGradient (myContext, [self backGradient], myStartPoint, myEndPoint, 0);
	
}

- (void) drawForegroundCircle: (CGRect) rect {
	
	CGContextRef myContext = UIGraphicsGetCurrentContext();
	
	float inset = 10;
	float v_margin = 5;
	float height = 35;
	float start = foreground_tab_index * [self cellWidth] + inset;
	float end = [self cellWidth] - inset*2;
	
	// fill
	
	CGContextSetRGBFillColor(myContext, 0.9, 0.9, 0.9, 1);
	CGContextAddRoundedRect(myContext, CGRectMake(start,v_margin,end,height), 5);
	CGContextFillPath(myContext);

	// gradlay
	
	CGContextSaveGState(myContext);
	CGContextAddRoundedRect(myContext, CGRectMake(start,v_margin,end,height), 5);
	CGContextClip(myContext);
	CGPoint myStartPoint, myEndPoint;
	myStartPoint.x = 0.0;
	myStartPoint.y = 0.0;
	myEndPoint.x = 0.0;
	myEndPoint.y = 40.0;
	CGContextDrawLinearGradient (myContext, [self buttonGradient], myStartPoint, myEndPoint, 0);
	CGContextRestoreGState(myContext);
	
}

- (void) drawTabTitles: (CGRect) rect {
	

	CGContextRef myContext = UIGraphicsGetCurrentContext();
	
	for(int i = 0; i < [tabTitles count]; i++) {
		
		float tabStart = i * [self cellWidth];
		float textXOffset = 20;
		float textYOffset = 11;
		
		NSString *typesetMe = [tabTitles objectAtIndex: i];
		CGSize textSize = [typesetMe sizeWithFont: [UIFont boldSystemFontOfSize: 14.0]];
		float center_start = ([self cellWidth] - textSize.width) / 2;
		
		if(i == foreground_tab_index) {
			CGContextSetFillColor(myContext, textFgColor);
		} else {
			CGContextSetRGBFillColor(myContext, 0, 0, 0, 0.3);
			
			[[tabTitles objectAtIndex: i] drawAtPoint: CGPointMake(tabStart + center_start, textYOffset-1)
											 forWidth: ([self cellWidth] - textXOffset*2)
											 withFont: [UIFont boldSystemFontOfSize: 14.0]
											 fontSize: 14.0
										lineBreakMode: UILineBreakModeTailTruncation
								   baselineAdjustment: UIBaselineAdjustmentNone];
			
			CGContextSetFillColor(myContext, textBgColor);
		}
		
		[[tabTitles objectAtIndex: i] drawAtPoint: CGPointMake(tabStart + center_start, textYOffset)
										 forWidth: ([self cellWidth] - textXOffset*2)
										 withFont: [UIFont boldSystemFontOfSize: 14.0]
										 fontSize: 14.0
									lineBreakMode: UILineBreakModeTailTruncation
							   baselineAdjustment: UIBaselineAdjustmentNone];
		

		
		
	}
	
}

- (void) drawRect: (CGRect)rect {
	
	[self drawBackground2: rect];
	[self drawForegroundCircle: rect];
	[self drawTabTitles: rect];
	
}

- (void) layoutSubviews {
	
	float inset = 10;
	float top_push = [self cellHeight] + inset;
	float subview_width = [self frame].size.width - inset*2;
	float subview_height = [self frame].size.height - inset - top_push;
	
	for(UIView *uv in [self subviews]) {
		[uv setFrame: CGRectMake(inset, top_push, subview_width, subview_height)];
	}
	
}

- (void) toggleExpansion {

	if(!expanded) {
		[self setFrame: CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height+200)];
		[self layoutSubviews];
		[self setNeedsDisplay];
		[self setNeedsLayout];
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];

	if(expanded) {
		[self setFrame: CGRectMake(0, self.frame.origin.y + 200, self.frame.size.width, self.frame.size.height)];
	} else {
		[self setFrame: CGRectMake(0, self.frame.origin.y - 200, self.frame.size.width, self.frame.size.height)];
	}
	
	[self layoutSubviews];
	[UIView commitAnimations];
	
	expanded = !expanded;
	
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	if(!expanded) {
		[self setFrame: CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height-200)];
		[self layoutSubviews];
		[self setNeedsDisplay];
		[self setNeedsLayout];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

	CGPoint p = [[touches anyObject] locationInView: self];
	
	if(p.y <= [self cellHeight]) {
		int index = p.x / [self cellWidth]; // click is within the toolbar range
		if(index == foreground_tab_index) { // user didn't select the current tab
			[self toggleExpansion];
		} else { // user wants to expand/collapse the tab area
			[self switchToSubview: index];
		}
	}
	
}

@end
