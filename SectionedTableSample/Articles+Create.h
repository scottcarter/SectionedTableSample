//
//  Articles+Create.h
//  SectionedTableSample
//
//  Created by Scott Carter on 2/18/15.
//  Copyright (c) 2015 Scott Carter. All rights reserved.
//

#import "Articles.h"

@interface Articles (Create)

+ (Articles *)findOrAddArticleWithIdentifier:(NSString *)articleId
                                 title:(NSString *)title
                                  url:(NSString *)url
                     inManagedObjectContext:(NSManagedObjectContext *)context
                                      error:(NSError **)error;

+ (void)deleteArticleWithIdentifier:(NSString *)articleId
                      inManagedObjectContext:(NSManagedObjectContext *)context
                                       error:(NSError **)error;


@end
