//
//  Videos+Create.m
//  SectionedTableSample
//
//  Created by Scott Carter on 2/18/15.
//  Copyright (c) 2015 Scott Carter. All rights reserved.
//

#import "Videos+Create.h"

#import "Project.h"
#import "Types.h"


@implementation Videos (Create)

+ (Videos *)findOrAddVideoWithIdentifier:(NSString *)videoId
                                   title:(NSString *)title
                            thumbnailUrl:(NSString *)thumbnailUrl
                  inManagedObjectContext:(NSManagedObjectContext *)context
                                   error:(NSError **)error
{
    
    Videos *video = nil;
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Videos"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"videoId = %@", videoId];
    
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
        video = [NSEntityDescription insertNewObjectForEntityForName:@"Videos" inManagedObjectContext:context];
        
        video.videoId = videoId;
        video.title = title;
        video.thumbnailUrl = thumbnailUrl;
    }
    
    else {
        video = [matches lastObject];
    }
    
    return video;
}

+ (void)deleteVideoWithIdentifier:(NSString *)videoId
           inManagedObjectContext:(NSManagedObjectContext *)context
                            error:(NSError **)error
{
    Videos *video = nil;
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Videos"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"videoId = %@", videoId];
    
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
        video = [matches lastObject];
        
        [context deleteObject:video];
    }
    

}


@end





