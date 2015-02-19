//
//  Project.m
//  SectionedTableSample
//
//  Created by Scott Carter on 2/17/15.
//  Copyright (c) 2015 Scott Carter. All rights reserved.
//

#import "Project.h"


// Define some constants that were declared in Project.h


// ++++++++++++++++++++++++++++++++++
// General project constants
// ++++++++++++++++++++++++++++++++++
//


NSString *const YOUTUBE_API_KEY = @"AIzaSyA6r3tR1hEWhL2x4Oy0cSLsFhjh53Wzjl0";


NSString *const NYTIMES_API_KEY = @"f118b4c8099478374677af25d9f5e938%3A14%3A71290266";


CGFloat const DEFAULT_ROW_HEIGHT = 44.0;


// We will use the default thumbnail which has a resolution of 120x90
// https://developers.google.com/youtube/v3/docs/thumbnails
//
// Make sure that row height can accomodate rendered height and padding.
//
CGFloat const THUMBNAIL_ROW_HEIGHT = 100.0;

CGFloat const THUMBNAIL_WIDTH = 80.0;  // Keep appropriate aspect ratio.
CGFloat const THUMBNAIL_HEIGHT = 60.0;

CGFloat const THUMBNAIL_HEIGHT_X_OFFSET = 10.0;
CGFloat const THUMBNAIL_HEIGHT_Y_OFFSET = 10.0;  // Adjust to center image vertically in cell.


// +++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Error domains for our custom NSError objects
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//


NSString *const CoreDataErrorDomain = @"scarter.SectionedTableSample.coreDataErrorDomain";

NSString *const ApplicationErrorDomain = @"scarter.SectionedTableSample.applicationErrorDomain";


