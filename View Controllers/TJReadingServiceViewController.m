// TJReadingServiceViewController
// By Tim Johnsen

#import "TJReadingServiceViewController.h"
#import "TJReadingService.h"

@interface TJReadingServiceViewController ()

- (void)_logIn;
- (void)_cancel;

@end

@implementation TJReadingServiceViewController

#pragma mark -
#pragma mark NSObject

- (id)init {
	if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
		[self setModalPresentationStyle:UIModalPresentationPageSheet];
	}
	
	return self;
}

- (void)dealloc {
	[_usernameField release];
	[_passwordField release];
	
	[_readingService release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self setTitle:[_readingService name]];
	
	if ([_readingService isLoggedIn]) {
		[[self navigationItem] setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_cancel)] autorelease]];
	} else {
		[[self navigationItem] setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_cancel)] autorelease]];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		if ([_readingService isLoggedIn]) {
			return 1;
		} else {
			return 2;
		}
	}
	return !_isLoading;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
//	for (id view in [[cell contentView] subviews]) {
//		[view removeFromSuperview];
//	}
    
	if (indexPath.section == 0) {
		[[cell textLabel] setFont:[UIFont boldSystemFontOfSize:14.0f]];
		[[cell textLabel] setTextAlignment:UITextAlignmentLeft];
		if (indexPath.row == 0) {
			
			if (![_readingService isLoggedIn]) {
			
				[[cell textLabel] setText:[_readingService loginLabel]];
				
				if (!_usernameField) {
					_usernameField = [[UITextField alloc] init];
					
					CGFloat padding = 10.0f;
					CGFloat labelWidth = [[_readingService loginLabel] sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]].width;
					[_usernameField setFrame:CGRectMake(2.0f * padding + labelWidth, 0.0f, [cell contentView].bounds.size.width - 3.0 * padding - labelWidth, [cell contentView].bounds.size.height)];
					[_usernameField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
					[_usernameField setReturnKeyType:UIReturnKeyNext];
					[_usernameField setDelegate:self];
					[_usernameField setKeyboardType:UIKeyboardTypeEmailAddress];
					[_usernameField setAutocorrectionType:UITextAutocorrectionTypeNo];
					[_usernameField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
					[_usernameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
					
					[_usernameField becomeFirstResponder];
				}
				[[cell contentView] addSubview:_usernameField];
			} else {
				[_usernameField removeFromSuperview];
				[[cell textLabel] setText:[NSString stringWithFormat:@"Logged in as %@", [_readingService username]]];
			}

		} else {
			[[cell textLabel] setText:@"Password"];
			
			if (!_passwordField) {
				_passwordField = [[UITextField alloc] init];
				
				CGFloat padding = 10.0f;
				CGFloat labelWidth = [@"Password" sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]].width;
				[_passwordField setFrame:CGRectMake(2.0f * padding + labelWidth, 0.0f, [cell contentView].bounds.size.width - 3.0f * padding - labelWidth, [cell contentView].bounds.size.height)];
				[_passwordField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
				[_passwordField setReturnKeyType:UIReturnKeyGo];
				[_passwordField setDelegate:self];
				[_passwordField setSecureTextEntry:YES];
				[_passwordField setClearsOnBeginEditing:YES];
				[_passwordField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
			}
			
			[[cell contentView] addSubview:_passwordField];
		}
		
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	} else {
		[[cell textLabel] setFont:[UIFont boldSystemFontOfSize:18.0f]];
		if ([_readingService isLoggedIn]) {
			[[cell textLabel] setText:@"Log Out"];
		} else {
			[[cell textLabel] setText:@"Log In"];
		}
		[[cell textLabel] setTextAlignment:UITextAlignmentCenter];
	}
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if (section == 0) {
		if (_isLoading) {
			return @"Signing in...";
		}
	}
	
	return nil;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (![_readingService isLoggedIn]) {
		if (indexPath.section == 0) {
			if (indexPath.row == 0) {
				[_usernameField becomeFirstResponder];
			} else {
				[_passwordField becomeFirstResponder];
			}
		} else {
			// log in
			
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			[self _logIn];
		}
	} else {
		if (indexPath.section == 1) {
			[_readingService logout];
			[[self tableView] reloadData];
			[_usernameField becomeFirstResponder];
			
			[[self navigationItem] setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_cancel)] autorelease]];
		}
	}
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == _usernameField) {
		[_passwordField becomeFirstResponder];
	} else {
		[self _logIn];
	}
	
	return YES;
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[[self tableView] reloadData];
	[_usernameField becomeFirstResponder];
}

#pragma mark -
#pragma mark Custom Initialization

- (id)initWithService:(Class)service {
	if ((self = [self init])) {
		_readingService = [service retain];
	}
	
	return self;
}

#pragma mark -
#pragma mark Private Actions

- (void)_logIn {
	[_usernameField resignFirstResponder];
	[_passwordField resignFirstResponder];
	
	[_usernameField setUserInteractionEnabled:NO];
	[_passwordField setUserInteractionEnabled:NO];
	
	_isLoading = YES;
	[[self tableView] reloadData];
	
	[_readingService authorizeWithUsername:[_usernameField text] password:[_passwordField text] callback:^(BOOL success){
		[_usernameField setUserInteractionEnabled:YES];
		[_passwordField setUserInteractionEnabled:YES];
		
		_isLoading = NO;
		
		if (success) {
			[_usernameField release];
			[_usernameField removeFromSuperview];
			_usernameField = nil;
			[_passwordField release];
			[_passwordField removeFromSuperview];
			_passwordField = nil;
			
			[[self navigationItem] setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_cancel)] autorelease]];
			
			[[self tableView] reloadData];
			
		} else {
			[[[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Couldn't sign in to %@ at this time. Check your username, password, and connectivity.", [_readingService name]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		}
	}];
}

- (void)_cancel {
	[self dismissModalViewControllerAnimated:YES];
}

@end
