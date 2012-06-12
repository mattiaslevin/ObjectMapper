//
//  ObjectWithObjectTypes.h
//
//  Created by Mattias Levin on 2011-10-08.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ObjectWithBasicTypes;

@interface ObjectWithObjectTypes : NSObject {
    ObjectWithBasicTypes *object1;
    ObjectWithBasicTypes *object2;
}


@property (retain) ObjectWithBasicTypes *object1;
@property (retain) ObjectWithBasicTypes *object2;


@end
