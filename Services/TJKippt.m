// TJKippt
// By Tim Johnsen

#import "TJKippt.h"

#warning Missing Kippt API Key
#define API_KEY @""

@implementation TJKipptService

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
	return request;
}

+ (NSURLRequest *)_requestForSaveURL:(NSString *)url title:(NSString *)title {
	NSMutableURLRequest *request = nil;
	return request;
}


@end
