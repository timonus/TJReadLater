// TJReadItLater
// By Tim Johnsen

#import "TJReadItLater.h"

#define API_KEY @"API-KEY"
#define APP_NAME @"APP-NAME"

@interface TJReadItLater ()

- (void)_authWithUsername:(NSString *)username password:(NSString *)password delegate:(id)delegate;
- (BOOL)_saveURL:(NSString *)url title:(NSString *)title delegate:(id)delegate;

@end

@implementation TJReadItLater

#pragma mark -
#pragma mark NSObject

- (void)dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark Strings

+ (NSString *)name {
	return @"Read It Later";
}

+ (NSString *)loginLabel {
	return @"Username";
}

#pragma mark -
#pragma mark Auth

+ (BOOL)hasAuth {
	return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Username", [[self class] description]]] != nil && [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Password", [[self class] description]]] != nil;
}

+ (void)logout {
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@Username", [[self class] description]]];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@Password", [[self class] description]]];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)username {
	return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Username", [[self class] description]]];
}

+ (void)authWithUsername:(NSString *)username password:(NSString *)password delegate:(id <TJReadItLaterDelegate>)delegate {
	id engine = [[self alloc] init];
	[engine authWithUsername:username password:password delegate:delegate];
}

#pragma mark -
#pragma mark URL Saving

+ (BOOL)saveURL:(NSString *)url title:(NSString *)title delegate:(id)delegate {
	if ([self hasAuth]) {
		id engine = [[self alloc] init];
		return [engine saveURL:url title:title delegate:delegate];
	}
	return NO;
}

#pragma mark -
#pragma mark Private Methods

- (void)_authWithUsername:(NSString *)username password:(NSString *)password delegate:(id)delegate {
	authUsername = [username retain];
	authPassword = [password retain];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://readitlaterlist.com/v2/auth?username=%@&password=%@&apikey=%@", username, password, API_KEY]]];
	
	[request setValue:APP_NAME forHTTPHeaderField:@"User-Agent"];
	
	authConnection = [NSURLConnection connectionWithRequest:request delegate:self];
	authData = [[NSMutableData alloc] init];
	authDelegate = [delegate retain];
}

- (BOOL)_saveURL:(NSString *)url title:(NSString *)title delegate:(id)delegate {
	if ([[self class] hasAuth]) {
		
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"https://readitlaterlist.com/v2/add?username=%@&password=%@&apikey=%@&url=%@&title=%@", [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Username", [[self class] description]]], [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Password", [[self class] description]]], API_KEY, url, title] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
		[request setValue:APP_NAME forHTTPHeaderField:@"User-Agent"];
		
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

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	if ([authDelegate respondsToSelector:@selector(authFinishedWithResult:)]) {
		[authDelegate authFinishedWithResult:NO];
	}
	
	authConnection = nil;
	[authData release];
	authData = nil;
	[authDelegate release];
	authDelegate = nil;
	
	[self release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if (connection == authConnection) {
		[authData appendData:data];
	} else {
		[saveData appendData:data];
	}
}

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
			[saveDelegate saveFinishedWithResult:[[[[NSString alloc] initWithData:saveData encoding:NSASCIIStringEncoding] autorelease] rangeOfString:@"200"].location != NSNotFound];
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