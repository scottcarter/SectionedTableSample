//
//  TableViewController.m
//  SectionedTableSample
//
//  Created by Scott Carter on 2/19/15.
//  Copyright (c) 2015 Scott Carter. All rights reserved.
//

#import "TableViewController.h"

#import "Project.h"



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Private Interface
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
@interface TableViewController ()

// ==========================================================================
// Properties
// ==========================================================================
//
#pragma mark -
#pragma mark Properties

// None

@end



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Implementation
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark -
@implementation TableViewController

// ==========================================================================
// Constants and Defines
// ==========================================================================
//
#pragma mark -
#pragma mark Constants and Defines

// None


// ==========================================================================
// Instance variables.  Could also be in interface section.
// ==========================================================================
//
#pragma mark -
#pragma mark Instance variables

// None


// ==========================================================================
// Synthesize public properties
// ==========================================================================
//
#pragma mark -
#pragma mark Synthesize public properties

// None


// ==========================================================================
// Synthesize private properties
// ==========================================================================
//
#pragma mark -
#pragma mark Synthesize private properties

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

// None



// ==========================================================================
// Initializations
// ==========================================================================
//
#pragma mark -
#pragma mark Initializations

// None


// ==========================================================================
// Protocol methods
// ==========================================================================
//
#pragma mark -
#pragma mark Protocol methods

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    EXCEPTION_LOG("Need to override this method in subclass")
    return 0;
}


// Customize the header.   At a minimum we wish to use dynamic text.
//
// http://stackoverflow.com/questions/19802336/ios-7-changing-font-size-for-uitableview-section-headers
//
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor brownColor];
    header.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    // Need to resize the frame after changing font.
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    
    //header.textLabel.textAlignment = NSTextAlignmentCenter;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    EXCEPTION_LOG("Need to override this method in subclass")
    return 0;
}


// Download image in separate queue.
//
- (void)setImageForCell:(BookmarkedTableViewCell *)cell
{
    
    // Set placeholder for thumbnail image.
    NSString* imagePath = [ [ NSBundle mainBundle] pathForResource:@"blank" ofType:@"png"];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    cell.imageView.image = image;
    
    // Note:
    // In order to set the size, I included layoutSubviews in BookmarkedTableViewCell.m
    

    
    NSString *assetUrl = cell.assetUrl;
    NSString *assetId = [cell.assetId copy];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);  // NULL = Serial queue
    dispatch_async(downloadQueue, ^{
        
        NSURL *url = [NSURL URLWithString:assetUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        
        // Go back to main thread to display thumbnail.
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *image = data ? [UIImage imageWithData:data] : nil;
            
            // NLOG("width = %f  height = %f",image.size.width, image.size.height)
            
            // http://stackoverflow.com/questions/8052999/check-if-a-specific-uitableviewcell-is-visible-in-a-uitableview
            BOOL cellVisible = [self.tableView.visibleCells containsObject:cell];
            
            
            // Is cell reference the same or did we get a new cell (recorded in cellArray) since starting the thread?
            if(cellVisible && [cell.assetId isEqual:assetId]) {
                
                // Set the thumbnail image
                cell.imageView.image = image;
            }
            
        });
        
        
    });
    
    
}




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









