// clang -framework Foundation test.m ma_dispatch_group.m
#import <assert.h>
#import <dispatch/dispatch.h>

#import "ma_dispatch_group.h"

int main(int argc, char **argv)
{
    {
        ma_dispatch_group_t group = ma_dispatch_group_create();
        __block int fired = 0;
        ma_dispatch_group_notify(group, ^{ fired = 1; });
        assert(fired);
        ma_dispatch_group_destroy(group);
    }
    
    {
        ma_dispatch_group_t group = ma_dispatch_group_create();
        __block int fired = 0;
        ma_dispatch_group_enter(group);
        ma_dispatch_group_leave(group);
        ma_dispatch_group_notify(group, ^{ fired = 1; });
        assert(fired);
        ma_dispatch_group_destroy(group);
    }
    
    {
        ma_dispatch_group_t group = ma_dispatch_group_create();
        __block int fired = 0;
        ma_dispatch_group_enter(group);
        ma_dispatch_group_notify(group, ^{ fired = 1; });
        assert(!fired);
        ma_dispatch_group_leave(group);
        assert(fired);
        ma_dispatch_group_destroy(group);
    }
    
    {
        ma_dispatch_group_t group = ma_dispatch_group_create();
        ma_dispatch_group_wait(group);
        ma_dispatch_group_destroy(group);
    }
    
    {
        ma_dispatch_group_t group = ma_dispatch_group_create();
        ma_dispatch_group_enter(group);
        ma_dispatch_group_leave(group);
        ma_dispatch_group_wait(group);
        ma_dispatch_group_destroy(group);
    }
    
    {
        ma_dispatch_group_t group = ma_dispatch_group_create();
        for(int i = 0; i < 1000; i++)
            ma_dispatch_group_enter(group);
        
        for(int i = 0; i < 1000; i++)
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                ma_dispatch_group_leave(group);
            });
        
        ma_dispatch_group_wait(group);
        ma_dispatch_group_destroy(group);
    }
}
