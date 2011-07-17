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

#pragma mark -
#pragma mark Private Methods

- (void)_authWithUsername:(NSString *)username password:(NSString *)password delegate:(id)delegate{
	authUsername = [username retain];
	authPassword = [password retain];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.instapaper.com/api/authenticate?username=%@&password=%@", username, password]]];
	[request setHTTPMethod:@"POST"];
	
	authConnection = [NSURLConnection connectionWithRequest:request delegate:self];
	authData = [[NSMutableData alloc] init];
	authDelegate = [delegate retain];
}

- (BOOL)_saveURL:(NSString *)url title:(NSString *)title delegate:(id)delegate{
	if ([[self class] hasAuth]) {
		
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[@"https://www.instapaper.com/api/add" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
		[request setHTTPMethod:@"POST"];
		
		NSString *requestString = [NSString stringWithFormat:@"username=%@&password=%@&url=%@", [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Username", [[self class] description]]], [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Password", [[self class] description]]], url];
		NSData *requestData = [NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
		[request setHTTPBody:requestData];
		
		saveConnection = [NSURLConnection connectionWithRequest:request delegate:self];
		saveData = [[NSMutableData alloc] init];
		saveDelegate = [delegate retain];
		
		return YES;
	}
	
	[self release];
	
	return NO;
}

#pragma mark -
#pragma mark NSURLConnectionDelegate

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	
	if (connection == authConnection) {
		
		if ([[[[NSString alloc] initWithData:authData encoding:NSASCIIStringEncoding] autorelease] rangeOfString:@"200"].location != NSNotFound) {
			[[NSUserDefaults standardUserDefaults] setObject:authUsername forKey:[NSString stringWithFormat:@"%@Username", [[self class] description]]];
			[[NSUserDefaults standardUserDefaults] setObject:authPassword forKey:[NSString stringWithFormat:@"%@Password", [[self class] description]]];
		}
		
		[authUsername release];
		[authPassword release];
		
		if ([authDelegate respondsToSelector:@selector(authFinishedWithResult:)]) {
			[authDelegate authFinishedWithResult:[[[[NSString alloc] initWithData:authData encoding:NSASCIIStringEncoding] autorelease] rangeOfString:@"200"].location != NSNotFound];
		}
		
		authConnection = nil;
		[authData release];
		authData = nil;
		[authDelegate release];
		authDelegate = nil;
		
		[self release];
	}
	
	if (connection == saveConnection) {
		
		if ([saveDelegate respondsToSelector:@selector(saveFinishedWithResult:)]) {
			[saveDelegate saveFinishedWithResult:[[[[NSString alloc] initWithData:saveData encoding:NSASCIIStringEncoding] autorelease] rangeOfString:@"201"].location != NSNotFound];
		}
		
		saveConnection = nil;
		[saveData release];
		saveData = nil;
		[saveDelegate release];
		saveDelegate = nil;
		
		[self release];
	}
}

@end
