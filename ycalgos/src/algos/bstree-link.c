/*
  bstree-link.c

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

#include <assert.h>
#include <stddef.h>

#include <yc/algos/bstree-link.h>

//#include "bstree-link.h"	/* internal used */

#define BSTLINK_P(p)	((bstlink_t*)p)

bstlink_t* bstlink_next(const bstlink_t *node)
{
	assert( node );

	/* node is head and tree empty */
	if ( node->parent == NULL ) return BSTLINK_P(node);

	if ( node->right )
	{
		/*
		 * If the node has a right child, go down and trace left child
		 * as far as we can.
		 */
		node = node->right;
		while ( node->left )
			node = node->left;

		return BSTLINK_P(node);
	}

	/*
	 * No right child, go up and trace the parent of the node which
	 * right child isn't the node any more.
	 *
	 * Note now node's parent cannot be NULL!
	 */
	const bstlink_t *parent;
	while ( (parent=node->parent, node) != parent->parent && node == parent->right )
		node = parent;

	return BSTLINK_P(node);
}

bstlink_t* bstlink_prev(const bstlink_t *node)
{
	assert( node );

	/* node is head and tree empty */
	if ( node->parent == NULL ) return BSTLINK_P(node);

	if ( node->left )
	{
		/*
		 * If the node has a left child, go down and trace right child
		 * as far as we can.
		 */
		node = node->left;
		while ( node->right )
			node = node->right;

		return BSTLINK_P(node);
	}

	/*
	 * No left child, go up and trace the parent of the node which
	 * left child isn't the node any more.
	 */
	const bstlink_t *parent;
	while ( (parent=node->parent, node) != parent->parent && node == parent->left )
		node = parent;

	return BSTLINK_P(node);
}

const bstlink_t* bstlink_find(const bstlink_t *phead, int (*compare)(const bstlink_t *p, const void *args), const void *args)
{
	const bstlink_t *rtn = phead, *child = bstlink_root(phead);

	while (child)
	{
		int icmp = compare(child, args);

		if ( icmp < 0 )
		{
			child = child->right;
		}
		else
		{
			/* for multi-bstree, select the leftmost-matched node */
			if ( 0 == icmp ) rtn = child;
			else if ( rtn != phead ) break;	/* success .. */
			child = child->left;
		}
	}

	return rtn;
}

const bstlink_t* bstlink_lower_bound(const bstlink_t *phead, int (*compare)(const bstlink_t *p, const void *args), const void *args)
{
	const bstlink_t *lb = phead, *child = bstlink_root(phead);

	while (child)
	{
		if ( compare(child, args) >= 0 )
		{
			lb = child;
			child = child->left;
		}
		else
		{
			child = child->right;
		}
	}

	return lb;
}

const bstlink_t* bstlink_upper_bound(const bstlink_t *phead, int (*compare)(const bstlink_t *p, const void *args), const void *args)
{
	const bstlink_t *ub = phead, *child = bstlink_root(ub);

	while (child)
	{
		if ( compare(child, args) > 0 )
		{
			ub = child;
			child = child->left;
		}
		else
		{
			child = child->right;
		}
	}

	return ub;
}

size_t bstlink_count(const bstlink_t *phead, int (*compare)(const bstlink_t *p, const void *args), const void *args)
{
	size_t cnt = 0;
	const bstlink_t
		*lb = bstlink_lower_bound(phead, compare, args),
		*ub = bstlink_upper_bound(phead, compare, args);

	/* count: [lb, ub) */
	while ( lb != ub )
	{
		++cnt;
		lb = bstlink_next(lb);
	}

	return cnt;
}

void bstlink_rotate_left(bstlink_t *node)
{
	bstlink_t *p;

	assert( node );
	assert( node->right );

	p = node->right;
	node->right = p->left;
	if ( p->left ) p->left->parent = node;
	p->parent = node->parent;

	if ( node == node->parent->parent )
		node->parent->parent = p;	/* node is root and node->parent is head */
	else if ( node == node->parent->left )
		node->parent->left = p;
	else
		node->parent->right = p;

	p->left = node;
	node->parent = p;
}

void bstlink_rotate_right(bstlink_t *node)
{
	bstlink_t *p;

	assert( node );
	assert( node->left );

	p = node->left;
	node->left = p->right;
	if ( p->right ) p->right->parent = node;
	p->parent = node->parent;

	if ( node == node->parent->parent )
		node->parent->parent = p;	/* node is root and node->parent is head */
	else if ( node == node->parent->left )
		node->parent->left = p;
	else
		node->parent->right = p;

	p->right = node;
	node->parent = p;
}

static void _visit_inorder(bstlink_t *p, void (*visit)(bstlink_t *p, const void *args), const void *args)
{
	while (p)
	{
		_visit_inorder(p->left, visit, args);
		visit(p, args);
		p = p->right;
	}
}

void bstlink_for_each(bstlink_t *phead, void (*visit)(bstlink_t *p, const void *args), const void *args)
{
	_visit_inorder(bstlink_root(phead), visit, args);
}

#ifdef __YC_DEBUG__
static size_t _depth(bstlink_t *root, bool bmax)
{
	size_t depth = 0;

	if ( root )
	{
		size_t left = 0, right = 0;

		/* recursive */
		if ( root->left ) left = bstlink_depth(root->left, bmax);
		if ( root->right ) right = bstlink_depth(root->right, bmax);

#ifndef max
#define max(x,y)	( (x) > (y) ? (x) : (y) )
#endif
#ifndef min
#define min(x,y)	( (x) < (y) ? (x) : (y) )
#endif
		depth = bmax ? max(left, right) : min(left, right);

		++depth;
	}

	return depth;
}

size_t bstlink_depth(bstlink_t *phead, bool bmax)
{
	return _depth( bstlink_root(phead), bmax);
}

#endif

static bool bstlink_insert(bstlink_t *phead, bstlink_t *p, int (* const compare)(const bstlink_t *p1, const bstlink_t *p2, const void *args), const void *args, bool bunique)
{
	int icmp = 0;
	bstlink_t *pos = phead, *root = bstlink_root(phead);

	while(root)
	{
		pos = root;

		icmp = compare(root, p, args);
		if ( icmp > 0 )
		{
			root = root->left;
		}
		else
		{
			if ( 0 == icmp && bunique ) return false;	/* for unique-bstree, icmmp == 0 means insert failed. */
			root = root->right;
		}
	}

	if (pos == phead)
	{
		/* empty tree */
		phead->parent = phead->left = phead->right = p;
	}
	else if (icmp > 0)
	{
		pos->left = p;
		if (pos == phead->left) phead->left = p;
	}
	else
	{
		pos->right = p;
		if (pos == phead->right) phead->right = p;
	}

	p->parent = pos;
	p->left = p->right = NULL;
}

void bstlink_erase(bstlink_t *phead, bstlink_t *p, void (*destroy)(bstlink_t *p, const void *args), const void *args)
{
	bstlink_t *child;

	assert ( phead );
	assert ( phead != p && p );

	if ( NULL == p->left || NULL == p->right )
	{
		child = NULL == p->left ? p->right : p->left;

		if ( bstlink_root(phead) == p )

		{

		}
	}
}

/* eof */
