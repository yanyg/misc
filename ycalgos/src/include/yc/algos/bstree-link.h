/*
  bstree-link.h: routines for all Binary Search Trees (rbtree, avltree, bstree, etc.)

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

#ifndef __YCALGOS_BSTREE_LINK_H_
#define __YCALGOS_BSTREE_LINK_H_	1

#include <stddef.h>
#include <stdbool.h>

#include <yc/compiler.h>

/*
 * Binary-Search-Tree Implementation Rules
 *
 *   --> a head dummy node
 *   --> head's parent point to the root of the tree
 *   --> head's left point to the leftmost node of the tree
 *   --> head's right point to the rightmost node of the tree
 *   --> root's parent point to the head of the tree
 *   --> For empty tree, head.parent = NULL, head.left = head.right = &head.
 *   --> For non-empty tree, root.parent == &head and head.parent == &root, and
 *           head.left = <leftmost-tree>, head.right = <rightmost-tree>
 */

/* bstlink: Binary Search Tree Link  */
typedef struct bstlink_type
{
	struct bstlink_type *parent, *left, *right;
} __aligned(sizeof(long)) bstlink_t;

#define BSTLINK_INIT_HEAD(head)	\
	{ NULL, &(head), &(head) }
static __always_inline void bstlink_init_head(bstlink_t *phead)
{
	phead->parent = NULL;
	phead->left = phead->right = phead;
}

static __always_inline bstlink_t* bstlink_root(const bstlink_t *phead)
{
	return (bstlink_t*)phead->parent;
}

static __always_inline bstlink_t* bstlink_lmost(const bstlink_t *phead)
{
	return (bstlink_t*)phead->left;
}

static __always_inline bstlink_t* bstlink_rmost(const bstlink_t *phead)
{
	return (bstlink_t*)phead->right;
}

/* the C++ STL-like interfaces */
static __always_inline bstlink_t* bstlink_begin(const bstlink_t *phead)
{
	return bstlink_lmost(phead);
}
static __always_inline bstlink_t* bstlink_rbegin(const bstlink_t *phead)
{
	return bstlink_rmost(phead);
}
static __always_inline const bstlink_t* bstlink_end(const bstlink_t *phead)
{
	return phead;
}
static __always_inline const bstlink_t* bstlink_rend(const bstlink_t *phead)
{
	return phead;
}
static __always_inline bool bstlink_empty(const bstlink_t *phead)
{
	return NULL == phead->parent;
}

bstlink_t* bstlink_next(const bstlink_t *p);	/* successor, no-successor then return head */
bstlink_t* bstlink_prev(const bstlink_t *p);	/* predcessor, no-predcessor then return head */

/* first equal or greater node */
const bstlink_t* bstlink_lower_bound(const bstlink_t *phead, int (*compare)(const bstlink_t *p, const void *args), const void *args);
/* first greater node */
const bstlink_t* bstlink_upper_bound(const bstlink_t *phead, int (*compare)(const bstlink_t *p, const void *args), const void *args);
/* equal node count */
size_t bstlink_count(const bstlink_t *phead, int (*compare)(const bstlink_t *p, const void *args), const void *args);

const bstlink_t* bstlink_find(const bstlink_t *phead, int (*compare)(const bstlink_t *p, const void *args), const void *args);

void bstlink_for_each(bstlink_t *phead, void (*visit)(bstlink_t *p, const void *args), const void *args);
void bstlink_for_cond(bstlink_t *phead, int (*op)(bstlink_t *p, const void *args), const void *args);

/*
 * bstlink_rotate_left
 *
 *  Illustration
 *      |               |
 *      X               Y
 *     / \             / \
 *    T1  Y  ---->    X   T3
 *       / \         / \
 *      T2 T3      T1  T2
 *
 *  Prerequisites
 *    X and Y(the right child of X) MUST not be NULL
 *    T1, T2, and T3 are subtrees which can be empty or non-empty
 */
void bstlink_rotate_left(bstlink_t *p);

/*
 * bstlink_rotate_right
 *
 *  Illustration
 *        |            |
 *        X            Y
 *       / \          / \
 *      Y  T1  --->  T2  X
 *     / \          / \
 *    T2 T3        T2  T3
 *
 *  Prerequisites
 *    X and Y(the left child of X) MUST not be NULL
 *    T1, T2, and T3 are subtrees which can be empty or non-empty
 *
 */
void bstlink_rotate_right(bstlink_t *p);

bool bstlink_insert(bstlink_t *phead, bstlink_t *p, int (* const compare)(const bstlink_t *p1, const bstlink_t *p2, const void *args), const void *args, bool bunique);
void bstlink_erase(bstlink_t *phead, bstlink_t *p, void (*destroy)(bstlink_t *p, const void *args), const void *args);

#ifdef __YC_DEBUG__
/*
 * bmax
 *  true:  the maximum depth of phead
 *  false: the minimum depth of phead
 */
size_t __bstlink_depth(bstlink_t *phead, bool bmax);
#endif

#endif	/* __YCALGOS_BSTREE_LINK_H_ */
