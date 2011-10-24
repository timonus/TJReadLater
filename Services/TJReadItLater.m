// TJReadItLater
// By Tim Johnsen

#import "TJReadItLater.h"

#warning Missing Read It Later Credentials
#define API_KEY @"<Your API Key Here>"
#define APP_NAME @"<Your App Name Here>"

@implementation TJReadItLater

#pragma mark -
#pragma mark Strings

+ (NSString *)name {
	return @"Read It Later";
}

+ (NSString *)signUpURL {
	return @"http://readitlaterlist.com/signup";
}

#pragma mark -
#pragma mark Authorization

+ (void)authorizeWithUsername:(NSString *)username password:(NSString *)password callback:(void (^)(BOOL success))callback {
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://readitlaterlist.com/v2/auth?username=%@&password=%@&apikey=%@", username, password, API_KEY]]];
		
		[request setValue:APP_NAME forHTTPHeaderField:@"User-Agent"];
		
		NSURLResponse *response = nil;
		NSError *error = nil;
		
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		
		BOOL success = !error && [(NSHTTPURLResponse *)response statusCode] == 200;
		
		if (success) {
			[[NSUserDefaults standardUserDefaults] setObject:username forKey:[NSString stringWithFormat:@"%@Username", NSStringFromClass(self)]];
			[[NSUserDefaults standardUserDefaults] setObject:password forKey:[NSString stringWithFormat:@"%@Password", NSStringFromClass(self)]];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
		
		if (callback) {
			dispatch_async(dispatch_get_main_queue(), ^{
				callback(success);
			});
		}
	});
}

#pragma mark -
#pragma mark URL Saving

+ (void)saveURL:(NSString *)url title:(NSString *)title callback:(void (^)(BOOL success))callback {
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		
		NSString *requestURL = [NSString stringWithFormat:@"https://readitlaterlist.com/v2/add?username=%@&password=%@&apikey=%@&url=%@", [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Username", NSStringFromClass(self)]], [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Password", NSStringFromClass(self)]], API_KEY, url];
		
		if (title) {
			requestURL = [requestURL stringByAppendingFormat:@"&title=%@", title];
		}
						 
		requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
		
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
		
		[request setValue:APP_NAME forHTTPHeaderField:@"User-Agent"];
		
		NSURLResponse *response = nil;
		NSError *error = nil;
		
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		
		BOOL success = !error && [(NSHTTPURLResponse *)response statusCode] == 200;
		
		if (!success) {
			if ([(NSHTTPURLResponse *)response statusCode] == 401) {
				// Username or password changed
				[self logout];
			}
		}
		
		if (callback) {
			dispatch_async(dispatch_get_main_queue(), ^{
				callback(success);
			});
		}
	});
}

@end