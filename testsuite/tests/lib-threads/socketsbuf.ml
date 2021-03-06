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

open Printf

(* Threads, sockets, and buffered I/O channels *)
(* Serves as a regression test for PR#5578 *)

let serve_connection s =
  let ic = Unix.in_channel_of_descr s
  and oc = Unix.out_channel_of_descr s in
  let l = input_line ic in
  fprintf oc ">>%s\n" l;
  close_out oc

let server sock =
  while true do
    let (s, _) = Unix.accept sock in
    ignore(Thread.create serve_connection s)
  done

let client (addr, msg) =
  let sock =
    Unix.socket (Unix.domain_of_sockaddr addr) Unix.SOCK_STREAM 0 in
  Unix.connect sock addr;
  let ic = Unix.in_channel_of_descr sock
  and oc = Unix.out_channel_of_descr sock in
  output_string oc msg; flush oc;
  let l = input_line ic in
  printf "%s\n%!" l

let _ =
  let addr = Unix.ADDR_INET(Unix.inet_addr_loopback, 9876) in
  let sock =
    Unix.socket (Unix.domain_of_sockaddr addr) Unix.SOCK_STREAM 0 in
  Unix.setsockopt sock Unix.SO_REUSEADDR true;
  Unix.bind sock addr;
  Unix.listen sock 5;
  ignore (Thread.create server sock);
  ignore (Thread.create client (addr, "Client #1\n"));
  Thread.delay 0.5;
  client (addr, "Client #2\n")


  
