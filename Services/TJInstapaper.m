// TJInstapaper
// By Tim Johnsen

#import "TJInstapaper.h"


@implementation TJInstapaper

#pragma mark -
#pragma mark Strings

+ (NSString *)name {
	return @"Instapaper";
}

+ (NSString *)loginLabel {
	return @"Username/Email";
}

+ (NSString *)signUpURL {
	return @"http://www.instapaper.com/user/register";
}

#pragma mark -
#pragma mark Private

+ (NSURLRequest *)_requestForAuthWithUsername:(NSString *)username password:(NSString *)password {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.instapaper.com/api/authenticate?username=%@&password=%@", username, password]]];
	[request setHTTPMethod:@"POST"];
	return request;
}

+ (NSURLRequest *)_requestForSaveURL:(NSString *)url title:(NSString *)title {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[@"https://www.instapaper.com/api/add" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	[request setHTTPMethod:@"POST"];
	
	NSString *requestString = [NSString stringWithFormat:@"username=%@&password=%@&url=%@", [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Username", NSStringFromClass(self)]], [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Password", NSStringFromClass(self)]], url];
	if (title) {
		requestString = [requestString stringByAppendingFormat:@"&title=%@", [title stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	}
	NSData *requestData = [NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
	[request setHTTPBody:requestData];
	
	return request;
}

+ (int)_saveSuccessCode {
	return 201;
}

@end