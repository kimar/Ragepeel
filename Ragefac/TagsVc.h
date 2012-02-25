//
//  TagsVc.h
//  Ragefaces
//
//  Created by Kida Marcus on 30.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import "FGalleryViewController.h"
#import "DSActivityView.h"

#import "SHKTwitter.h"
#import "SHKFacebook.h"

@interface TagsVc : UIViewController <UITableViewDataSource,UITableViewDelegate,FGalleryViewControllerDelegate,UIActionSheetDelegate>
{
    AppDelegate *appDelegate;
    
    /* GUI */
    IBOutlet UITableView *mainTableView;
    
    /* Gallery */
     FGalleryViewController *galleryVc;
    NSMutableArray *captionsArray;
    NSMutableArray *imagesArray;
}

- (void)refreshTags:(id)sender;
- (void)showGallery:(id)sender;
- (void)saveFace:(id)sender;
- (void)shareFace:(id)sender;

@end
