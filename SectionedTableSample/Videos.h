//
//  Videos.h
//  SectionedTableSample
//
//  Created by Scott Carter on 2/18/15.
//  Copyright (c) 2015 Scott Carter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Videos : NSManagedObject

@property (nonatomic, retain) NSString * videoId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * thumbnailUrl;

@end
