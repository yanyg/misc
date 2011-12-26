/*
  bstree.c Binary Search Trees

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

#include <malloc.h>

#include <yc/algos/bstree.h>

/* predefined macros */
#define __BSTLINK_INIT_HEAD(phead)
#define __BSTLINK_DESTROY_HEAD(phead)
#define __BSTLINK_CLEAR(phead)	((bst_t*)phead)->size = 0
#define __BSTLINK_CLONE_NODE(clone, beg)
#define __BSTLINK_SWAP(phead1, phead2)	{\
	size_t t =  ((bst_t*)phead1)->size;\
	((bst_t*)phead1)->size = ((bst_t*)phead2)->size;\
	((bst_t*)phead2)->size = t;\
	}

#include "bstree-link.h"	/* internal routines */

void bst_swap(bst_t *ptree1, bst_t *ptree2)
{
	__bstlink_swap( (bstlink_t*)ptree1, (bstlink_t*)ptree2 );
}

void bst_clear(bst_t *ptree, void (*destroy)(bst_node_t *p, const void *arg), const void *arg)
{
	__bstlink_clear(
		(bstlink_t*)ptree,
		(bstlink_destroy_t)destroy,
		arg
		);
}
bst_t* bst_alloc(size_t num)
{
	return (bst_t*)__bstlink_alloc(sizeof(bst_t), num);
}

bool bst_clone(
	bst_t *ptree,
	const bst_t *ptree_src,
	bst_node_t* (*node_clone)(const bst_node_t *p, const void *arg),
	void (*node_destroy)(bst_node_t *p, const void *arg),
	const void *arg_node_clone,
	const void *arg_node_destroy
	)
{
	return __bstlink_clone(
			(bstlink_t*)ptree,
			(const bstlink_t*)ptree_src,
			(bstlink_clone_t)node_clone,
			(bstlink_destroy_t)node_destroy,
			arg_node_clone,
			arg_node_destroy
			);
}

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
)
{
	return __bstlink_clone_range(
				(bstlink_t*)ptree,
				(const bstlink_t*)beg,
				(const bstlink_t*)end,
				(bstlink_clone_t)node_clone,
				(bstlink_destroy_t)node_destroy,
				(bstlink_compare_t)node_compare,
				arg_node_clone,
				arg_node_destroy,
				arg_compare);
}

void bst_free(bst_t *ptree, size_t num, void (*destroy)(bst_node_t *p, const void *arg), const void *arg)
{
	__bstlink_free(
		(bstlink_t*)ptree,
		sizeof(bst_t),
		num,
		(bstlink_destroy_t)destroy,
		arg
	);
}

void bst_erase(bst_node_t *ptree, bst_node_t *del, void (*destroy)(bst_node_t *p, const void *arg), const void *arg)
{
	__bstlink_erase(
		(bstlink_t*)ptree,
		(bstlink_t*)del,
		(bstlink_destroy_t)destroy,
		arg
	);
}

void bst_erase_range(bst_t *ptree, bst_node_t *del_beg, bst_node_t *del_end, void (*destroy)(bst_node_t *p, const void *arg), const void *arg)
{
	__bstlink_erase_range(
		(bstlink_t*)ptree,
		(bstlink_t*)del_beg,
		(bstlink_t*)del_end,
		(bstlink_erase_t)bst_erase,
		(bstlink_destroy_t)destroy,
		arg
	);
}

/* eof */
