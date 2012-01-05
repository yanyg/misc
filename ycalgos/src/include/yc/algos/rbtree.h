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

#ifndef __YC_ALGOS_RBTREE_H_
#define __YC_ALGOS_RBTREE_H_

/* bstree.h: base binary-tree */
#include <yc/algos/bstree-link.h>

struct rb_node
{
	struct __bst_link link;
	unsigned color;
#define RB_RED 0
#define RB_BLACK 1
} __aligned(sizeof(void*));

struct rbtree
{
	struct rb_node *node;
};

#define rb_entry(ptr, type, member)	container_of(ptr, type, member)

#define RB_INIT(name)	struct rbtree name =  { NULL, }
static inline void rb_init(struct rbtree *rb)
{
	rb->node = NULL;
}

void rb_insert_color(struct rb_node *node, struct rb_root *rb);
void rb_erase(struct rb_node *node, struct rb_root *rb);

#define rb_destroy(rb, destroy, arg)	rb_clear(rb, destroy, arg)
/* destroy all nodes of rb, then reset */
static inline void rb_clear(struct rbtree *rb,
			    void (*destroy)(struct rb_node *node,
					    const void *arg),
			    const void *arg)
{
	__bstlink_clear(rb->node, (__bstlink_destroy_t)destroy, arg);
	rb_init(rb);	/* re-init */
}

struct rbtree *rb_alloc(size_t num);
void rb_free(struct rbtree *rb,
	     size_t num,
	     void (*destroy)(struct rb_node *rb, const void *arg),
	     const void *arg);

bool rb_clone(struct rbtree *rb,
	      const struct rbtree *rb_src,
	      struct rb_node *(*node_clone)(const struct rb_node *node,
					    const void *arg),
	      void (*node_destroy)(struct rb_node *node, const void *arg),
	      const void *arg_clone,
	      const void *arg_destroy);

/* clone range: [beg, end) */
bool rb_clone_range(struct rbtree *rb,
		    const struct rb_node *beg,
		    const struct rb_node *end,
		    struct rb_node *(*node_clone)(const struct rb_node *node,
						  const void *arg),
		    void (*node_destroy)(struct rb_node *node, const void *arg),
		    const void *arg_clone,
		    const void *arg_destroy);

void rb_swap(struct rbtree *rb1, struct rbtree *rb2);

#define rb_parent(r)	((struct rb_node*)((r)->color & ~3))
#define rb_color(r)	((r)->color & 1)
#define rb_is_red(r)	(!rb_color(r))
#define rb_is_black(r)	rb_color(r)
#define rb_set_red(r)	do { (r)->color &= ~1; } while(0)
#define rb_set_black(r)	do { (r)->color |= 1; } while(0)

/* [Warning] time: O(n) */

#endif /* __YC_ALGOS_RBTREE_H_ */
