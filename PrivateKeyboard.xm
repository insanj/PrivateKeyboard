#include <substrate.h>

@interface BrowserController
+(id)sharedBrowserController;
-(BOOL)privateBrowsingEnabled;
@end

@interface UIKBRenderConfig : NSObject
-(BOOL)lightKeyboard;
@end

@interface UITextField (Private)
@property (nonatomic, readwrite) int keyboardAppearance;
@property (nonatomic, readwrite) int keyboardType;
-(id)inputView;
@end

@interface UnifiedField : UITextField <UIGestureRecognizerDelegate>
@property(retain, nonatomic) UIView *placeholderCenteringReferenceView;
@property(copy, nonatomic) UIColor *placeholderColor;
-(id)initWithFrame:(struct CGRect)arg1;
-(BOOL)becomeFirstResponder;
-(BOOL)resignFirstResponder;
-(void)layoutSubviews;
-(void)setPlaceholder:(id)arg1;
-(BOOL)gestureRecognizer:(id)arg1 shouldReceiveTouch:(id)arg2;
-(id)defaultPlaceholderColor;
@end

%hook UnifiedField

-(BOOL)becomeFirstResponder{
	NSLog(@"[][][][][][ become: %li, %@", (long)[self keyboardAppearance], [self inputView]);
	return %orig();
}

%end