// TJPinboard
// By Tim Johnsen

#import "TJPinboard.h"
#import "NSData+Base64.h"

@implementation TJPinboard

#pragma mark -
#pragma mark Strings

+ (NSString *)name {
	return @"Pinboard";
}

#pragma mark -
#pragma mark Authorization

+ (NSURLRequest *)_requestForAuthWithUsername:(NSString *)username password:(NSString *)password {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@:%@@api.pinboard.in/v1/posts/recent", username, password]]];			
	[request setHTTPMethod:@"POST"];
	
	return request;
}

+ (NSURLRequest *)_requestForSaveURL:(NSString *)url title:(NSString *)title {
	NSString *requestURL = [NSString stringWithFormat:@"https://%@:%@@api.pinboard.in/v1/posts/add?url=%@&description=%@", [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Username", NSStringFromClass(self)]], [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Password", NSStringFromClass(self)]], url, title ? title : url];
	if (!title) {
		NSLog(@"[TJReadLater] ERROR: Pinboard API does not support bookmarking without titles, adding URL as the title");
	}
	
	requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
	
	return request;
}

@end
