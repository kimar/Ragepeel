//
//  AppDelegate.m
//  Ragefac
//
//  Created by Kida Marcus on 27.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "Constants.h"
#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

@synthesize apiLastFacesCount,apiLastTotalCount;

@synthesize categoriesArray;

@synthesize tagsArray;

@synthesize catArray;

@synthesize tagArray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    queue=[[NSOperationQueue alloc] init];
    categoriesArray=[[NSArray alloc] init];
    tagsArray=[[NSArray alloc] init];
    catArray=[[NSArray alloc] init];
    tagArray=[[NSArray alloc] init];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    /* Do the initial query */
    [self apiQuery:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)showAlert:(NSString *)title withMessage:(NSString *)body
{
    UIAlertView*al=[[UIAlertView alloc] initWithTitle:title
                                              message:body
                                             delegate:self
                                    cancelButtonTitle:@"OK'"
                                    otherButtonTitles:nil, nil];
    [al show];
}

#pragma mark - API functions
- (void)apiQuery:(id)sender
{
    NSString *apiUrlString=[NSString stringWithFormat:@"%@",kApiUrl];
    NSURL *apiUrl=[NSURL URLWithString:apiUrlString];
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:apiUrl];
    [request setTimeOutSeconds:kApiTimeout];
    [request setDelegate:self];
    [request setValidatesSecureCertificate:kApiValidateSsl];
    [request setDidFinishSelector:@selector(apiQueryFinished:)];
    [request setDidFailSelector:@selector(apiQueryFailed:)];

    if(!queue)
    {
        queue=[[NSOperationQueue alloc] init];
    }
    
    [queue addOperation:request];
}

- (void)apiQueryFinished:(ASIHTTPRequest*)request
{
    if(kDebug)NSLog(@"DEBUG: apiQueryFinished: %@",[request responseString]);
    NSDictionary *dict=[[request responseString] JSONValue];
    apiLastFacesCount=[[dict objectForKey:@"total_faces"] intValue];
    apiLastTotalCount=[[dict objectForKey:@"total_views"] intValue];
    if(kDebug)NSLog(@"DEBUG: apiLastFacesCount=%d, apiLastTotalCount=%d",apiLastFacesCount,apiLastTotalCount);
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationApiQueryDone object:nil];
}

- (void)apiQueryFailed:(ASIHTTPRequest*)request
{
    if(kDebug)NSLog(@"DEBUG: apiQueryFailed: %@",[request responseString]);
}

- (void)apiQueryCategories:(id)sender
{
    [DSBezelActivityView activityViewForView:self.window withLabel:@"Loading..."];
    NSString *apiUrlString=[NSString stringWithFormat:@"%@/all/cats",kApiUrl];
    NSURL *apiUrl=[NSURL URLWithString:apiUrlString];
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:apiUrl];
    [request setTimeOutSeconds:kApiTimeout];
    [request setDelegate:self];
    [request setValidatesSecureCertificate:kApiValidateSsl];
    [request setDidFinishSelector:@selector(apiQueryCategoriesFinished:)];
    [request setDidFailSelector:@selector(apiQueryCategoriesFailed:)];
    
    if(!queue)
    {
        queue=[[NSOperationQueue alloc] init];
    }
    
    [queue addOperation:request];
}

- (void)apiQueryCategoriesFinished:(ASIHTTPRequest*)request
{
    [DSBezelActivityView removeViewAnimated:YES];
    if(kDebug)NSLog(@"DEBUG: apiQueryCategories: %@",[request responseString]);
    NSDictionary *dict=[[request responseString] JSONValue];
    categoriesArray=[dict objectForKey:@"items"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationApiQueryCategoriesDone object:nil];
}

- (void)apiQueryCategoriesFailed:(ASIHTTPRequest*)request
{
    [DSBezelActivityView removeViewAnimated:YES];
    if(kDebug)NSLog(@"DEBUG: apiQueryCategories: %@",[request responseString]);
}

