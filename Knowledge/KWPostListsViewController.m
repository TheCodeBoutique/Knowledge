//
//  KWPostListsViewController.m
//  Knowledge
//
//  Created by Kyle Carriedo on 11/16/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//
#import <Parse/Parse.h>
#import "KWPostListsViewController.h"
#import "KWCreatePostViewController.h"
#import "KWPostCollectionViewCell.h"
#import "KWQueries.h"

@interface KWPostListsViewController () <KWPostCollectionViewCellDelegate>

@property (strong, nonatomic) NSArray *totalPosts;
@end

@implementation KWPostListsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PFQuery *query = [[KWQueries sharedInstance] totalPostForCurrentWeek];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _totalPosts = objects;
            NSLog(@"post count %lu",(unsigned long)_totalPosts.count);
            [[self collectionView] reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *createNewPost = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(createNewPost:)];
    [[self navigationItem] setRightBarButtonItem:createNewPost];
    [[self navigationItem] setTitle:@"Knowledge"];
}

-(IBAction)createNewPost:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    KWCreatePostViewController *createPostViewController = [storyboard instantiateViewControllerWithIdentifier:@"KWCreatePostViewController"];
    UINavigationController *createPostNavigationController = [[UINavigationController alloc] initWithRootViewController:createPostViewController];
    [self presentViewController:createPostNavigationController animated:YES completion:^{}];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_totalPosts count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Setup cell identifier
    static NSString *cellIdentifier = @"postCell";
    KWPostCollectionViewCell *cell = (KWPostCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    PFObject *postObject = [_totalPosts objectAtIndex:[indexPath row]];
    PFUser *createdBy = [postObject objectForKey:@"user_name"];
    
    [[cell postTitle] setText:[postObject objectForKey:@"title"]];
    [[cell postMessage] setText:[postObject objectForKey:@"message"]];
    [[cell username] setText:[createdBy username]];
    [[cell totalLike] setText:[NSString stringWithFormat:@"%@",[postObject objectForKey:@"like"]]];
    [cell setPost:postObject];
    [cell setUser:createdBy];
    [cell setDelgate:self];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *postObject = [_totalPosts objectAtIndex:[indexPath row]];
    NSString *messageString = [postObject objectForKey:@"message"];
    CGSize size = [KWPostCollectionViewCell sizeForCell:messageString];
    return CGSizeMake(306.0f, size.height);
}

#pragma mark delegate
-(void)likeUpdatedForPost:(PFObject *)postObject withCell:(KWPostCollectionViewCell *)cell {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
