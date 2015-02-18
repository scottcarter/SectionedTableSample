//
//  CoreDataConnection.m
//  SectionedTableSample
//
//  Created by Scott Carter on 2/18/15.
//  Copyright (c) 2015 Scott Carter. All rights reserved.
//


#import "CoreDataConnection.h"

#import "Project.h"
#import "Types.h"



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Private Interface
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
@interface CoreDataConnection ()

// ==========================================================================
// Properties
// ==========================================================================
//
#pragma mark -
#pragma mark Properties

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@end



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Implementation
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark -
@implementation CoreDataConnection

// ==========================================================================
// Constants and Defines
// ==========================================================================
//
#pragma mark -
#pragma mark Constants and Defines

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


- (void)dealloc
{
    PLOG_TOP("!!!!!!!!! CoreDataConnection dealloc")
}


- (id)init {
    
    // If a class can’t be fully initialized by plain init, it is supposed to raise an exception in init.
    EXCEPTION_LOG("CoreDataConnection can't be fully initialized with init.  Use initWithManagedObjectContext")
    
    self = [super init];
    
    if (self) {
        // Initialize self.
    }
    
    return self;
}


// This is our official initializer for this class
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{

    if(![NSThread isMainThread]){
        EXCEPTION_LOG("We need to be in the main thread here")
    }
    
    self = [super init];
    
    if (self) {
        // Initialize self.
        self.managedObjectContext = managedObjectContext;
    }
    
    return self;
}


// ==========================================================================
// Protocol methods
// ==========================================================================
//
#pragma mark -
#pragma mark Protocol methods

// None


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


// Get array of a specfified attributes of entityName records from Core Data
// sortKey is nil if sorting isn't needed.
//
- (NSArray *) coreDataRecordArrForEntityName:(NSString *)entityName
                                   predicate:(NSPredicate *)predicate
                                  properties:(NSArray *)propertiesArr
                                   sortOnKey:(NSString *)sortKey
                                   ascending:(BOOL)ascending
                             includeObjectId:(BOOL)includeObjectId
                                       error:(NSError **)error
{
    if(![NSThread isMainThread]){
        EXCEPTION_LOG("We need to be in the main thread here")
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // Using a predicate
    if(predicate){
        request.predicate = predicate;
    }
    
    // Using a sort key?
    if(sortKey){
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:ascending];
        request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    }
    
    
    // Return a dictionary (instead of managed object).
    [request setResultType:NSDictionaryResultType];
    
    // Create an array to hold properties we wish to fetch.
    NSMutableArray *propertiesMutableArr = [[NSMutableArray alloc] initWithArray:propertiesArr];
    
    // Include the object id?
    if(includeObjectId){
        // We want to include objectID in fetch.
        // References: http://bit.ly/WbMDNK  http://bit.ly/VIY6hv
        //
        NSExpressionDescription* objectIdDescription = [[NSExpressionDescription alloc] init];
        
        // This can be any label we wish to be used as the key in the returned dictionary for NSObjectIDAttributeType
        objectIdDescription.name = @"objectID";
        
        [objectIdDescription setExpression:[NSExpression expressionForEvaluatedObject]];
        [objectIdDescription setExpressionResultType:NSObjectIDAttributeType];
        
        
        [propertiesMutableArr addObject:objectIdDescription];
    }
    
    // Specify which properties (possibly object id) we are fetching
    [request setPropertiesToFetch:propertiesMutableArr];
    
    NSError *fetchError = nil;
    NSArray *recordArr = [self.managedObjectContext executeFetchRequest:request error:&fetchError];
    
    if(fetchError) {
        if(error != NULL){
            NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Core Data fetch failed", @""),
                                              NSUnderlyingErrorKey : fetchError};
            *error = [[NSError alloc] initWithDomain:CoreDataErrorDomain code:CoreDataFetchError userInfo:errorDictionary];
            ERROR_LOG("%@",*error)
        }
        return nil;
        
    }
    
    
    return recordArr;
}

// Save Core Data changes.
//
- (BOOL)saveContext:(NSError **)error
{
    
    NSError *saveError = nil;
    if (![self.managedObjectContext save:&saveError]) {
        if(error != NULL){
            NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Core Data save failed", @""),
                                              NSUnderlyingErrorKey : saveError};
            *error = [[NSError alloc] initWithDomain:CoreDataErrorDomain code:CoreDataSaveError userInfo:errorDictionary];
            ERROR_LOG("%@",*error)
        }
        return NO;
    }
    
    return YES;
}




#pragma mark Articles interface



- (Articles *)findOrAddArticleWithIdentifier:(NSString *)articleId
                                       title:(NSString *)title
                                         url:(NSString *)url
                                       error:(NSError **)error;
{
    Articles *article = [Articles findOrAddArticleWithIdentifier:articleId title:title url:url inManagedObjectContext:self.managedObjectContext error:error];
    if(!article){
        return nil; // No matches or error.
    }
    
    // Later enhancement will distinguish between find or add (don't need to save on find).
    if(![self saveContext:error]){
        return nil;
    }
    
    return article;
}



- (void)deleteArticleWithIdentifier:(NSString *)articleId
                              error:(NSError **)error
{
    [Articles deleteArticleWithIdentifier:articleId inManagedObjectContext:self.managedObjectContext error:error];
    
    if(*error){
        return;
    }
    
    [self saveContext:error];
}




#pragma mark Videos interface


- (Videos *)findOrAddVideoWithIdentifier:(NSString *)videoId
                                   title:(NSString *)title
                            thumbnailUrl:(NSString *)thumbnailUrl
                                   error:(NSError **)error
{
 
    Videos *video = [Videos findOrAddVideoWithIdentifier:videoId title:title thumbnailUrl:thumbnailUrl inManagedObjectContext:self.managedObjectContext error:error];
    
    if(!video){
        return nil; // No matches or error.
    }
    
    
    // Later enhancement will distinguish between find or add (don't need to save on find).
    if(![self saveContext:error]){
        return nil;
    }
    
    return video;
    
    
}


- (void)deleteVideoWithIdentifier:(NSString *)videoId
                            error:(NSError **)error
{
    [Videos deleteVideoWithIdentifier:videoId inManagedObjectContext:self.managedObjectContext error:error];
    
    if(*error){
        return;
    }

    [self saveContext:error];
}






@end









