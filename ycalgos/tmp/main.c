#include <yc/algos/bstree.h>
#include <stdio.h>

int main()
{
	YC_BSTREE_INIT(bst);
	yc_bstree_t bst1;
	yc_bstree_init(&bst1);

	printf("sizeof(bst)=%u\n", sizeof(bst));

	if (yc_bstree_empty(bst))
	{
		printf("bst tree is empty\n");
	}

	if (yc_bstree_empty(bst1))
	{
		printf("bst1 tree is empty\n");
	}
	return 0;
}
