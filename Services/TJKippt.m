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

#pragma mark -
#pragma mark Private

+ (NSURLRequest *)_requestForAuthWithUsername:(NSString *)username password:(NSString *)password {
	NSMutableURLRequest *request = nil;
	
	request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://kippt.com/api/v0/account/verify/"]]];
	[request setValue:[NSString stringWithFormat:@"Basic %@", [[[NSString stringWithFormat:@"%@:%@", username, password] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString]] forHTTPHeaderField:@"Authorization"];
	
	[request setHTTPMethod:@"GET"];
	
	return request;
}

+ (NSURLRequest *)_requestForSaveURL:(NSString *)url title:(NSString *)title {
	NSMutableURLRequest *request = nil;
	return request;
}


@end
