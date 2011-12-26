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
typedef struct bst_node
{
	bstlink_t link;
}
bst_node_t;

typedef struct bstree
{
	bst_node_t head;
	size_t size;
} __aligned(sizeof(void*)) bst_t;

#define BST_INIT(tree) \
	bst_t tree = { { BSTLINK_INIT_HEAD( (bstlink_t*)&tree ), }, 0, }

static __always_inline void bst_init(bst_t *ptree)
{
	bstlink_init_head( (bstlink_t*)ptree );
	ptree->size = 0;
}

bst_t* bst_alloc(size_t num);
void bst_free(bst_t *ptree, size_t num, void (*destroy)(bst_node_t *p, const void *arg), const void *arg);

bool bst_clone(
	bst_t *ptree,
	const bst_t *ptree_src,
	bst_node_t* (*node_clone)(const bst_node_t *p, const void *arg),
	void (*node_destroy)(bst_node_t *p, const void *arg),
	const void *arg_node_clone,
	const void *arg_node_destroy
);	

bool bst_clone_range(
	bst_t *ptree,
	const bst_node_t *beg,
	const bst_node_t *end,
	bst_node_t* (*node_clone)(const bst_node_t *p, const void *arg),
	void (*node_destroy)(bst_node_t *p, const void *arg),
	int (*node_compare)(const bst_node_t *p1, const bst_node_t *p2, const void *arg),
	const void *arg_node_clone,
	const void *arg_node_destroy,
	const void *arg_compare
);

void bst_swap(bst_t *ptree1, bst_t *ptree2);
void bst_clear(bst_t *ptree, void (*destroy)(bst_node_t *p, const void *arg), const void *arg);

static __always_inline size_t bst_size(const bst_t * const ptree)
{
	return ptree->size;
}

static __always_inline bool bst_empty(const bst_t * const ptree)
{
	return bstlink_empty( (bstlink_t*)ptree );
}

static __always_inline bst_node_t* bst_begin(const bst_t * const ptree)
{
	return (bst_node_t*)bstlink_begin( (const bstlink_t*)ptree );
}

static __always_inline bst_node_t* bst_rbegin(const bst_t * const ptree)
{
	return (bst_node_t*) bstlink_rbegin( (const bstlink_t*)ptree );
}

static __always_inline bst_node_t* bst_end(const bst_t * const ptree)
{
	return (bst_node_t*) bstlink_end( (const bstlink_t*)ptree );
}

static __always_inline bst_node_t* bst_rend(const bst_t * const ptree)
{
	return (bst_node_t*) bstlink_rend( (const bstlink_t*)ptree );
}

static __always_inline bst_node_t* bst_next(const bst_node_t *p)
{
	return (bst_node_t*) bstlink_next( (const bstlink_t*)p );
}

static __always_inline bst_node_t* bst_prev(const bst_node_t *p)
{
	return (bst_node_t*) bstlink_prev( (const bstlink_t*)p );
}

static __always_inline const bst_node_t* bst_lower_bound(const bst_t *ptree, int (*compare)(const bst_node_t *p, const void *arg), const void *arg)
{
	return (const bst_node_t*)bstlink_lower_bound(
				(const bstlink_t*)ptree,
				(int (*)(const bstlink_t*, const void*arg))compare,
				arg
			);
}

static __always_inline const bst_node_t* bst_upper_bound(const bst_t *ptree, int (*compare)(const bst_node_t *p, const void *arg), const void *arg)
{
	return (const bst_node_t*)bstlink_upper_bound(
				(const bstlink_t*)ptree,
				(int (*)(const bstlink_t*,const void*))compare,
				arg
			);
}

static __always_inline size_t bst_count(const bst_t *ptree, int (*compare)(const bst_node_t *p, const void *arg), const void *arg)
{
	return bstlink_count(
				(const bstlink_t*)ptree,
				(int (*)(const bstlink_t*,const void*))compare,
				arg
			);
}

static __always_inline const bst_node_t* bst_find(const bst_t *ptree, int (*compare)(const bst_node_t *p, const void *arg), const void *arg)
{
	return (bst_node_t*)bstlink_find(
				(const bstlink_t*)ptree,
				(int (*)(const bstlink_t*,const void*))compare,
				arg
			);
}

static __always_inline void bst_insert_unique(bst_t *ptree, bst_node_t *node, int (*const compare)(const bst_node_t *node1, const bst_node_t *node2, const void *args), const void *arg)
{
	bstlink_insert(
		(bstlink_t*)&ptree->head,
		(bstlink_t*)node,
		(int (*const)(const bstlink_t*,const bstlink_t*,const void*))compare,
		arg,
		true	/* unique */
		);
	++ptree->size;
}

static __always_inline void bst_insert_equal(bst_t *ptree, bst_node_t *node, int (*compare)(const bst_node_t *node1, const bst_node_t *node2, const void *args), const void *arg)
{
	bstlink_insert(
		(bstlink_t*)&ptree->head,
		(bstlink_t*)node,
		(int (*const)(const bstlink_t*,const bstlink_t*,const void*))compare,
		arg,
		false /* multi */
		);
	++ptree->size;
}

void bst_erase(bst_node_t *ptree, bst_node_t *del, void (*destroy)(bst_node_t *p, const void *arg), const void *arg);

void bst_erase_range(bst_t *ptree, bst_node_t *del_beg, bst_node_t *del_end, void (*destroy)(bst_node_t *p, const void *arg), const void *arg);

#ifdef __YC_DEBUG__
/*
 * bmax
 *  true:  the maximum depth of phead
 *  false: the minimum depth of phead
 */
static __always_inline size_t bst_depth(const bst_t *ptree, bool bmax)
{
	return bstlink_depth( (const bstlink_t*)ptree, bmax);
}

#endif

#endif /* __YCALGOS_BSTREE_H_ */
