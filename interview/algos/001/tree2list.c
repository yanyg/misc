#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <sys/types.h>

#define BST_SIZE 10

struct bst_node {
	struct bst_node *left, *right;
	size_t value;
};

static inline struct bst_node *
rotate_left(struct bst_node *link, struct bst_node *parent)
{
	struct bst_node *r;

	assert(link && link->right);
	/*
	 *  link                    right
	 *  /  \                    /   \
	 * T1  right    -->      link   T3
	 *    /   \              /  \
	 *   T2   T3            T1  T2
	 */

	r = link->right;
	link->right = r->left;
	r->left = link;
	if (parent)
		parent->left = r;

	return r;
}

struct bst_node *bst2list(struct bst_node *root)
{
	struct bst_node *r = NULL;

	while (root) {
		while (root->right)
			root = rotate_left(root, r);

		root->right = r;
		r = root;
		root = root->left;
	}

	return r;
}

void bst_insert(struct bst_node *new, struct bst_node **proot)
{

	while (*proot) {
		if ((*proot)->value > new->value)
			proot = &(*proot)->left;
		else
			proot = &(*proot)->right;
	}
	*proot = new;
	new->left = new->right = NULL;
}

void bst_print(struct bst_node *root)
{
	while (root) {
		printf("inorder node value : %zu\n", root->value);

		if (root->left)
			bst_print(root->left);

		root = root->right;
	}
}

int main(int argc, char **argv)
{
	size_t i, size = BST_SIZE;
	struct bst_node *node, *root = NULL;

	if (argc == 2) {
		size = (size_t)atoi(argv[1]);
	}

	srand((unsigned int)time(NULL));
	for (i = 0; i < size; ++i) {
		node = malloc(sizeof(*node));
		if (!node)
			exit(1);

		node->value = (size_t)rand()%1000;
		bst_insert(node, &root);
	}

	printf("-------------    Tree Reverse   ----------------\n");
	bst_print(root);

	printf("------------- Smallest -> Biggest ----------------\n");
	root = bst2list(root);
	node = root;
	while (node) {
		printf("node->value = %zu\n", node->value);
		node = node->right;
	}

	printf("-------------- Biggest -> Smallest ---------------\n");
	node = root;
	while (node->right)
		node = node->right;
	while (node) {
		printf("node->value = %zu\n", node->value);
		node = node->left;
	}

	return 0;
}
