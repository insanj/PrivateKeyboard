#include <substrate.h>

@interface BrowserController
+(id)sharedBrowserController;
-(BOOL)privateBrowsingEnabled;
@end

@interface UIKBRenderConfig : NSObject
-(BOOL)lightKeyboard;
@end

@interface UIKBTextStyle : NSObject
-(id)textColor;
@end

%hook UIKBRenderConfig 

-(BOOL)lightKeyboard{
	return ![[%c(BrowserController) sharedBrowserController] privateBrowsingEnabled];
}

%end

%hook UIKBTextStyle

-(id)textColor{
	return [[%c(BrowserController) sharedBrowserController] privateBrowsingEnabled] ? [UIColor whiteColor] : [UIColor blackColor];
}

%end