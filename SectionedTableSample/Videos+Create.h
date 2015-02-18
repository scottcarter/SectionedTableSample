//
//  Videos+Create.h
//  SectionedTableSample
//
//  Created by Scott Carter on 2/18/15.
//  Copyright (c) 2015 Scott Carter. All rights reserved.
//

#import "Videos.h"

@interface Videos (Create)


+ (Videos *)findOrAddVideoWithIdentifier:(NSString *)videoId
                                       title:(NSString *)title
                                         thumbnailUrl:(NSString *)thumbnailUrl
                      inManagedObjectContext:(NSManagedObjectContext *)context
                                       error:(NSError **)error;


+ (void)deleteVideoWithIdentifier:(NSString *)videoId
             inManagedObjectContext:(NSManagedObjectContext *)context
                              error:(NSError **)error;


@end
