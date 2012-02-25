//
//  TagsVc.m
//  Ragefaces
//
//  Created by Kida Marcus on 30.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"
#import "TagsVc.h"

@implementation TagsVc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    captionsArray=[[NSMutableArray alloc] init];
    imagesArray=[[NSMutableArray alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTags:) name:kNotificationApiQueryTagsDone object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGallery:) name:kNotificationApiQueryTagDone object:nil];
    
    if([appDelegate.tagsArray count]==0)[appDelegate apiQueryTags:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationApiQueryTagsDone object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationApiQueryTagDone object:nil];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [appDelegate.tagsArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TagCell"];
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    if([appDelegate.tagsArray count]>indexPath.row)
    {
        cell.textLabel.text=[[appDelegate.tagsArray objectAtIndex:indexPath.row] objectForKey:@"tag_name"];
        /*cell.textLabel.textColor=[UIColor colorWithRed:239.0/255.0 
                                                 green:62.0/255.0
                                                  blue:243.0/255.0
                                                 alpha:1.0];*/
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([appDelegate.tagsArray count]>indexPath.row)
    {
        [appDelegate apiQueryTag:[[appDelegate.tagsArray objectAtIndex:indexPath.row] objectForKey:@"tag_name"]];
    }
}

#pragma mark - FGalleryViewControllerDelegate Methods

- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num=[imagesArray count];
	return num;
}

- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
	return FGalleryPhotoSourceTypeNetwork;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption=[captionsArray objectAtIndex:index];
	return caption;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index 
{
    return [imagesArray objectAtIndex:index];
}

- (void)refreshTags:(id)sender
{
    if(kDebug)NSLog(@"DEBUG: refreshTags");
    if([appDelegate.tagsArray count]>0)
    {
        [mainTableView reloadData];
    }
}

- (void)showGallery:(id)sender
{
    [captionsArray removeAllObjects];
    [imagesArray removeAllObjects];
    for (int i=0; i<[appDelegate.tagArray count]; i++)
    {
        int faceHidden=[[[appDelegate.tagArray objectAtIndex:i] objectForKey:@"face_hidden"] intValue];
        if(kShowHiddenFaces) faceHidden=0;
        if(faceHidden==0)
        {
            [captionsArray addObject:[[appDelegate.tagArray objectAtIndex:i] objectForKey:@"face_humanread_name"]];
            [imagesArray addObject:[[appDelegate.tagArray objectAtIndex:i] objectForKey:@"face_url"]];
        }
    }
    if(kDebug)NSLog(@"DEBUG: captionsArray count=%d\nDEBUG: imagesArray count=%d",[captionsArray count],[imagesArray count]);
    
    UIBarButtonItem *saveFaceButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(saveFace:)];
    
    UIBarButtonItem *shareFaceButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareFace:)];
    
    UIBarButtonItem *flexSpaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *barItems=[NSArray arrayWithObjects:flexSpaceButton,flexSpaceButton,saveFaceButton,flexSpaceButton,shareFaceButton,nil];
    
    galleryVc=[[FGalleryViewController alloc] initWithPhotoSource:self barItems:barItems];
    [self.navigationController pushViewController:galleryVc animated:YES];
}

- (void)saveFace:(id)sender
{
    if(kDebug)NSLog(@"DEBUG: saveFace");
    [DSBezelActivityView activityViewForView:galleryVc.view withLabel:@"Saving..."];
    [self performSelectorInBackground:@selector(saveFaceTask:) withObject:nil];
}

- (void)shareFace:(id)sender
{
    if(kDebug)NSLog(@"DEBUG: shareFace");
    UIActionSheet*as=[[UIActionSheet alloc] initWithTitle:nil
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"Facebook",@"Twitter",nil];
    [as showFromTabBar:galleryVc.tabBarController.tabBar];
}

- (void)saveFaceTask:(id)sender
{
    NSURL *url=[NSURL URLWithString:[[appDelegate.tagArray objectAtIndex:[galleryVc currentIndex]] objectForKey:@"face_url"]];
    NSData *data=[NSData dataWithContentsOfURL:url];
    UIImage *image=[UIImage imageWithData:data];
    if (image)
    {
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
        [appDelegate showAlert:@"Success" withMessage:@"Rageface saved to photoroll!"];
    }
    [DSBezelActivityView removeViewAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSURL *url=[NSURL URLWithString:[[appDelegate.tagArray objectAtIndex:[galleryVc currentIndex]] objectForKey:@"face_url"]];
	SHKItem *item=[SHKItem URL:url title:[NSString stringWithFormat:@"Look at the \"%@\" seen on the Ragepeel iPhone App!",[[appDelegate.tagArray objectAtIndex:[galleryVc currentIndex]] objectForKey:@"face_humanread_name"]]];
    if(buttonIndex==0)
    {
        [SHKFacebook shareItem:item];
    }
    else if(buttonIndex==1)
    {
        [SHKTwitter shareItem:item];
    }
}
@end
