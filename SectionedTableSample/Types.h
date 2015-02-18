//
//  Types.h
//  SectionedTableSample
//
//  Created by Scott Carter on 2/17/15.
//  Copyright (c) 2015 Scott Carter. All rights reserved.
//

#ifndef SectionedTableSample_Types_h
#define SectionedTableSample_Types_h



// +++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Error codes for our custom NSError objects
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// Error domains in Project.h

// CoreDataErrorDomain
//

typedef enum : NSUInteger {
    CoreDataDatabaseCorrupt,
    CoreDataFetchError,
    CoreDataObtainPermanentIdError,
    CoreDataSaveError,
    CoreDataRemovePersistentStoreError,
    CoreDataRemovePersistentStoreFileError,
    CoreDataAddPersistentStoreError,
    CoreDataObtainPermanentIDsForObjectsError
} CoreDataError;



// ApplicationErrorDomain
//
typedef enum : NSUInteger {
    ApplicationFailed,
    wrongNumberCoreDataMatchesError,
} ApplicationError;





#endif
