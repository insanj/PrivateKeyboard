#include <substrate.h>

@interface BrowserController
+(id)sharedBrowserController;
-(BOOL)privateBrowsingEnabled;
@end

@interface UITextField (Private)
@property (nonatomic, readwrite) int keyboardAppearance;
@end

%hook UITextInputTraits 

-(int)keyboardAppearance{
	int privateBrowsing = [[%c(BrowserController) sharedBrowserController] privateBrowsingEnabled];
	NSLog(@"[PrivateKeyboard] Overriding appearance, was %i, is now %i.", %orig, privateBrowsing);
	return privateBrowsing;
}

%end