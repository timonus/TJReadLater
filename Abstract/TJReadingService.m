// TJReadingService
// By Tim Johnsen

#import "TJReadingService.h"
#import "TJReadLater.h"

@interface TJReadingService ()

+ (NSURLRequest *)_requestForAuthWithUsername:(NSString *)username password:(NSString *)password;
+ (int)_authSuccessCode;

+ (NSURLRequest *)_requestForSaveURL:(NSString *)url title:(NSString *)title;
+ (int)_saveSuccessCode;

@end

@implementation TJReadingService

#pragma mark -
#pragma mark Strings

+ (NSString *)name {
	return nil;
}

+ (NSString *)loginLabel {
	return @"Username";
}

+ (NSString *)signUpURL {
	return nil;
}

#pragma mark -
#pragma mark Authorization Details

+ (BOOL)isLoggedIn {
	return ([self username] != nil);
}

+ (NSString *)username {
	return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Username", NSStringFromClass(self)]];
}

+ (void)logout {
	[self saveUsername:nil password:nil];
}

#pragma mark -
#pragma mark Authorization Actions

+ (void)authorizeWithUsername:(NSString *)username password:(NSString *)password callback:(void (^)(BOOL success))callback {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSURLRequest *request = [self _requestForAuthWithUsername:username password:password];
		
		NSURLResponse *response = nil;
		NSError *error = nil;
		
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		
		BOOL success = !error && [(NSHTTPURLResponse *)response statusCode] == [self _authSuccessCode];
		
		if (success) {
			[self saveUsername:username password:password];
		}
		
		if (callback) {
			dispatch_async(dispatch_get_main_queue(), ^{
				callback(success);
			});
		}
	});
}


+ (void)saveUsername:(NSString *)username password:(NSString *)password {
	if (username && password) {
		[[NSUserDefaults standardUserDefaults] setObject:username forKey:[NSString stringWithFormat:@"%@Username", NSStringFromClass(self)]];
		[[NSUserDefaults standardUserDefaults] setObject:password forKey:[NSString stringWithFormat:@"%@Password", NSStringFromClass(self)]];
	} else {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@Username", NSStringFromClass(self)]];
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@Password", NSStringFromClass(self)]];
	}
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark URL Saving

+ (void)saveURL:(NSString *)url title:(NSString *)title callback:(void (^)(BOOL success))callback {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		NSURLRequest *request = [self _requestForSaveURL:url title:title];
		
		NSURLResponse *response = nil;
		NSError *error = nil;
		
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		
		BOOL success = !error && [(NSHTTPURLResponse *)response statusCode] == [self _saveSuccessCode];
		
		if (callback) {
			dispatch_async(dispatch_get_main_queue(), ^{
				callback(success);
			});
		}
	});
}

#pragma mark -
#pragma mark Authorization View Controllers

+ (UIViewController *)authorizationViewController {
	return [[[UINavigationController alloc] initWithRootViewController:[[[TJReadingServiceViewController alloc] initWithService:self] autorelease]] autorelease];
}

#pragma mark -
#pragma mark All Services

+ (NSArray *)readingServices {
	return [NSArray arrayWithObjects:[TJInstapaper class], [TJPocket class], [TJReadability class], [TJPinboard class], [TJDelicious class], [TJKippt class], nil];
}

#pragma mark -
#pragma mark Private

+ (NSURLRequest *)_requestForAuthWithUsername:(NSString *)username password:(NSString *)password {
	return nil;
}

+ (int)_authSuccessCode {
	return 200;
}

+ (NSURLRequest *)_requestForSaveURL:(NSString *)url title:(NSString *)title {
	return nil;
}

+ (int)_saveSuccessCode {
	return 200;
}

@end
