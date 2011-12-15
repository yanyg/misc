/*
  compiler-gcc.h: macro of compiler-gcc options

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

#ifndef __YC_COMPILER_GCC_H_
#define __YC_COMPILER_GCC_H_

#ifndef __aligned
#define __aligned(x)			__attribute__((aligned(x)))
#endif

#ifndef __always_inline
#define __always_inline		inline __attribute__((always_inline))
#endif

#endif /* __YC_COMPILER_H_ */
