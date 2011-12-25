/*
  bstree-link.h: internal routines for all Binary Search Trees (rbtree, avltree, bstree, etc.)

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

#ifndef __BSTREE_LINK_H_
#define __BSTREE_LINK_H_	1

#include <assert.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdlib.h>

#include <yc/compiler.h>
#include <yc/algos/bstree-link.h>

/* !!! internal routines !!! */
typedef bstlink_t* (*bstlink_clone_t)(const bstlink_t *p, const void *arg);
typedef void (*bstlink_destroy_t)(bstlink_t *p, const void *args);
typedef void (*bstlink_erase_t)(bstlink_t *phead, bstlink_t *del, bstlink_destroy_t destroy, const void *args);
typedef int (*bstlink_compare_t)(const bstlink_t *p1, const bstlink_t *p2, const void *arg);

static __always_inline void __set_root(bstlink_t *phead, bstlink_t *link)
{
	phead->parent = link;
}

static __always_inline void __set_lmost(bstlink_t *phead, bstlink_t *link)
{
	phead->left = link;
}

static __always_inline void __set_rmost(bstlink_t *phead, bstlink_t *link)
{
	phead->right = link;
}

static __always_inline void __set_parent(bstlink_t *p, const bstlink_t *parent)
{
	p->parent = (bstlink_t*)parent;
}

static __always_inline void __set_lchild(bstlink_t *p, const bstlink_t *child)
{
	p->left = (bstlink_t*)child;
}

static __always_inline void __set_rchild(bstlink_t *p, const bstlink_t *child)
{
	p->right = (bstlink_t*)child;
}

static __always_inline bool __is_root(const bstlink_t *phead, const bstlink_t *p)
{
	return bstlink_root(phead) == p;
}

static __always_inline bool __is_left(const bstlink_t *p)
{
	return p == p->parent->left;
}

static __always_inline bool __is_right(const bstlink_t *p)
{
	return p == p->parent->right;
}

/*
 * __bstlink_clear
 *
 *	call bstlink_clear, reinit head, call macro __BSTLINK_CLEAR(phead)
 */
static __always_inline void __bstlink_clear(bstlink_t *phead, void (*destroy)(bstlink_t *p, const void *arg), const void *arg)
{
	if ( phead->parent )	/* root */
	{
		bstlink_clear(phead->parent, destroy, arg);
		bstlink_init_head(phead);
#ifndef __BSTLINK_CLEAR
#error "Please __BSTLINK_CLEAR(phead), if there need no operations, please defined as a empty macro"
#endif
		__BSTLINK_CLEAR(phead);
	}
}

static __always_inline bstlink_t* __bstlink_alloc(size_t size, size_t num)
{
	bstlink_t *phead;

	assert ( size && num );

	phead = (bstlink_t*)malloc(size*num);

	if ( phead )
	{
		int i;
		for ( i = 0; i < size; ++num)
		{
			bstlink_t *p = (bstlink_t*)( (char*)phead + (size*i) );

			bstlink_init_head( p );
#ifndef __BSTLINK_INIT_HEAD
#error "Please define __BSTLINK_INIT_HEAD to initialize head members"
#endif
			__BSTLINK_INIT_HEAD( p );
		}
	}

	return phead;
}

static __always_inline void __bstlink_free(bstlink_t *phead, size_t size, size_t num, void (*destroy)(bstlink_t *p, const void *arg), const void *arg)
{
	int i;

	for ( i = 0; i < num; ++i )
	{
		bstlink_t *p = (bstlink_t*)( (char*)phead + (size*i) );

		__bstlink_clear(p, destroy, arg);

#ifndef __BSTLINK_DESTROY_HEAD
#error "please defined __BSTLINK_DESTROY_HEAD"
#endif
		__BSTLINK_DESTROY_HEAD(p);
	}
}

void __bstlink_swap(bstlink_t *phead1, bstlink_t *phead2)
{
	/* exchanges */
	bstlink_t t = *phead1;
	*phead1 = *phead2;
	*phead2 = t;

	if ( ! phead1->parent ) phead1->left = phead1->right = phead1;
	if ( ! phead2->parent ) phead2->left = phead2->right = phead2;
}

/*
 * __bstlink_clone
 *	clone link and all descendant of link
 * Prerequsite
 *	root_src cannot be null ...
 */
