//
//  BookmarkedTableViewCell.m
//  SectionedTableSample
//
//  Created by Scott Carter on 2/18/15.
//  Copyright (c) 2015 Scott Carter. All rights reserved.
//

#import "BookmarkedTableViewCell.h"

#import "Project.h"

@implementation BookmarkedTableViewCell


// See:
// http://stackoverflow.com/questions/2788028/how-do-i-make-uitableviewcells-imageview-a-fixed-size-even-when-the-image-is-sm
//
// This makes sure that my thumbnails are a consistent size when initially loaded.
// Without this subclass and method, I was initially getting a larger thumbnail
// that shrunk as I clicked through to the image and back again.  I then would have
// thumbnails of different sizes, depending on whether I had viewed their image ...
//
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(THUMBNAIL_HEIGHT_X_OFFSET, THUMBNAIL_HEIGHT_Y_OFFSET, THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT);
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
