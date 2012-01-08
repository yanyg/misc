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

__BEGIN_DECLS

struct rb_node
{
	bst_link_member(struct rb_node);
	unsigned color;
#define RB_COLOR_RED 0
#define RB_COLOR_BLACK 1
} __aligned(sizeof(void*));

struct rb_root
{
	struct rb_node *node;
};

#define rb_entry(ptr, type, member)	container_of(ptr, type, member)

#define RB_DECLARE(name)	struct rb_root name =  { NULL, }
#define RB_INIT(name)	do { (name).node = NULL; } while (0)
static inline void rb_init(struct rb_root *rb)
{
	RB_INIT(*rb);
}

static inline void rb_link_node(struct rb_node *node,
				struct rb_node *parent,
				struct rb_node **pnode)
{
	__bstlink_init(node, parent, pnode);
	node->color = RB_COLOR_RED;
}

static inline struct rb_node *rb_first(const struct rb_root *rb)
{
	return __bstlink_first(rb->node, struct rb_node);
}

static inline struct rb_node *rb_last(const struct rb_root *rb)
{
	return __bstlink_last(rb->node, struct rb_node);
}

static inline struct rb_node *rb_next(const struct rb_node* node)
{
	return __bstlink_next(node, struct rb_node);
}

static inline struct rb_node *rb_prev(const struct rb_node* node)
{
	return __bstlink_prev(node, struct rb_node);
}

static inline struct rb_node *rb_find(const struct rb_root *rb,
				      int (*compare)(const struct rb_node *node,
						     const void *arg),
				      const void *arg)
{
	return __bstlink_find(rb->node, compare, arg, struct rb_node);
}

static inline struct rb_node *rb_lower_bound(struct rb_root *rb,
					     int (*compare)(
						  const struct rb_node *node,
						  const void *arg),
					     const void *arg)
{
	return __bstlink_lower_bound(rb->node, compare, arg, struct rb_node);
}

static inline struct rb_node *rb_upper_bound(struct rb_root *rb,
					     int (*compare)(
						  const struct rb_node *node,
						  const void *arg),
					     const void *arg)
{
	return __bstlink_upper_bound(rb->node, compare, arg, struct rb_node);
}

static inline void rb_lower_upper_bound(struct rb_root *rb,
					int (*compare)(const struct rb_node *node,
						       const void *arg),
					const void *arg,
					struct rb_node **plower,
					struct rb_node **pupper)
{
	__bstlink_lower_upper_bound(rb->node, compare, arg, plower, pupper);
}

void rb_insert(struct rb_node *node,
	       struct rb_root *rb,
	       int (*compare_link)(const struct rb_node *node1,
				   const struct rb_node *node2,
				   const void *arg),
	       const void *arg);
bool rb_insert_unique(struct rb_node *node,
	       struct rb_root *rb,
	       int (*compare_link)(const struct rb_node *node1,
				   const struct rb_node *node2,
				   const void *arg),
	       const void *arg);
void rb_insert_color(struct rb_node *node, struct rb_root *rb);

void rb_erase(struct rb_node *node, struct rb_root *rb);
void rb_erase_range(struct rb_node *beg, struct rb_node *end, struct rb_root *rb);
void rb_erase_equal(struct rb_root *rb,
		    int (*compare)(const struct rb_node *node, const void *arg),
		    void (*destroy)(struct rb_node *node, const void *arg),
		    const void *arg_compare,
		    const void *arg_destroy);

static inline void rb_clear(struct rb_root *rb,
			    void (*destroy)(struct rb_node *node,
					    const void *arg),
			    const void *arg)
{
	__bstlink_destroy(rb->node, destroy, arg);
	rb_init(rb);	/* re-init */
}

struct rb_root *rb_alloc(size_t num);
void rb_free(struct rb_root *rb,
	     size_t num,
	     void (*destroy)(struct rb_node *rb, const void *arg),
	     const void *arg);

bool rb_clone(struct rb_root *rb,
	      const struct rb_root *rb_src,
	      struct rb_node *(*node_clone)(const struct rb_node *node,
					    const void *arg),
	      void (*node_destroy)(struct rb_node *node, const void *arg),
	      const void *arg_clone,
	      const void *arg_destroy);

/* clone range: [beg, end) */
bool rb_clone_range(struct rb_root *rb,
		    const struct rb_node *beg,
		    const struct rb_node *end,
		    struct rb_node *(*node_clone)(const struct rb_node *node,
						  const void *arg),
		    void (*node_destroy)(struct rb_node *node, const void *arg),
		    const void *arg_clone,
		    const void *arg_destroy);

void rb_swap(struct rb_root *rb1, struct rb_root *rb2);

#define rb_color(r)	((r)->color)
#define rb_is_red(r)	(!rb_color(r))
#define rb_is_black(r)	rb_color(r)
#define rb_set_color(r, val)	do { (r)->color = (val); } while(0)
#define rb_set_red(r)	rb_set_color((r), RB_COLOR_RED)
#define rb_set_black(r)	rb_set_color((r), RB_COLOR_BLACK)

static inline size_t rb_depth_max(const struct rb_root *rb)
{
	return __bstlink_depth_max(rb->node);
}

static inline size_t rb_depth_min(const struct rb_root *rb)
{
	return __bstlink_depth_min(rb->node);
}

__END_DECLS

#endif /* __YC_ALGOS_RBTREE_H_ */
