#include <substrate.h>

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end

@interface BrowserController
+(id)sharedBrowserController;
-(BOOL)privateBrowsingEnabled;
-(void)_setPrivateBrowsingEnabled:(BOOL)arg1;
@end

@interface UIKBRenderConfig : NSObject
-(BOOL)lightKeyboard;
-(float)keycapOpacity;
@end

%hook BrowserController

-(void)_setPrivateBrowsingEnabled:(BOOL)arg1{
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"PKChangeKeyboard" object:nil userInfo:@{@"isLight" : @(!arg1)}];
	%orig();
}

%end

%hook UIKBRenderConfig

-(id)init{
	UIKBRenderConfig *kbRender = %orig();
	//[kbRender setLightKeyboard:![[%c(BrowserController) sharedBrowserController] privateBrowsingEnabled]];
	//[[NSDistributedNotificationCenter defaultCenter] addObserver:kbRender selector:@selector(pk_changeKeyboard:) name:@"PKChangeKeyboard" object:nil];
	return kbRender;
}

%new -(void)pk_changeKeyboard:(NSNotification *)notif{
	//NSLog(@"[PrivateKeyboard] Assigning keyboard traits... (%@)", notif);
	//self = [[%c(UIKBRenderConfig) alloc] init];
	//[self setLightKeyboard:[notif.userInfo[@"isLight"] boolValue]];
}

-(BOOL)lightKeyboard{
	return ![[%c(BrowserController) sharedBrowserController] privateBrowsingEnabled];
}

-(float)keycapOpacity{
	float replacement = [self lightKeyboard] ? 0.0 : CGFLOAT_MIN;
	NSLog(@"[PrivateKeyboard] Original cap %f replaced with %f.", %orig, replacement);
	return replacement;
}

-(float)keyborderOpacity{
	float replacement = [self lightKeyboard] ? 0.0 : CGFLOAT_MIN;
	NSLog(@"[PrivateKeyboard] Original border %f replaced with %f.", %orig, replacement);
	return replacement;
}

%end