/*
 * Types for IB Pseudocode
 *
 * Copyright (C) 2024  Runxi Yu <https://runxiyu.org>
 * SPDX-License-Identifier: AGPL-3.0-or-later
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#include <sys/types.h>
#include <stdbool.h>

enum ibpc_type_id {
	IBPC_TYPE_INTEGER,
	IBPC_TYPE_REAL,
	IBPC_TYPE_STRING,
	IBPC_TYPE_BOOLEAN,
	IBPC_TYPE_LIST,
};

typedef long long ibpc_type_integer;
typedef double ibpc_type_real;
struct ibpc_type_string {
	ssize_t cap;
	ssize_t size;
	char *data;
};
typedef bool ibpc_type_boolean;
// struct ibpc_type_list {
// 	struct ibpc_type_list *prev;
// 	struct ibpc_type_list *next;
// 	struct ibpc_value *data;
// }; // FIXME

union ibpc_type {
	ibpc_type_integer integer;
	ibpc_type_real real;
	struct ibpc_type_string string;
	ibpc_type_boolean boolean;
	// ibpc_type_list list;
};

struct ibpc_value {
	enum ibpc_type_id type;
	union ibpc_type value;
};
