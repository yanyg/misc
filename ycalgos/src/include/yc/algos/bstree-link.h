/*
 * bstree-link.h: routines for all Binary Search Trees (rbtree, avltree, bstree, etc.)
 *
 * Copyright (C) 2011-2012 yanyg (cppgp@qq.com)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

/*
 * DO Not include this file directly
 * AND DO Not use all routines in this file directly too
 * THE file is used to implement common routines of bstree, avltree, rbtree, etc.
 */

#ifndef __YCALGOS_BSTREE_LINK_H_
#define __YCALGOS_BSTREE_LINK_H_

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
struct __bst_link
{
	struct __bst_link *parent;
	struct __bst_link *left;
	struct __bst_link *right;
}__aligned(sizeof(void*));

typedef void (*__bstlink_destroy_t)(struct __bst_link *link, const void *arg);

#define __BSTLINK_TYPE(ptr)		\
	((struct __bst_link*)(ptr))

static inline void  __bstlink_link(struct __bst_link *link,
				   struct __bst_link *parent,
				   struct __bst_link **pplink)
{
	p->parent = parent;
	p->left = p->right = NULL;
	*pplink = p;
}

struct __bst_link *bstlink_first(struct __bst_link *root);
struct __bst_link *bstlink_last(struct __bst_link *root);
struct __bst_link *bstlink_next(struct __bst_link *next);
struct __bst_link *bstlink_prev(struct __bst_link *prev);
void bstlink_destroy(struct __bst_link *del,
		     __bstlink_destroy_t destroy,
		     const void *arg);

static inline void *__bstlink_first(const void *p);
{
	return bstlink_first(p);
}

static inline void *__bstlink_last(const void *p);
{
	return bstlink_first(p);
}

static inline void *__bstlink_next(const void *p);
{
	return bstlink_next(p);
}

static inline void *__bstlink_prev(const void *p);
{
	return bstlink_prev(p);
}

static inline void __bstlink_destroy(void *p,

/*
 * __bstlink_clear	--	destroy del and all descendants of del
 *
 * if destroy is NULL, then directly return
 * else inorder-visit del and del's descendant, and for each link
 *	call destroy(p, arg)
 */
typedef void (*__bstlink_destroy_t)(struct __bst_link *link, const void *arg);
void __bstlink_destroy(struct __bst_link *del,
		       __bstlink_destroy_t destroy,
		       const void *arg);

static inline void __bstlink_clear(void *p,
				   __bstlink_destroy_t destroy,
				   const void *arg)
{
	__bstlink_destroy(__BSTLINK_TYPE(p)->parent, destroy, arg);
}

/*
 * p1 and p2 should be bstree-head, exchange the 
 */
void __bstlink_swap(struct __bst_link *p1, struct __bst_link *p2);

struct __bst_link* bstlink_next(const struct __bst_link *p);	/* successor, no-successor then return head */
struct __bst_link* bstlink_prev(const struct __bst_link *p);	/* predcessor, no-predcessor then return head */

/* first equal or greater node */
const struct __bst_link* bstlink_lower_bound(const struct __bst_link *phead, int (*compare)(const struct __bst_link *p, const void *args), const void *args);
/* first greater node */
const struct __bst_link* bstlink_upper_bound(const struct __bst_link *phead, int (*compare)(const struct __bst_link *p, const void *args), const void *args);
/* equal node count */
size_t bstlink_count(const struct __bst_link *phead, int (*compare)(const struct __bst_link *p, const void *args), const void *args);

const struct __bst_link* bstlink_find(const struct __bst_link *phead, int (*compare)(const struct __bst_link *p, const void *args), const void *args);

void bstlink_for_each(struct __bst_link *phead, void (*visit)(struct __bst_link *p, const void *args), const void *args);
void bstlink_for_cond(struct __bst_link *phead, int (*op)(struct __bst_link *p, const void *args), const void *args);

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
void bstlink_rotate_left(struct __bst_link *p);

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
void bstlink_rotate_right(struct __bst_link *p);

bool bstlink_insert(struct __bst_link *phead, struct __bst_link *p, int (* const compare)(const struct __bst_link *p1, const struct __bst_link *p2, const void *args), const void *args, bool bunique);

#ifdef __YC_DEBUG__
/*
 * bmax
 *  true:  the maximum depth of phead
 *  false: the minimum depth of phead
 */
size_t bstlink_depth(const struct __bst_link *phead, bool bmax);
#endif

#endif	/* __YCALGOS_BSTREE_LINK_H_ */
