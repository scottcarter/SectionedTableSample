//
//  BookmarkedTableViewCell.h
//  SectionedTableSample
//
//  Created by Scott Carter on 2/18/15.
//  Copyright (c) 2015 Scott Carter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookmarkedTableViewCell : UITableViewCell

// We created a custom cell to conveniently hold some extra properties.
@property (strong, nonatomic) NSString *assetId;
@property (strong, nonatomic) NSString *assetUrl;

@end
