// TJReadingServiceViewController
// By Tim Johnsen

#import "TJReadingService.h"

@interface TJReadingServiceViewController : UITableViewController <UIAlertViewDelegate, UITextFieldDelegate> {
	UITextField *_usernameField;
	UITextField *_passwordField;
	
	Class _readingService;
	
	BOOL _isLoading;
}

- (id)initWithService:(Class)service;

@end
