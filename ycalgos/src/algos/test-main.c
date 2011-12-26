#include <stdio.h>

#include <yc/algos/bstree.h>

typedef struct node_int
{
	bst_node_t node;
	int i;
}
node_int_t;

int compare(const bst_node_t *node1, const bst_node_t *node2, const void *args)
{
	node_int_t *p1 = (node_int_t*)node1;
	node_int_t *p2 = (node_int_t*)node2;

	return p1->i - p2->i;
}

int main()
{
	bst_t *bst = bst_alloc(1);
	if (bst)
	{
		printf("bst_alloc success ...\n");
		printf("empty-depth=%u\n", bst_depth(bst, true));
		node_int_t node;
		node.i = 100;
		bst_insert_unique(bst,&node.node, compare, NULL);
		printf("empty-depth=%u,%u\n", bst_depth(bst, true), bst_depth(bst, false));
		node_int_t n200;
		n200.i = 200;
		bst_insert_unique(bst,&n200.node, compare, NULL);
		printf("empty-depth=%u,%u\n", bst_depth(bst, true), bst_depth(bst, false));
	}
	return 0;
}
