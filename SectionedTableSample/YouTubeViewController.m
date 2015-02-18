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
        [self.delegate bookmarkState:YES forVideoId:self.videoId];
    }
    else {
        [self.delegate bookmarkState:NO forVideoId:self.videoId];
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
    
    // Load the video
    [self.youTubePlayerView loadWithVideoId:self.videoId];
    
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









