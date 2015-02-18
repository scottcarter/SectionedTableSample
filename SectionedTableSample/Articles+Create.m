//
//  Articles+Create.m
//  SectionedTableSample
//
//  Created by Scott Carter on 2/18/15.
//  Copyright (c) 2015 Scott Carter. All rights reserved.
//

#import "Articles+Create.h"

#import "Project.h"
#import "Types.h"


@implementation Articles (Create)


+ (Articles *)findOrAddArticleWithIdentifier:(NSString *)articleId
                                       title:(NSString *)title
                                         url:(NSString *)url
                      inManagedObjectContext:(NSManagedObjectContext *)context
                                       error:(NSError **)error
{
    Articles *article = nil;
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Articles"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"articleId = %@", articleId];
    
    // Doesn't really matter how we sort this, since we should only be getting back 0 or 1 of these.
    //NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"?" ascending:YES];
    //request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *fetchError = nil;
    NSArray *matches = [context executeFetchRequest:request error:&fetchError];
    if(fetchError) {
        if(error != NULL){
            NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Core Data fetch failed", @""),
                                              NSUnderlyingErrorKey : fetchError};
            *error = [[NSError alloc] initWithDomain:CoreDataErrorDomain code:CoreDataFetchError userInfo:errorDictionary];
            ERROR_LOG("%@",*error)
        }
        return nil;
    }
    
    
    // We expect matches to be non NULL and have 0 or 1 entries.
    if (!matches || ([matches count] > 1)) {
        if(error != NULL){
            NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Wrong number of Core data matches", @"")};
            *error = [[NSError alloc] initWithDomain:ApplicationErrorDomain code:wrongNumberCoreDataMatchesError userInfo:errorDictionary];
            ERROR_LOG("%@",*error)
        }
        return nil;
    }
    
    else if ([matches count] == 0) {
        article = [NSEntityDescription insertNewObjectForEntityForName:@"Articles" inManagedObjectContext:context];
        
        article.articleId = articleId;
        article.title = title;
        article.url = url;
    }
    
    else {
        article = [matches lastObject];
    }
    
    return article;

}


+ (void)deleteArticleWithIdentifier:(NSString *)articleId
             inManagedObjectContext:(NSManagedObjectContext *)context
                              error:(NSError **)error
{
    Articles *article = nil;
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Articles"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"articleId = %@", articleId];
    
    // Doesn't really matter how we sort this, since we should only be getting back 0 or 1 of these.
    //NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"?" ascending:YES];
    //request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *fetchError = nil;
    NSArray *matches = [context executeFetchRequest:request error:&fetchError];
    if(fetchError) {
        if(error != NULL){
            NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Core Data fetch failed", @""),
                                              NSUnderlyingErrorKey : fetchError};
            *error = [[NSError alloc] initWithDomain:CoreDataErrorDomain code:CoreDataFetchError userInfo:errorDictionary];
            ERROR_LOG("%@",*error)
        }
        return;
    }
    
    
    // We expect matches to be non NULL and have 0 or 1 entries.
    if (!matches || ([matches count] > 1)) {
        if(error != NULL){
            NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Wrong number of Core data matches", @"")};
            *error = [[NSError alloc] initWithDomain:ApplicationErrorDomain code:wrongNumberCoreDataMatchesError userInfo:errorDictionary];
            ERROR_LOG("%@",*error)
        }
        return;
    }
    
    else if ([matches count] == 1) {
        article = [matches lastObject];
        
        [context deleteObject:article];
    }
    
  

}



@end






