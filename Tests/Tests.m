//
//  DeepLinkSDKTests.m
//  DeepLinkSDKTests
//
//  Created by Wes Smith on 12/08/2014.
//  Copyright (c) 2014 Wes Smith. All rights reserved.
//

SpecBegin(InitialSpecs)

describe(@"these will fail", ^{

    it(@"can do maths", ^{
        expect(1).to.equal(2);
    });

    it(@"can read", ^{
        expect(@"number").to.equal(@"string");
    });

    it(@"will wait and fail", ^{
        waitUntil(^(DoneCallback done) {

        });
    });
});

describe(@"these will pass", ^{

    it(@"can do maths", ^{
        expect(1).beLessThan(23);
    });

    it(@"can read", ^{
        expect(@"team").toNot.contain(@"I");
    });

    it(@"will wait and succeed", ^{
        waitUntil(^(DoneCallback done) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                done();
            });
        });
    });
});

SpecEnd
