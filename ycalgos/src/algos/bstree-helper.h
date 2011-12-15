/*
  bstree-base.h: routines for all Binary Search Trees (rbtree, avltree, bstree, etc.)

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

#ifndef __BSTREE_HELPER_H_
#define __BSTREE_HELPER_H_	1

#include <stddef.h>
#include <stdbool.h>

#include <yc/compiler.h>
#include <yc/algos/bstree-base.h>

#ifndef _BSTREE_TYPE
#error "Please define _BSTREE_TYPE with real type like as follow: #define _BSTREE_TYPE(x) ((struct bstree_t*)(x))"
#endif

#ifndef _BSTREE_NODE
#error "Please define _BSTREE_NODE with real type like as follow: #define _BSTREE_NODE(x) ((struct bstree_node*)(x))"
#endif

/* for node */
#define _NODE(x)	_BSTREE_NODE(x)
#define _PARENT(x)	(_NODE(x)->parent)
#define _LEFT(x)	(_NODE(x)->left)
#define _RIGHT(x)	(_NODE(x)->right)

/* for tree */
#define _HEAD(tree)		( _BSTREE_NODE(&_BSTREE_TYPE(tree)->head) )
#define _ROOT(x)		_PARENT(_HEAD(tree))
#define _LEFTMOST(x)	_LEFT(_HEAD(tree))
#define _RIGHTMOST(x)	_RIGHT(_HEAD(tree))

#endif /* __BSTREE_HELPER_H_ */
