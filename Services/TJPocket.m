// TJReadItLater
// By Tim Johnsen

#import "TJPocket.h"
#import "TJReadLaterConfig.h"

@implementation TJPocket

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
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://readitlaterlist.com/v2/auth?username=%@&password=%@&apikey=%@", username, password, (NSString *)kTJReadLaterReadItLaterAPIKey]]];	
	[request setValue:(NSString *)kTJReadLaterReadItLaterAppName forHTTPHeaderField:@"User-Agent"];
		
	return request;
}

+ (NSURLRequest *)_requestForSaveURL:(NSString *)url title:(NSString *)title {
	NSString *requestURL = [NSString stringWithFormat:@"https://readitlaterlist.com/v2/add?username=%@&password=%@&apikey=%@&url=%@", [self username], [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Password", NSStringFromClass(self)]], (NSString *)kTJReadLaterReadItLaterAPIKey, url];
	if (title) {
		requestURL = [requestURL stringByAppendingFormat:@"&title=%@", title];
	}
	requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
	[request setValue:(NSString *)kTJReadLaterReadItLaterAppName forHTTPHeaderField:@"User-Agent"];
	
	return request;
}

@end