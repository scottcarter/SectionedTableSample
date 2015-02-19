//
//  YouTubeViewController.h
//  SectionedTableSample
//
//  Created by Scott Carter on 2/17/15.
//  Copyright (c) 2015 Scott Carter. All rights reserved.
//

#import <UIKit/UIKit.h>



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Forward Declarations
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//

#pragma mark Forward Declarations

// None


// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Protocols
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark -
#pragma mark Protocols

@protocol YouTubeViewControllerDelegate <NSObject>

- (void)bookmarkState:(BOOL)bookmarked
           forVideoId:(NSString *)videoId
                title:(NSString *)title
         thumbnailUrl:(NSString *)thumbnailUrl;

@end


// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Public Interface
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark -
@interface YouTubeViewController : UIViewController



// ==========================================================================
// Properties
// ==========================================================================
//
#pragma mark -
#pragma mark  Properties

// Properties that are set by view controller that we are pushed from.
//
@property (strong, nonatomic) NSString *videoId;
@property (strong, nonatomic) NSString *videoTitle;
@property (strong, nonatomic) NSString *thumbnailUrl;

@property (nonatomic) BOOL bookmarked;

@property (weak, nonatomic) id<YouTubeViewControllerDelegate> delegate;


// ==========================================================================
// Class method declarations
// ==========================================================================
//
#pragma mark -
#pragma mark Class method declarations

// None


// ==========================================================================
// Instance method declarations
// ==========================================================================
//
#pragma mark -
#pragma mark Instance method declarations

// None

@end

