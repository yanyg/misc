/*
  rbtree.h Red Black Trees

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

#ifndef __RBTREE_H_
#define __RBTREE_H_

/* bstree.h: base binary-tree */
#include <yc/algos/bst.h>

#define YC_RBTREE_RED 0
#define YC_RBTREE_BLACK 1

typedef struct rbtree_node
{
	bstree_node node;
	unsigned long color;
} __aligned(sizeof(long)) rbtree_node;

#endif /* __RBTREE_H_ */
