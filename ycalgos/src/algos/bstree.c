/*
  rbtree.c Red Black Trees

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

bst_t* bst_alloc()
{
	bst_t *tree = (bst_t*)malloc(sizeof(*tree));

	if (tree) bst_init(tree);

	return tree;
}

bst_t* bst_clone_range(const bst_node_t *beg, const bst_node_t *end, bst_t* (*node_clone)(const bst_node_t *p), void (*node_destroy)(bst_node_t *p))
{
}

void bst_free(bst_t *ptree, void (*node_destroy)(bst_node_t *p, const void *args), const void *args)
{
	bst_clear(ptree, node_destroy, args);
	free(ptree);
}



/* eof */