static bstlink_t* __bstlink_clone_recursive(
	bstlink_t *parent,
	const bstlink_t *root_src,
	bstlink_clone_t node_clone,
	bstlink_destroy_t node_destroy,
	const void *arg_node_clone,
	const void *arg_node_destroy
)
{
	bstlink_t *clone, *top = parent;

	do
	{
		clone = node_clone(root_src, arg_node_clone);

		if ( !clone ) goto ERR;

		clone->left = clone->right = NULL;
		clone->parent = parent;
		parent->right = clone;	/* parent's right-member borrows to save clone's address */

#ifdef __BSTLINK_CLONE_NODE
		__BSTLINK_CLONE_NODE(clone, root_src);
#endif

		if ( root_src->left )
		{
			/* recursive */
			clone->left = __bstlink_clone_recursive(clone, root_src->left, node_clone, node_destroy, arg_node_clone, arg_node_destroy);
			clone->right = NULL;	/* borrowed to save clone's address, now reset to null */

			if ( !clone->left ) goto ERR;
		}

		parent = clone;
		root_src = root_src->right;
	}
	while ( root_src );

	/* success now */
	return top->right;

ERR:
	bstlink_clear(top->right, node_destroy, arg_node_destroy);
	return NULL;
}

static __always_inline bool __bstlink_clone(
	bstlink_t *phead,
	const bstlink_t *phead_src,
	bstlink_clone_t node_clone,
	bstlink_destroy_t node_destroy,
	const void *arg_node_clone,
	const void *arg_node_destroy
)
{
	if ( phead_src->parent )
	{
		bstlink_t *most, clone_head = BSTLINK_INIT_HEAD(clone_head), *clone = __bstlink_clone_recursive(&clone_head, phead_src->parent, node_clone, node_destroy, arg_node_clone, arg_node_destroy);
		if ( !clone ) return false;

		/* clear safely */
		__bstlink_clear(phead, node_destroy, arg_node_destroy);

		most = clone;
		while ( most->left ) most = most->left;
		phead->left = most;

		most = clone;
		while ( most->right ) most = most->right;
		phead->right = most;

		phead->parent = clone;
	}

	return true;
}

static __always_inline bool __bstlink_insert(bstlink_t *phead, bstlink_t *p, bstlink_compare_t compare, const void *arg, bool bunique)
{
#ifdef __BSTLINK_INSERT_REBALANCE
	if ( bstlink_insert(phead, p, compare, arg, bunique) )
	{
		__BSTLINK_INSERT_REBALANCE(p, phead->parent);
		return true;
	}
	return false;
#else
	return bstlink_insert(phead, p, compare, arg, bunique);
#endif
}

/*
	we cannot insert a range of links directly
	because insert will destroy the relationship
	but we can clone and insert a range of links ...
*/
static __always_inline bool __bstlink_insert_range_clone(
	bstlink_t *phead,
	const bstlink_t *beg,
	const bstlink_t *end,
	bstlink_clone_t node_clone,
	bstlink_destroy_t node_destroy,
	bstlink_compare_t compare,
	const void *arg_node_clone,
	const void *arg_node_destroy,
	const void *arg_compare
)
{
	bstlink_t clone_head, *clone;

	clone_head.parent = &clone_head;

	while ( beg != end )
	{
		clone = node_clone(beg, arg_node_clone);

		if ( !clone )
		{
			/* destroy all had been cloned */
			clone = clone_head.parent;

			while ( clone != &clone_head )
			{
				bstlink_t *del = clone;

				clone = clone->parent;
				
				node_destroy(del, arg_node_destroy);
			}

			return false;
		}

		__BSTLINK_CLONE_NODE(clone, beg);

		clone->parent = clone_head.parent;
		clone_head.parent = clone;
	}

	/* insert to tree */
	clone = clone_head.parent;
	while ( clone != &clone_head )
	{
		bstlink_t *ins = clone;

		clone = clone->parent;
		(void)__bstlink_insert(phead, ins, compare, arg_compare, false);
	}

	return true;
}

static __always_inline bool __bstlink_clone_range(
	bstlink_t *phead,
	const bstlink_t *beg,
	const bstlink_t *end,
	bstlink_clone_t node_clone,
	bstlink_destroy_t node_destroy,
	bstlink_compare_t node_compare,
	const void *arg_node_clone,
	const void *arg_node_destroy,
	const void *arg_node_compare
)
{
	bstlink_t clone_head = BSTLINK_INIT_HEAD(clone_head);

	if ( __bstlink_insert_range_clone(&clone_head, beg, end, node_clone, node_destroy, node_compare, arg_node_clone, arg_node_destroy, arg_node_compare) )
	{
		__bstlink_clear(phead, node_destroy, arg_node_destroy);

		__bstlink_swap(phead, &clone_head);

		return true;
	}

	return false;
}

