/*
  bstree.h: Binary Search Trees

  Copyright (C) 2011 yanyg (cppgp@qq.com)

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#ifndef __YCALGOS_BSTREE_H_
#define __YCALGOS_BSTREE_H_	1

#include <assert.h>
#include <stddef.h>

#include <yc/compiler.h>
#include <yc/algos/bstree-link.h>

/* bst_node_t is identical to bstlink_t */
typedef bstlink_t bst_node_t;

typedef struct bstree
{
	bst_node_t head;
	size_t count;
} bst_t;

/* NL: Node to Link; LN: Link to Node */
#define __BST_NL(p)	\
	((bstlink_t*)(p))
#define __BST_LN(p)	\
	((bst_node_t *)(p))

#define BST_INIT(tree) \
	bst_t tree = { {BSTLINK_INIT_HEAD(__BST_NL(&tree.head)),}, 0, }

static __always_inline void bst_init(bst_t *ptree)
{
	bstlink_init_head(__BST_NL(&ptree->head));
	ptree->count = 0;
}

void bst_clear(bst_t *ptree, void (*node_destroy)(bst_node_t *p, const void *args), const void *args);

static __always_inline size_t bst_size(const bst_t * const ptree)
{
	return ptree->count;
}

static __always_inline bool bst_empty(const bst_t * const ptree)
{
	return bstlink_empty(__BST_NL(&ptree->head));
}

static __always_inline bst_node_t* bst_begin(const bst_t * const ptree)
{
	return __BST_LN(bstlink_begin(__BST_NL(&ptree->head)));
}

static __always_inline bst_node_t* bst_rbegin(const bst_t * const ptree)
{
	return __BST_LN(bstlink_rbegin(__BST_NL(&ptree->head)));
}

static __always_inline bst_node_t* bst_end(const bst_t * const ptree)
{
	return __BST_LN(bstlink_end(__BST_NL(&ptree->head)));
}

static __always_inline bst_node_t* bst_rend(const bst_t * const ptree)
{
	return __BST_LN(bstlink_rend(__BST_NL(&ptree->head)));
}

bst_t* bst_alloc();
bst_t* bst_clone_range(const bst_node_t *beg, const bst_node_t *end, bst_t* (*node_clone)(const bst_node_t *p), void (*node_destroy)(bst_node_t *p));
void bst_free(bst_t *ptree, void (*node_destroy)(bst_node_t *p, const void *args), const void *args);

static __always_inline bst_t* bst_clone(const bst_t *ptree, bst_t* (*node_clone)(const bst_node_t *p), void (*node_destroy)(bst_node_t *p))
{
	return bst_clone_range(bst_begin(ptree), bst_end(ptree), node_clone, node_destroy);
}

/*
 * bstree_next/bstree_prev/bstree_rotate_left/bstree_rotate_right:
 * see yc/algos/bstree-base.h
 */
#define bstree_next(node)	\
	__bstree_base_next(BSTREE_BASE_NODE(node))

#define bstree_prev(node)	\
	__bstree_base_prev(BSTREE_BASE_NODE(node))

#define bstree_rotate_left(node)	\
	__bstree_base_rotate_left(BSTREE_BASE_NODE(node))

#define bstree_rotate_right(node)	\
	__bstree_base_rotate_right(BSTREE_BASE_NODE(node))

static __always_inline void bst_insert_unique(bst_t *ptree, bst_node_t *node, int (*compare)(const bst_node_t *node1, const bst_node_t *node2, const void *args), const void *args)
{
	bstlink_insert(&ptree->head, __BST_NL(node), (int (*const)(const bstlink_t*,const bstlink_t*,const void*))compare, args, true);
}

static __always_inline void bst_insert_equal(bst_t *ptree, bst_node_t *node, int (*compare)(const bst_node_t *node1, const bst_node_t *node2, const void *args), const void *args)
{
	bstlink_insert(&ptree->head, __BST_NL(node), (int (*const)(const bstlink_t*,const bstlink_t*,const void*))compare, args, false);
}

#endif /* __YCALGOS_BSTREE_H_ */
