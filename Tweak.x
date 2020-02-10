@interface SBFolderIconListView
+ (NSUInteger)maxVisibleIconRowsInterfaceOrientation:(NSUInteger)arg1;
+ (NSUInteger)iconColumnsForInterfaceOrientation:(NSUInteger)arg1;
@end

@interface SBFloatyFolderView
- (CGRect)_frameForScalingView;
- (BOOL)_tapToCloseGestureRecognizer:(id)arg1 shouldReceiveTouch:(id)arg2;
@end

@interface SBFolderBackgroundView : UIView
@end

BOOL enabled;
NSUInteger cols;
NSUInteger rows;

%hook SBFolderIconListView
+ (NSUInteger)maxVisibleIconRowsInterfaceOrientation:(NSUInteger)arg1 {
	if (!enabled)
		return %orig;

	return rows;
}

+ (NSUInteger)iconColumnsForInterfaceOrientation:(NSUInteger)arg1 {
	if (!enabled)
		return %orig;

	return cols;
}
%end

%hook SBFloatyFolderView
- (CGRect)_frameForScalingView {
	if (!enabled)
		return %orig;

	CGRect frame = %orig;
	frame.origin.y -= 30;
	frame.size.height = UIScreen.mainScreen.bounds.size.height - frame.origin.y - 30;
	return frame;
}

- (BOOL)_tapToCloseGestureRecognizer:(id)arg1 shouldReceiveTouch:(id)arg2 {
	if (!enabled)
		return %orig;

	return YES;
}
%end

%hook SBFolderBackgroundView
- (void)setAlpha:(CGFloat)arg1 {
	if (!enabled) {
		%orig;
		return;
	}
	
	%orig(0.0);
}
%end

%ctor {
	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.kef.mappa"];
	NSNumber *en = [prefs objectForKey:@"enabled"];
	enabled = en ? [en boolValue] : YES;
	cols = (NSUInteger)[[prefs objectForKey:@"columns"] intValue] ? : 4;
	rows = (NSUInteger)[[prefs objectForKey:@"rows"] intValue] ? : 4;
}