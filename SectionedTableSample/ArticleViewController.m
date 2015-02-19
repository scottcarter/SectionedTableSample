//
//  ArticleViewController.m
//  SectionedTableSample
//
//  Created by Scott Carter on 2/18/15.
//  Copyright (c) 2015 Scott Carter. All rights reserved.
//

#import "ArticleViewController.h"

#import "Project.h"

#import "BookmarksTableViewController.h"



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Private Interface
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
@interface ArticleViewController ()

// ==========================================================================
// Properties
// ==========================================================================
//
#pragma mark -
#pragma mark Properties

@property (weak, nonatomic) IBOutlet UIWebView *webView;

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
@implementation ArticleViewController

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

- (IBAction)bookmarkedControlAction:(UISegmentedControl *)sender {
    
    if(self.bookmarkedControl.selectedSegmentIndex == 0){
        [self.delegate bookmarkState:YES forArticleId:self.articleId title:self.articleTitle url:self.url];
    }
    else {
        [self.delegate bookmarkState:NO forArticleId:self.articleId title:self.articleTitle url:self.url];
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
    
    self.title = @"Article";
    
    
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
    
}

- (UIViewController *)backViewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
}



// Load the Article web page.
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
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









