//
//  AppDelegate.h
//  Ragefac
//
//  Created by Kida Marcus on 27.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+URLEncoding.h"

#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "DSActivityView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,ASIHTTPRequestDelegate,ASIProgressDelegate>
{
    NSOperationQueue *queue;
    
    /* apiQuery */
    int apiLastFacesCount;
    int apiLastTotalCount;
    
    /* apiQuery Categories */
    NSArray *categoriesArray;
    
    /* apiQuery Tags */
    NSArray *tagsArray;
    
    /* apiQuery Cat */
    NSArray *catArray;
    
    /* apiQuery Tag */
    NSArray *tagArray;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) int apiLastFacesCount;
@property (nonatomic, assign) int apiLastTotalCount;

@property (nonatomic, strong) NSArray *categoriesArray;

@property (nonatomic, strong) NSArray *tagsArray;

@property (nonatomic, strong) NSArray *catArray;

@property (nonatomic, strong) NSArray *tagArray;

- (void)showAlert:(NSString*)title withMessage:(NSString*)body;

- (void)apiQuery:(id)sender;
- (void)apiQueryCategories:(id)sender;
- (void)apiQueryTags:(id)sender;
- (void)apiQueryCat:(NSString*)catname;
- (void)apiQueryTag:(NSString*)tagname;

@end
