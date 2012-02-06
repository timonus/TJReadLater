// TJReadItLater
// By Tim Johnsen

#import "TJReadItLater.h"
#import "TJConfig.h"

#ifndef READ_IT_LATER_API_KEY
#warning Missing Read It Later API Key
#endif

#ifndef READ_IT_LATER_APP_NAME
#warning Missing Read It Later App Name
#endif


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
#pragma mark Private

+ (NSURLRequest *)_requestForAuthWithUsername:(NSString *)username password:(NSString *)password {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://readitlaterlist.com/v2/auth?username=%@&password=%@&apikey=%@", username, password, READ_IT_LATER_API_KEY]]];	
	[request setValue:READ_IT_LATER_APP_NAME forHTTPHeaderField:@"User-Agent"];
		
	return request;
}

+ (NSURLRequest *)_requestForSaveURL:(NSString *)url title:(NSString *)title {
	NSString *requestURL = [NSString stringWithFormat:@"https://readitlaterlist.com/v2/add?username=%@&password=%@&apikey=%@&url=%@", [self username], [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Password", NSStringFromClass(self)]], READ_IT_LATER_API_KEY, url];
	if (title) {
		requestURL = [requestURL stringByAppendingFormat:@"&title=%@", title];
	}
	requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
	[request setValue:READ_IT_LATER_APP_NAME forHTTPHeaderField:@"User-Agent"];
	
	return request;
}

@end