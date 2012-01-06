#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include <yc/algos/rbtree.h>

struct node {
	int val;
	struct rb_node rb_node;
};

struct node* node_alloc(int val)
{
	struct node *p = malloc(sizeof(*p));

	if (p)
		p->val = val;

	return p;
}

void node_free(struct node *p)
{
	free(p);
}

static int compare(const struct rb_node *rb_node, const void *arg)
{
	struct node *p = rb_entry(rb_node, struct node, rb_node);

	return p->val - (int)arg;
}

static int compare_link(const struct rb_node *rb_node1,
			const struct rb_node *rb_node2,
			const void *arg)
{
	struct node *p1 = rb_entry(rb_node1, struct node, rb_node);
	struct node *p2 = rb_entry(rb_node2, struct node, rb_node);
	return p1->val - p2->val;
}

int main()
{
	int i;
	struct node *p;

	RB_DECLARE(rb);

	srand( (unsigned int)time(NULL) );

	for (i = 0; i < 100; ++i) {
		p = node_alloc(rand()%10 + 10);
		rb_insert(&p->rb_node, &rb, compare_link, NULL);
	}

	printf("insert over !!!\n");

#ifdef __YC_DEBUG__
	printf("depth: {%zu, %zu}\n", rb_depth_min(&rb), rb_depth_max(&rb));
#endif

	return 0;
}
