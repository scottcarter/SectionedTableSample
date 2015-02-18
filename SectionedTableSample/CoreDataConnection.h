//
//  CoreDataConnection.h
//  SectionedTableSample
//
//  Created by Scott Carter on 2/18/15.
//  Copyright (c) 2015 Scott Carter. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

#import "Articles+Create.h"
#import "Videos+Create.h"



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Forward Declarations
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark Forward Declarations

// None


// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Protocols
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark -
#pragma mark Protocols

// None

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Public Interface
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark -
@interface CoreDataConnection : NSObject



// ==========================================================================
// Properties
// ==========================================================================
//
#pragma mark -
#pragma mark  Properties

// None


// ==========================================================================
// Class method declarations
// ==========================================================================
//
#pragma mark -
#pragma mark Class method declarations

// None


// ==========================================================================
// Instance method declarations
// ==========================================================================
//
#pragma mark -
#pragma mark Instance method declarations


- (NSArray *) coreDataRecordArrForEntityName:(NSString *)entityName
                                   predicate:(NSPredicate *)predicate
                                  properties:(NSArray *)propertiesArr
                                   sortOnKey:(NSString *)sortKey
                                   ascending:(BOOL)ascending
                             includeObjectId:(BOOL)includeObjectId
                                       error:(NSError **)error;




- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;


// Articles interface
//
- (Articles *)findOrAddArticleWithIdentifier:(NSString *)articleId
                                       title:(NSString *)title
                                         url:(NSString *)url
                                       error:(NSError **)error;

- (void)deleteArticleWithIdentifier:(NSString *)articleId
                              error:(NSError **)error;




// Videos interface
//
- (Videos *)findOrAddVideoWithIdentifier:(NSString *)videoId
                                   title:(NSString *)title
                            thumbnailUrl:(NSString *)thumbnailUrl
                                   error:(NSError **)error;


- (void)deleteVideoWithIdentifier:(NSString *)videoId
                            error:(NSError **)error;




// ==========================================================================
// Instance method declarations for testing
// ==========================================================================
//
#pragma mark -
#pragma mark Instance method declarations for testing

// None


@end






