// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#pragma once
#ifndef CANGJIEWRITER_H
#define CANGJIEWRITER_H

extern enum class Mode {
    // Mode that is compatible with the current FE.  The generated mirrors are
    // compilable and can be used in interop.
    NORMAL,

    // For internal testing only.  May be removed in the future.  The generator uses
    // all features, including those not supported by the current FE.  The generated
    // mirrors therefore may not be compilable.
    //
    // Currently this mode is default by compatibility reasons.
    EXPERIMENTAL,

    // For internal testing only.  May be removed in the future.  The same as
    // `EXPERIMENTAL`, but additinally the generator tries its best to create
    // mirrors that can be compiled by cjc, though they will not enable actual
    // interop.  This is achieved by removing the `@ObjcCMirror` attribute and
    // creating fake bodies for methods of `@ObjCMirror` classes/interfaces.
    GENERATE_DEFINITIONS
} mode;

void write_cangjie();

#endif // CANGJIEWRITER_H
