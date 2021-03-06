//
//  Project.h
//  SectionedTableSample
//
//  Created by Scott Carter on 2/17/15.
//  Copyright (c) 2015 Scott Carter. All rights reserved.
//
#ifndef SectionedTableSample_Project_h
#define SectionedTableSample_Project_h

#import <UIKit/UIKit.h>


// Introduce PROJECT_DEVELOPMENT macro (instead of relying on just DEBUG), so that we can
// test development or release environment (with appropriate changes to defines below).
//
// Define for PROJECT_DEVELOPMENT must come before Global.h import in order to override default there.

#ifdef DEBUG
#define PROJECT_DEVELOPMENT 1
#else
#define PROJECT_DEVELOPMENT 0
#endif

// If ENABLE_PRAGMA_FOR_FLOG is set to 1, we enable pragma messages for calls to FLOG
// so that they show up in Issues Navigator
#define ENABLE_PRAGMA_FOR_FLOG 0


// Import my global, project independent header file
#import "Global.h"




// +++++++++++++++++++++++++++++++++++++++++++
// Configuration macros
// +++++++++++++++++++++++++++++++++++++++++++
//



// ++++++++++++++++++++++++++++++++++
// General project constants
// ++++++++++++++++++++++++++++++++++
//

// YouTube API Key
//
// Establish API Key in Google Developers Console - https://console.developers.google.com
//
// It may be necessary to re-create project if the API Key is not being accepted (403 error).
// This appears to be a Google issue.  I found that I needed to setup the iOS application key
// without using the bundle identifier in the Console.
//
// http://stackoverflow.com/questions/27483674/youtube-api-v3-shows-access-not-configured
// http://stackoverflow.com/questions/20832722/youtube-api-v3-on-ios-app-my-api-key-does-not-work-but-somebody-elses-key-doe
//
FOUNDATION_EXPORT NSString *const YOUTUBE_API_KEY;


// New York Times API Key
FOUNDATION_EXPORT NSString *const NYTIMES_API_KEY;



// Height of table row without thumbnail image.
FOUNDATION_EXPORT CGFloat const DEFAULT_ROW_HEIGHT;

// Height of table row with thumbnail image
FOUNDATION_EXPORT CGFloat const THUMBNAIL_ROW_HEIGHT;


// Width of UIImageView for thumbnail image
// Use in BookmarkedTableViewCell.m
FOUNDATION_EXPORT CGFloat const THUMBNAIL_WIDTH;


// Height of UIImageView for thumbnail image
// Use in BookmarkedTableViewCell.m
FOUNDATION_EXPORT CGFloat const THUMBNAIL_HEIGHT;


// X offset for UIImageView for thumbnail image
//
// Use in BookmarkedTableViewCell.m
FOUNDATION_EXPORT CGFloat const THUMBNAIL_HEIGHT_X_OFFSET;


// Y offset for UIImageView for thumbnail image
//
// Use in BookmarkedTableViewCell.m
FOUNDATION_EXPORT CGFloat const THUMBNAIL_HEIGHT_Y_OFFSET;




// +++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Error domains for our custom NSError objects
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//

// Error domains
// ============
// https://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/ErrorHandlingCocoa/ErrorObjectsDomains/ErrorObjectsDomains.html
//
// com.company.framework_or_app.ErrorDomain
//
// In my case, com.company is "scarter"
// scarter.SectionedTableSample.ErrorDomain
//


FOUNDATION_EXPORT NSString *const CoreDataErrorDomain;

FOUNDATION_EXPORT NSString *const ApplicationErrorDomain;



// +++++++++++++++++++++++++++++++++++++++++++
// Project specific logging macros
// +++++++++++++++++++++++++++++++++++++++++++
//
// These work the same as NLOG, but are meant to be left in the code
// and enabled (by changing the definition) as needed for debug.  Each
// PLOG_X macro is specific to a certain functionality.  DSLOG (Debug Singleton log) can
// be added as desired.
//
// Set ENABLE_PRAGMA_FOR_FLOG to 1 to show FLOG calls in Issue Navigator
//


// Top level operations
// (used in multiple files)
//
//#define PLOG_TOP(...)
#define PLOG_TOP(FormatLiteral, ...)  FLOG("PLOG_TOP","PLOG_TOP", FormatLiteral, ##__VA_ARGS__)



#endif






