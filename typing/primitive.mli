(***********************************************************************)
(*                                                                     *)
(*                                OCaml                                *)
(*                                                                     *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1996 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the Q Public License version 1.0.               *)
(*                                                                     *)
(***********************************************************************)

(* Description of primitive functions *)

type 'a description =
  { prim_name: string;         (* Name of primitive  or C function *)
    prim_arity: int;           (* Number of arguments *)
    prim_alloc: bool;          (* Does it allocates or raise? *)
    prim_native_name: string;  (* Name of C function for the nat. code gen. *)
    prim_native_float: bool;
    prim_attributes: Parsetree.attributes;
    prim_ty : 'a
  }  (* Does the above operate on unboxed floats? *)

val parse_declaration: 'a -> Parsetree.attributes -> int -> string list -> 'a description

val description_list: 'a description -> string list

val native_name: 'a description -> string
val byte_name: 'a description -> string
