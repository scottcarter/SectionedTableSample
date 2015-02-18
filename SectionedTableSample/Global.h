//
//  Global.h
//
//  Created by Scott Carter on 8/15/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

// ***** Nothing project specific in this file *****
//
// Project specific defines, as well as import of this file, go in the Project.h file.
//
// This file should only be imported by Project.h file.
//

#ifndef Global_h
#define Global_h



// Default is a release environment
//
// PROJECT_DEVELOPMENT macro should be set in Project.h file just prior to #import "Global.h"
#ifndef PROJECT_DEVELOPMENT
#define PROJECT_DEVELOPMENT 0
#endif

// ENABLE_PRAGMA_FOR_FLOG macro should be set in Project.h file just prior to #import "Global.h"
#ifndef ENABLE_PRAGMA_FOR_FLOG
#define ENABLE_PRAGMA_FOR_FLOG 1
#endif


// Get define for TARGET_IPHONE_SIMULATOR
// Reference:  http://bit.ly/YCPyPJ
#include "TargetConditionals.h"

// Create the define IPHONE_SIMULATOR_DEVELOPMENT that we can use for debugging and test purposes
#if PROJECT_DEVELOPMENT
#if TARGET_IPHONE_SIMULATOR
#define IPHONE_SIMULATOR_DEVELOPMENT 1
#endif
#endif

// Default is not an iphone simulator development environment unless set above
// (default could mean iPad, iPhone device, iPhone simulator in release environment, etc)
#ifndef IPHONE_SIMULATOR_DEVELOPMENT
#define IPHONE_SIMULATOR_DEVELOPMENT 0
#endif


 
// Define some macros that only execute in a development environment
#if PROJECT_DEVELOPMENT


#define _STR(x) #x
#define STR(x) _STR(x)

// Pragma messages
//
// Reference:
// http://gcc.gnu.org/onlinedocs/cpp/Macros.html#Macros
//
#define DO_PRAGMA(x) _Pragma (#x)



// Define an error log message that prints argument along with function name and line number.
// Useful in conditional blocks.
#define ERROR_LOG(FormatLiteral, ...)  NSLog (@"ERROR in %s(%u): " FormatLiteral "\n\n", __FUNCTION__, __LINE__, ##__VA_ARGS__);


// Define an exception log message (programming checks) that can be used in conditional blocks.
// See also NSAssert() which can be used for one line checks.
//
// When to use an exception?  For programming errors, not run-time user errors (such as file cannot be found).
// User errors can be communicated via NSError objects.  See:
// A Note on Errors and Exceptions
// https://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/ErrorHandlingCocoa/CreateCustomizeNSError/CreateCustomizeNSError.html
//
// More on NSError
// https://developer.apple.com/library/ios/#documentation/Cocoa/Reference/Foundation/Classes/NSError_Class/Reference/Reference.html
// https://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/ErrorHandlingCocoa/ErrorObjectsDomains/ErrorObjectsDomains.html
//
#define EXCEPTION_LOG(FormatLiteral, ...)  [NSException raise:NSInternalInconsistencyException format:@"EXCEPTION in %s(%u): " FormatLiteral "\n", __FUNCTION__, __LINE__, ##__VA_ARGS__];


// To get a symbol stack trace, try:
// NSLog(@"%@",[NSThread callStackSymbols]);
// Reference: http://bit.ly/ZhwIv4


// Define some pragma messages that appear in Issue Navigator view.
// They can be temporary (TODO, FIXME) or permanent (BOOKMARK)
// They print a constant string (similar to CLOG below) with a specific prefix.
//
//#define TODO(...)
#define TODO(x) DO_PRAGMA(message (STR(__LINE__) " TODO: " #x))

#define FIXME(x) DO_PRAGMA(message (STR(__LINE__) " FIXME: " #x))

#define BOOKMARK(x) DO_PRAGMA(message (STR(__LINE__) " -> " #x))

// Define a couple logging varieties.  Both appear in Issue Navigator view.
// They are intended for temporary debug.
//
// CLOG prints a constant string, without the need for @, quotes or trailing ;
// CLOG(Hello World)
//
// NLOG can replace NSLog, without the need for @ or trailing ;
// NLOG("firstname=%@",self.firstname)
// 
#define CLOG(x) NSLog(@#x); DO_PRAGMA(message (STR(__LINE__) " NSLog: " #x))

// Simple example of NLOG
//#define NLOG(...) NSLog(@__VA_ARGS__); DO_PRAGMA(message (STR(__LINE__) " NSLog: " #__VA_ARGS__))


// Formatted log.  Note that I don't need STR() for __LINE__
//
// Reference:
// http://en.wikipedia.org/wiki/Variadic_macro
//
// Implement NLOG with FLOG
//
// If ENABLE_PRAGMA_FOR_FLOG is set, FLOG and NLOG both use pragma.  If not set, only NLOG uses pragma.
#if ENABLE_PRAGMA_FOR_FLOG

#define FLOG(LogType, MacroType, FormatLiteral, ...)  NSLog (@"%s(%u): " LogType " \n" FormatLiteral "\n\n", __FUNCTION__, __LINE__, ##__VA_ARGS__);  DO_PRAGMA(message (STR(__LINE__) " " MacroType ": " FormatLiteral " " #__VA_ARGS__))

#define NLOG(FormatLiteral, ...)  FLOG("","NSLog", FormatLiteral, ##__VA_ARGS__)

#else

#define FLOG(LogType, MacroType, FormatLiteral, ...)  NSLog (@"%s(%u): " LogType " \n" FormatLiteral "\n\n", __FUNCTION__, __LINE__, ##__VA_ARGS__);  

#define NLOG(FormatLiteral, ...)  FLOG("","NSLog", FormatLiteral, ##__VA_ARGS__) DO_PRAGMA(message (STR(__LINE__) " NSLog : " FormatLiteral " " #__VA_ARGS__))
#endif



// If PROJECT_DEVELOPMENT is not defined, we stub out ERROR_LOG, EXCEPTION_LOG, BOOKMARK, CLOG, etc.

#else


#define ERROR_LOG(...)

#define EXCEPTION_LOG(...)


#define TODO(...)
#define FIXME(...)
#define BOOKMARK(...)
#define CLOG(...)

#define FLOG(...)
#define NLOG(...)

#endif





#endif





