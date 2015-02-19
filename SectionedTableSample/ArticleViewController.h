//
//  ArticleViewController.h
//  SectionedTableSample
//
//  Created by Scott Carter on 2/18/15.
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

@protocol ArticleViewControllerDelegate <NSObject>

- (void)bookmarkState:(BOOL)bookmarked
         forArticleId:(NSString *)articleId
                title:(NSString *)title
                  url:(NSString *)url;

@end



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Public Interface
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark -
@interface ArticleViewController : UIViewController



// ==========================================================================
// Properties
// ==========================================================================
//
#pragma mark -
#pragma mark  Properties

// Properties that are set by view controller that we are pushed from.
//
@property (strong, nonatomic) NSString *articleId;
@property (strong, nonatomic) NSString *articleTitle;
@property (strong, nonatomic) NSString *url;

@property (nonatomic) BOOL bookmarked;

@property (weak, nonatomic) id<ArticleViewControllerDelegate> delegate;




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



