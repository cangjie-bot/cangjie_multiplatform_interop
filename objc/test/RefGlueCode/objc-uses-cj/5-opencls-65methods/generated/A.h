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
- (id)init;                                     // for initedFromObjC-twin objects

// The API of Cangjie A class
- (void)foo0;
- (void)foo1;
- (void)foo2;
- (void)foo3;
- (void)foo4;
- (void)foo5;
- (void)foo6;
- (void)foo7;
- (void)foo8;
- (void)foo9;
- (void)foo10;
- (void)foo11;
- (void)foo12;
- (void)foo13;
- (void)foo14;
- (void)foo15;
- (void)foo16;
- (void)foo17;
- (void)foo18;
- (void)foo19;
- (void)foo20;
- (void)foo21;
- (void)foo22;
- (void)foo23;
- (void)foo24;
- (void)foo25;
- (void)foo26;
- (void)foo27;
- (void)foo28;
- (void)foo29;
- (void)foo30;
- (void)foo31;
- (void)foo32;
- (void)foo33;
- (void)foo34;
- (void)foo35;
- (void)foo36;
- (void)foo37;
- (void)foo38;
- (void)foo39;
- (void)foo40;
- (void)foo41;
- (void)foo42;
- (void)foo43;
- (void)foo44;
- (void)foo45;
- (void)foo46;
- (void)foo47;
- (void)foo48;
- (void)foo49;
- (void)foo50;
- (void)foo51;
- (void)foo52;
- (void)foo53;
- (void)foo54;
- (void)foo55;
- (void)foo56;
- (void)foo57;
- (void)foo58;
- (void)foo59;
- (void)foo60;
- (void)foo61;
- (void)foo62;
- (void)foo63;
- (void)foo64;
- (void)foo65;

@end
