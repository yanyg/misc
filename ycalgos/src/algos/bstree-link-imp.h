/*
  bstree-link-imp.h: internal routines for all Binary Search Trees (rbtree, avltree, bstree, etc.)

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

#ifndef __BSTREE_LINK_IMP_H_
#define __BSTREE_LINK_IMP_H_

#include <assert.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdlib.h>

#include "bstree-link.h"

struct __bst_link *bstlink_first(const struct __bst_link *link)
{
	struct __bst_link *n;

	n = root->node;
}

struct __bst_link *bstlink_last(const struct __bst_link *root)
{
}

struct __bst_link *bstlink_next(const struct __bst_link *link)
{
}

struct __bst_link *bstlink_prev(const struct __bst_link *link)
{
}

#endif	/* __BSTREE_LINK_IMP_H_ */
