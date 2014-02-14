#include <substrate.h>

@interface BrowserController
+(id)sharedBrowserController;
-(BOOL)privateBrowsingEnabled;
-(void)_setPrivateBrowsingEnabled:(BOOL)arg1;
@end

@interface UIKBRenderConfig : NSObject
-(BOOL)lightKeyboard;
@end

%hook BrowserController
-(void)_setPrivateBrowsingEnabled:(BOOL)arg1{
	%orig();
	NSError *deleteError;
	BOOL deletedWorked = [[[NSFileManager alloc] init] removeItemAtPath:@"/var/mobile/Library/Caches/com.apple.keyboards" error:&deleteError];
	NSLog(@"[PrivateKeyboard] Attempted to remove cache, result: %@, errors: %@", deletedWorked ? @"GOOD" : @"BAD", deleteError);
}

%end

%hook UIKBRenderConfig 

-(BOOL)lightKeyboard{
	return ![[%c(BrowserController) sharedBrowserController] privateBrowsingEnabled];
}

%end