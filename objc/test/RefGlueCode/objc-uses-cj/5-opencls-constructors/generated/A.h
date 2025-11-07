// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>
#import <stddef.h>

//@CJMirror
@interface A : NSObject

@property (readwrite) int64_t $registryId;

// true - initedFromObjC-twin: when the instance creation is started at ObjC side so DistributedGC workflow is applied
// false - initedFromCJ-twin: when this mirror is created using initWithRegistryId and serves for a pure Cangjie object
@property (readwrite) bool $initedFromObjC;

- (void) dealloc;           // for initedFromCJ-twin instance that has to remove its cj-twin from the registry
- (oneway void) release;    // for TransitionII of DistributedGC workflow if the instance is initedFromObjC-twin

- (id)initWithRegistryId:(int64_t)registryId;   // for initedFromCJ-twin
- (id)reinitWithRegistryId:(int64_t)registryId; // for back-on-track (TransitionIII) for initedFromObjC-twin objects

// Constructor(s) with signature corresponding to the original Cangjie A class
- (id)init :(int64_t)x;
- (id)init :(int64_t)x :(int64_t)y;

// The API of Cangjie A class
- (int64_t)fooI64;

@end
