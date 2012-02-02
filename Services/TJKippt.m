// TJKippt
// By Tim Johnsen

#import "TJKippt.h"
#import "NSData+Base64.h"

@implementation TJKippt

#pragma mark -
#pragma mark Strings

+ (NSString *)name {
	return @"Kippt";
}

+ (NSString *)signUpURL {
	return @"http://kippt.com/signup";
}

#pragma mark -
#pragma mark Private

+ (NSURLRequest *)_requestForAuthWithUsername:(NSString *)username password:(NSString *)password {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://kippt.com/api/v0/account/verify/"]]];
	[request setValue:[NSString stringWithFormat:@"Basic %@", [[[NSString stringWithFormat:@"%@:%@", username, password] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString]] forHTTPHeaderField:@"Authorization"];
	
	[request setHTTPMethod:@"GET"];
	
	return request;
}

+ (NSURLRequest *)_requestForSaveURL:(NSString *)url title:(NSString *)title {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://kippt.com/api/v0/clips/"]]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	// Message body
	NSMutableString *body = [NSMutableString stringWithFormat:@"{ \"url\": \"%@\"", url];
	if (title) {
		[body appendFormat:@", \"title\": \"%@\"", title];
	}
	[body appendString:@" }"];
	
	[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];

	// Auth
	[request setValue:[NSString stringWithFormat:@"Basic %@", [[[NSString stringWithFormat:@"%@:%@", [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Username", NSStringFromClass(self)]], [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Password", NSStringFromClass(self)]]] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString]] forHTTPHeaderField:@"Authorization"];
	
	return request;
}

+ (int)_saveSuccessCode {
	return 201;
}

@end
