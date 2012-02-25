//
//  WelcomeVc.h
//  Ragefac
//
//  Created by Kida Marcus on 28.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface WelcomeVc : UIViewController
{
    AppDelegate *appDelegate;
    
    /* GUI */
    IBOutlet UILabel *totalFacesLabel;
    IBOutlet UILabel *totalViewsLabel;
    
}

- (void)refreshStatistics:(id)sender;

@end
