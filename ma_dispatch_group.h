
typedef struct ma_dispatch_group_internal *ma_dispatch_group_t;

ma_dispatch_group_t ma_dispatch_group_create(void);
void ma_dispatch_group_destroy(ma_dispatch_group_t group);
void ma_dispatch_group_enter(ma_dispatch_group_t group);
void ma_dispatch_group_leave(ma_dispatch_group_t group);
void ma_dispatch_group_notify(ma_dispatch_group_t group, void (^block)(void));
void ma_dispatch_group_wait(ma_dispatch_group_t group);
