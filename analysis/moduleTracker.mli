(** Copyright (c) 2019-present, Facebook, Inc.

    This source code is licensed under the MIT license found in the LICENSE file in the root
    directory of this source tree. *)

open Pyre

module IncrementalUpdate : sig
  type t =
    | NewExplicit of Ast.SourcePath.t
    | NewImplicit of Ast.Reference.t
    | Delete of Ast.Reference.t
  [@@deriving sexp, compare, eq]
end

module Lookup : sig
  type t =
    | Explicit of Ast.SourcePath.t
    | Implicit of Ast.Reference.t
  [@@deriving sexp, compare, eq]
end

type t

val create : Configuration.Analysis.t -> t

val lookup : t -> Ast.Reference.t -> Lookup.t option

val lookup_source_path : t -> Ast.Reference.t -> Ast.SourcePath.t option

val lookup_path : configuration:Configuration.Analysis.t -> t -> Path.t -> Ast.SourcePath.t option

val source_paths : t -> Ast.SourcePath.t list

(* This function returns all SourcePaths that are tracked, including the shadowed ones *)
val all_source_paths : t -> Ast.SourcePath.t list

(* This function returns all explicit modules (i.e. those backed up by a source path) that are
   tracked *)
val tracked_explicit_modules : t -> Ast.Reference.t list

val is_module_tracked : t -> Ast.Reference.t -> bool

val explicit_module_count : t -> int

val update
  :  configuration:Configuration.Analysis.t ->
  paths:Path.t list ->
  t ->
  IncrementalUpdate.t list

module SharedMemory : sig
  val store : t -> unit

  val load : unit -> t
end
