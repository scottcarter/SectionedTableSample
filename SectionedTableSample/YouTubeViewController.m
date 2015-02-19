//
//  YouTubeViewController.m
//  SectionedTableSample
//
//  Created by Scott Carter on 2/17/15.
//  Copyright (c) 2015 Scott Carter. All rights reserved.
//

#import "YouTubeViewController.h"

#import "YTPlayerView.h"

#import "Project.h"

#import "BookmarksTableViewController.h"


// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Private Interface
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
@interface YouTubeViewController ()

// ==========================================================================
// Properties
// ==========================================================================
//
#pragma mark -
#pragma mark Properties

@property (weak, nonatomic) IBOutlet YTPlayerView *youTubePlayerView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *bookmarkedControl;


// We provide an outlet to label as a temporary measure,
// so as to be able to hide it (and segmented control) when transitioning from Bookmarks tab.
// We do this since their functionality is not yet complete when we
// are instanced in that transition.
@property (weak, nonatomic) IBOutlet UILabel *bookmarkedLabel;


@end



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Implementation
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark -
@implementation YouTubeViewController

// ==========================================================================
// Constants and Defines
// ==========================================================================
//
#pragma mark -
#pragma mark Constants and Defines

// None



// ==========================================================================
// Getters and Setters
// ==========================================================================
//
#pragma mark -
#pragma mark Getters and Setters


// None



// ==========================================================================
// Actions
// ==========================================================================
//
#pragma mark -
#pragma mark Actions


// Report our bookmark state to our delegate, translating from the state of the
// SegmentedControl.
//
- (IBAction)bookmarkedControlAction:(UISegmentedControl *)sender {
    
    if(self.bookmarkedControl.selectedSegmentIndex == 0){
        [self.delegate bookmarkState:YES forVideoId:self.videoId title:self.videoTitle thumbnailUrl:self.thumbnailUrl];
    }
    else {
        [self.delegate bookmarkState:NO forVideoId:self.videoId title:self.videoTitle thumbnailUrl:self.thumbnailUrl];
    }
    
    //NLOG("selected index=%d",sender.selectedSegmentIndex)
    
}



// ==========================================================================
// Initializations
// ==========================================================================
//
#pragma mark -
#pragma mark Initializations

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Video";
    
    
    // Translate the state of the bookmarked BOOL to the SegmentedControl state.
    if(self.bookmarked){
        self.bookmarkedControl.selectedSegmentIndex = 0;
    }
    else {
        self.bookmarkedControl.selectedSegmentIndex = 1;
    }
    
    // Temporarily hide segmented control and label if coming from Bookmarks tab.
    UIViewController *backViewController = [self backViewController];
    if([backViewController isKindOfClass:[BookmarksTableViewController class]]){
        self.bookmarkedControl.hidden = YES;
        self.bookmarkedLabel.hidden = YES;
    }
    
    // Load the video
    //
    // Reference: https://developers.google.com/youtube/player_parameters?playerVersion=HTML5#start
    //
    NSDictionary *playerVars = @{
                                 @"controls" : @0,
                                 @"playsinline" : @0,
                                 @"autoplay" : @1,
                                 @"showinfo" : @0,
                                 @"modestbranding" : @1
                                 };
    [self.youTubePlayerView loadWithVideoId:self.videoId playerVars:playerVars];
    
}


- (UIViewController *)backViewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
}


// ==========================================================================
// Protocol methods
// ==========================================================================
//
#pragma mark -
#pragma mark Protocol methods

// None


// ==========================================================================
// Class methods
// ==========================================================================
//
#pragma mark -
#pragma mark Class methods

// None


// ==========================================================================
// Instance methods
// ==========================================================================
//
#pragma mark -
#pragma mark Instance methods

// None






@end