- (void)apiQueryTags:(id)sender
{
    [DSBezelActivityView activityViewForView:self.window withLabel:@"Loading..."];
    NSString *apiUrlString=[NSString stringWithFormat:@"%@/all/tags",kApiUrl];
    NSURL *apiUrl=[NSURL URLWithString:apiUrlString];
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:apiUrl];
    [request setTimeOutSeconds:kApiTimeout];
    [request setDelegate:self];
    [request setValidatesSecureCertificate:kApiValidateSsl];
    [request setDidFinishSelector:@selector(apiQueryTagsFinished:)];
    [request setDidFailSelector:@selector(apiQueryTagsFailed:)];
    
    if(!queue)
    {
        queue=[[NSOperationQueue alloc] init];
    }
    
    [queue addOperation:request];
}

- (void)apiQueryTagsFinished:(ASIHTTPRequest*)request
{
    [DSBezelActivityView removeViewAnimated:YES];
    if(kDebug)NSLog(@"DEBUG: apiQueryTags: %@",[request responseString]);
    NSDictionary *dict=[[request responseString] JSONValue];
    tagsArray=[dict objectForKey:@"items"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationApiQueryTagsDone object:nil];
}

- (void)apiQueryTagsFailed:(ASIHTTPRequest*)request
{
    [DSBezelActivityView removeViewAnimated:YES];
    if(kDebug)NSLog(@"DEBUG: apiQueryTags: %@",[request responseString]);
}

- (void)apiQueryCat:(NSString*)catname
{
    [DSBezelActivityView activityViewForView:self.window withLabel:@"Loading..."];
    NSString *apiUrlString=[NSString stringWithFormat:@"%@/cat/%@",kApiUrl,[catname urlEncodeUsingEncoding:NSUTF8StringEncoding]];
    NSURL *apiUrl=[NSURL URLWithString:apiUrlString];
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:apiUrl];
    [request setTimeOutSeconds:kApiTimeout];
    [request setDelegate:self];
    [request setValidatesSecureCertificate:kApiValidateSsl];
    [request setDidFinishSelector:@selector(apiQueryCatFinished:)];
    [request setDidFailSelector:@selector(apiQueryCatFailed:)];
    
    if(!queue)
    {
        queue=[[NSOperationQueue alloc] init];
    }
    
    [queue addOperation:request];
}

- (void)apiQueryCatFinished:(ASIHTTPRequest*)request
{
    [DSBezelActivityView removeViewAnimated:YES];
    if(kDebug)NSLog(@"DEBUG: apiQueryCatFinished: %@",[request responseString]);
    NSDictionary *dict=[[request responseString] JSONValue];
    catArray=[dict objectForKey:@"items"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationApiQueryCatDone object:nil];
}

- (void)apiQueryCatFailed:(ASIHTTPRequest*)request
{
    [DSBezelActivityView removeViewAnimated:YES];
    if(kDebug)NSLog(@"DEBUG: apiQueryCatFailed: %@",[request responseString]);
}

- (void)apiQueryTag:(NSString*)tagname
{
    [DSBezelActivityView activityViewForView:self.window withLabel:@"Loading..."];
    NSString *apiUrlString=[NSString stringWithFormat:@"%@/tag/%@",kApiUrl,[tagname urlEncodeUsingEncoding:NSUTF8StringEncoding]];
    NSURL *apiUrl=[NSURL URLWithString:apiUrlString];
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:apiUrl];
    [request setTimeOutSeconds:kApiTimeout];
    [request setDelegate:self];
    [request setValidatesSecureCertificate:kApiValidateSsl];
    [request setDidFinishSelector:@selector(apiQueryTagFinished:)];
    [request setDidFailSelector:@selector(apiQueryTagFailed:)];
    
    if(!queue)
    {
        queue=[[NSOperationQueue alloc] init];
    }
    
    [queue addOperation:request];
}

- (void)apiQueryTagFinished:(ASIHTTPRequest*)request
{
    [DSBezelActivityView removeViewAnimated:YES];
    if(kDebug)NSLog(@"DEBUG: apiQueryTagFinished: %@",[request responseString]);
    NSDictionary *dict=[[request responseString] JSONValue];
    tagArray=[dict objectForKey:@"items"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationApiQueryTagDone object:nil];
}

- (void)apiQueryTagFailed:(ASIHTTPRequest*)request
{
    [DSBezelActivityView removeViewAnimated:YES];
    if(kDebug)NSLog(@"DEBUG: apiQueryTagFailed: %@",[request responseString]);
}

@end
