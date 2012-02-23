// TJDelicious
// By Tim Johnsen

#import "TJDelicious.h"
#import "NSData+Base64.h"

@implementation TJDelicious

#pragma mark -
#pragma mark Strings

+ (NSString *)name {
	return @"Delicious";
}

+ (NSString *)signUpURL {
	return @"https://delicious.com/register";
}

#pragma mark -
#pragma mark Private

+ (NSURLRequest *)_requestForAuthWithUsername:(NSString *)username password:(NSString *)password {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.del.icio.us/v1/posts/recent"]]];
	[request setValue:[NSString stringWithFormat:@"Basic %@", [[[NSString stringWithFormat:@"%@:%@", username, password] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString]] forHTTPHeaderField:@"Authorization"];
	[request setHTTPMethod:@"POST"];
	return request;
}

+ (NSURLRequest *)_requestForSaveURL:(NSString *)url title:(NSString *)title {
	NSString *requestString = [NSString stringWithFormat:@"https://api.del.icio.us/v1/posts/add?url=%@&description=%@", url, title ? title : url];
	if (!title) {
		NSLog(@"[TJReadLater] ERROR: delicious API does not support bookmarking without titles, adding URL as the title");
	}
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
	[request setValue:[NSString stringWithFormat:@"Basic %@", [[[NSString stringWithFormat:@"%@:%@", [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Username", NSStringFromClass(self)]], [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Password", NSStringFromClass(self)]]] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString]] forHTTPHeaderField:@"Authorization"];
	[request setHTTPMethod:@"POST"];
			
	return request;
}

@end