/*
 * __bstlink_erase
 *
 * macros:
 *	__BSTLINK_ERASE_INTERIOR(successor-of-del, del)
 *		we used successor-of-del to replace del, so we should exchange
 *		info of successor-of-del and del.
 *		e.g., for rbtree, we should exchange the color(red/black) of
 *		successor-of-del and del.
 *
 *	__BSTLINK_ERASE_REBALANCE(phead, del, child, parent, scor)
 *		rebalance the tree
 */
static __always_inline void __bstlink_erase(bstlink_t *phead, bstlink_t *del, bstlink_destroy_t destroy, const void *args)
{
	bstlink_t *child;

#ifdef __BSTLINK_ERASE_REBALANCE
#define __BSTLINK_ERASE_PARENT_DECLARED()	bstlink_t *__erase_parent
#define __BSTLINK_ERASE_PARENT_GET()	__erase_parent
#define __BSTLINK_ERASE_PARENT_SET(p)	__erase_parent = (p)
#else
#define __BSTLINK_ERASE_PARENT_DECLARED()
#define __BSTLINK_ERASE_PARENT_GET()
#define __BSTLINK_ERASE_PARENT_SET(p)
#endif
	__BSTLINK_ERASE_PARENT_DECLARED();

	assert ( phead );
	assert ( del );
	assert ( phead != del );

	if ( NULL == del->left || NULL == del->right )
	{
		__BSTLINK_ERASE_PARENT_SET(del->parent);
		child = ( NULL == del->left ? del->right : del->left );

		if ( phead->parent == del )				/* del is root */
			phead->parent = child;
		else if ( del->parent->left == del )	/* del is left-child */
			del->parent->left = child;
		else									/* del is right-child */
			del->parent->right = child;

		/* update lmost & rmost */
		if ( child )
		{
			child->parent = del->parent;

			/* child exists, so 'del' cannot be both lmost & rmost */
			bstlink_t *most = child;	/* most: left- or right-most */
			if ( phead->left == del )	/* del is left-most */
			{
				while ( most->left ) most = most->left;
				phead->left = most;	/* new left-most*/
			}
			else if ( phead->right == del )	/* del is right-most */
			{
				while ( most->right ) most = most->right;
				phead->right = most;	/* new right-most */
			}
		}
		else
		{
			/* del has no child. if del is root,
				its means the tree just has one node del, and then
				lmost & rmost are both lmost & rmost, so
				we try test both lmost & rmost
			 */
			if ( phead->left == del ) phead->left = del->parent;
			if ( phead->right == del ) phead->right = del->parent;
		}
	}
	else
	{
		/* left- & right-child of del are non-null */
		bstlink_t *scor = del->right;	/* scor: successor */

		/* get del's successor */
		scor = del->right;
		while ( scor->left ) scor = scor->left;

		child = scor->right;	/* left-child of scor must be null */
		del->left->parent = scor;
		scor->left = del->left;

		if ( scor != del->right )
		{
			/* scor is not the direct right-child of del */
			__BSTLINK_ERASE_PARENT_SET(scor->parent);

			if ( child ) child->parent = scor->parent;
			scor->parent->left = child;
			scor->right = del->right;
			del->right->parent = scor;
		}
		else /* scor is direct right-child of del */
			__BSTLINK_ERASE_PARENT_SET(scor);

		/* change color/depth etc . */
#ifdef __BSTLINK_ERASE_INTERIOR
		__BSTLINK_ERASE_INTERIOR(scor, del);
#endif
		/* update root/lmost/rmost */
		if ( phead->parent == del )
		{
			phead->parent = scor;
		}
		else if ( del == del->parent->left )
		{
			del->parent->left = scor;
		}
		else
		{
			del->parent->right = scor;
		}

		scor->parent = del->parent;
	}

#ifdef __BSTLINK_ERASE_REBALANCE
	__BSTLINK_ERASE_REBALANCE(phead, del, child, __BSTLINK_ERASE_PARENT_GET(), scor);
#endif

	destroy(del, args);	/* and last destroy the node del */
}

static __always_inline size_t __bstlink_erase_range(bstlink_t *phead, bstlink_t *beg, bstlink_t *end, bstlink_erase_t erase, bstlink_destroy_t destroy, const void *args)
{
	size_t c = 0;

	while ( beg != end )
	{
		bstlink_t *del = beg;
		beg = bstlink_next(beg);
		erase(phead, del, destroy, args);
		++c;
	}

	return c;
}

#endif	/* __BSTREE_LINK_H_ */
