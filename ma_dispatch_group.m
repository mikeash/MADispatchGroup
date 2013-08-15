#import "ma_dispatch_group.h"

#import <Block.h>
#import <stdint.h>
#import <stdlib.h>


struct ma_dispatch_group_internal {
    uint32_t counter;
    void (^action)(void);
};

ma_dispatch_group_t ma_dispatch_group_create(void)
{
    ma_dispatch_group_t group = calloc(1, sizeof *group);
    return group;
}

void ma_dispatch_group_destroy(ma_dispatch_group_t group)
{
    free(group);
}

void ma_dispatch_group_enter(ma_dispatch_group_t group)
{
    __sync_fetch_and_add(&group->counter, 1);
}

void ma_dispatch_group_leave(ma_dispatch_group_t group)
{
    uint32_t newCounterValue = __sync_sub_and_fetch(&group->counter, 1);
    if(newCounterValue == 0)
    {
        if(group->action)
        {
            group->action();
            Block_release(group->action);
            group->action = NULL;
        }
    }
}

void ma_dispatch_group_notify(ma_dispatch_group_t group, void (^block)(void))
{
    ma_dispatch_group_enter(group);
    group->action = Block_copy(block);
    ma_dispatch_group_leave(group);
}

void ma_dispatch_group_wait(ma_dispatch_group_t group)
{
    __block volatile int done = 0;
    ma_dispatch_group_notify(group, ^{ done = 1; });
    while(!done)
        ; // do nothing
}

