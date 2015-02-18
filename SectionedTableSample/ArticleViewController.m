//
//  ArticleViewController.m
//  SectionedTableSample
//
//  Created by Scott Carter on 2/18/15.
//  Copyright (c) 2015 Scott Carter. All rights reserved.
//

#import "ArticleViewController.h"

#import "Project.h"


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
        [self.delegate bookmarkState:YES forArticleId:self.articleId];
    }
    else {
        [self.delegate bookmarkState:NO forArticleId:self.articleId];
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









