(*
 * Copyright (c) 2010-2012,
 *  Jinseong Jeon <jsjeon@cs.umd.edu>
 *  Kris Micinski <micinski@cs.umd.edu>
 *  Jeff Foster   <jfoster@cs.umd.edu>
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * 3. The names of the contributors may not be used to endorse or promote
 * products derived from this software without specific prior written
 * permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *)

(***********************************************************************)
(* Instr                                                               *)
(***********************************************************************)

(** This module defines types for Dalvik bytecodes and provides utility
 functions for generating, parsing and dumping instructions. *)

(** {2 Types} *)

(** An address space of DEX is 32-bits *)
type offset = int32

(** The data pool is a mapping from 32-bit offset to {!Dex.data_item}. *)
module IM : Map.S with type key = Int32.t
(** All other modules after this module will use this declaration. *)

(** An instruction is composed of {!opcode} and a [list] of {!operand}s. *)
type instr  = opcode * operand list

(** Operand for {!instr} *)
and operand =
  | OPR_CONST    of int64  (** constant *)
  | OPR_REGISTER of int    (** register *)
  | OPR_INDEX    of int    (** index *)
  | OPR_OFFSET   of offset (** offset *)

(** Dalvik Instruction Set, used at {!instr} *)
and opcode  =
  | OP_NOP                        (** 0x00 *)

  | OP_MOVE                       (** 0x01 *)
  | OP_MOVE_FROM16                (** 0x02 *)
  | OP_MOVE_16                    (** 0x03 *)
  | OP_MOVE_WIDE                  (** 0x04 *)
  | OP_MOVE_WIDE_FROM16           (** 0x05 *)
  | OP_MOVE_WIDE_16               (** 0x06 *)
  | OP_MOVE_OBJECT                (** 0x07 *)
  | OP_MOVE_OBJECT_FROM16         (** 0x08 *)
  | OP_MOVE_OBJECT_16             (** 0x09 *)

  | OP_MOVE_RESULT                (** 0x0a *)
  | OP_MOVE_RESULT_WIDE           (** 0x0b *)
  | OP_MOVE_RESULT_OBJECT         (** 0x0c *)
  | OP_MOVE_EXCEPTION             (** 0x0d *)

  | OP_RETURN_VOID                (** 0x0e *)
  | OP_RETURN                     (** 0x0f *)
  | OP_RETURN_WIDE                (** 0x10 *)
  | OP_RETURN_OBJECT              (** 0x11 *)

  | OP_CONST_4                    (** 0x12 *)
  | OP_CONST_16                   (** 0x13 *)
  | OP_CONST                      (** 0x14 *)
  | OP_CONST_HIGH16               (** 0x15 *)
  | OP_CONST_WIDE_16              (** 0x16 *)
  | OP_CONST_WIDE_32              (** 0x17 *)
  | OP_CONST_WIDE                 (** 0x18 *)
  | OP_CONST_WIDE_HIGH16          (** 0x19 *)
  | OP_CONST_STRING               (** 0x1a *)
  | OP_CONST_STRING_JUMBO         (** 0x1b *)
  | OP_CONST_CLASS                (** 0x1c *)

  | OP_MONITOR_ENTER              (** 0x1d *)
  | OP_MONITOR_EXIT               (** 0x1e *)

  | OP_CHECK_CAST                 (** 0x1f *)
  | OP_INSTANCE_OF                (** 0x20 *)

  | OP_ARRAY_LENGTH               (** 0x21 *)

  | OP_NEW_INSTANCE               (** 0x22 *)
  | OP_NEW_ARRAY                  (** 0x23 *)

  | OP_FILLED_NEW_ARRAY           (** 0x24 *)
  | OP_FILLED_NEW_ARRAY_RANGE     (** 0x25 *)
  | OP_FILL_ARRAY_DATA            (** 0x26 *)
    
  | OP_THROW                      (** 0x27 *)
  | OP_GOTO                       (** 0x28 *)
  | OP_GOTO_16                    (** 0x29 *)
  | OP_GOTO_32                    (** 0x2a *)
  | OP_PACKED_SWITCH              (** 0x2b *)
  | OP_SPARSE_SWITCH              (** 0x2c *)
    
  | OP_CMPL_FLOAT                 (** 0x2d *)
  | OP_CMPG_FLOAT                 (** 0x2e *)
  | OP_CMPL_DOUBLE                (** 0x2f *)
  | OP_CMPG_DOUBLE                (** 0x30 *)
  | OP_CMP_LONG                   (** 0x31 *)

  | OP_IF_EQ                      (** 0x32 *)
  | OP_IF_NE                      (** 0x33 *)
  | OP_IF_LT                      (** 0x34 *)
  | OP_IF_GE                      (** 0x35 *)
  | OP_IF_GT                      (** 0x36 *)
  | OP_IF_LE                      (** 0x37 *)
  | OP_IF_EQZ                     (** 0x38 *)
  | OP_IF_NEZ                     (** 0x39 *)
  | OP_IF_LTZ                     (** 0x3a *)
  | OP_IF_GEZ                     (** 0x3b *)
  | OP_IF_GTZ                     (** 0x3c *)
  | OP_IF_LEZ                     (** 0x3d *)

  | OP_AGET                       (** 0x44 *)
  | OP_AGET_WIDE                  (** 0x45 *)
  | OP_AGET_OBJECT                (** 0x46 *)
  | OP_AGET_BOOLEAN               (** 0x47 *)
  | OP_AGET_BYTE                  (** 0x48 *)
  | OP_AGET_CHAR                  (** 0x49 *)
  | OP_AGET_SHORT                 (** 0x4a *)
  | OP_APUT                       (** 0x4b *)
  | OP_APUT_WIDE                  (** 0x4c *)
  | OP_APUT_OBJECT                (** 0x4d *)
  | OP_APUT_BOOLEAN               (** 0x4e *)
  | OP_APUT_BYTE                  (** 0x4f *)
  | OP_APUT_CHAR                  (** 0x50 *)
  | OP_APUT_SHORT                 (** 0x51 *)

  | OP_IGET                       (** 0x52 *)
  | OP_IGET_WIDE                  (** 0x53 *)
  | OP_IGET_OBJECT                (** 0x54 *)
  | OP_IGET_BOOLEAN               (** 0x55 *)
  | OP_IGET_BYTE                  (** 0x56 *)
  | OP_IGET_CHAR                  (** 0x57 *)
  | OP_IGET_SHORT                 (** 0x58 *)
  | OP_IPUT                       (** 0x59 *)
  | OP_IPUT_WIDE                  (** 0x5a *)
  | OP_IPUT_OBJECT                (** 0x5b *)
  | OP_IPUT_BOOLEAN               (** 0x5c *)
  | OP_IPUT_BYTE                  (** 0x5d *)
  | OP_IPUT_CHAR                  (** 0x5e *)
  | OP_IPUT_SHORT                 (** 0x5f *)

  | OP_SGET                       (** 0x60 *)
  | OP_SGET_WIDE                  (** 0x61 *)
  | OP_SGET_OBJECT                (** 0x62 *)
  | OP_SGET_BOOLEAN               (** 0x63 *)
  | OP_SGET_BYTE                  (** 0x64 *)
  | OP_SGET_CHAR                  (** 0x65 *)
  | OP_SGET_SHORT                 (** 0x66 *)
  | OP_SPUT                       (** 0x67 *)
  | OP_SPUT_WIDE                  (** 0x68 *)
  | OP_SPUT_OBJECT                (** 0x69 *)
  | OP_SPUT_BOOLEAN               (** 0x6a *)
  | OP_SPUT_BYTE                  (** 0x6b *)
  | OP_SPUT_CHAR                  (** 0x6c *)
  | OP_SPUT_SHORT                 (** 0x6d *)

  | OP_INVOKE_VIRTUAL             (** 0x6e *)
  | OP_INVOKE_SUPER               (** 0x6f *)
  | OP_INVOKE_DIRECT              (** 0x70 *)
  | OP_INVOKE_STATIC              (** 0x71 *)
  | OP_INVOKE_INTERFACE           (** 0x72 *)

  | OP_INVOKE_VIRTUAL_RANGE       (** 0x74 *)
  | OP_INVOKE_SUPER_RANGE         (** 0x75 *)
  | OP_INVOKE_DIRECT_RANGE        (** 0x76 *)
  | OP_INVOKE_STATIC_RANGE        (** 0x77 *)
  | OP_INVOKE_INTERFACE_RANGE     (** 0x78 *)

  | OP_NEG_INT                    (** 0x7b *)
  | OP_NOT_INT                    (** 0x7c *)
  | OP_NEG_LONG                   (** 0x7d *)
  | OP_NOT_LONG                   (** 0x7e *)
  | OP_NEG_FLOAT                  (** 0x7f *)
  | OP_NEG_DOUBLE                 (** 0x80 *)
  | OP_INT_TO_LONG                (** 0x81 *)
  | OP_INT_TO_FLOAT               (** 0x82 *)
  | OP_INT_TO_DOUBLE              (** 0x83 *)
  | OP_LONG_TO_INT                (** 0x84 *)
  | OP_LONG_TO_FLOAT              (** 0x85 *)
  | OP_LONG_TO_DOUBLE             (** 0x86 *)
  | OP_FLOAT_TO_INT               (** 0x87 *)
  | OP_FLOAT_TO_LONG              (** 0x88 *)
  | OP_FLOAT_TO_DOUBLE            (** 0x89 *)
  | OP_DOUBLE_TO_INT              (** 0x8a *)
  | OP_DOUBLE_TO_LONG             (** 0x8b *)
  | OP_DOUBLE_TO_FLOAT            (** 0x8c *)
  | OP_INT_TO_BYTE                (** 0x8d *)
  | OP_INT_TO_CHAR                (** 0x8e *)
  | OP_INT_TO_SHORT               (** 0x8f *)

  | OP_ADD_INT                    (** 0x90 *)
  | OP_SUB_INT                    (** 0x91 *)
  | OP_MUL_INT                    (** 0x92 *)
  | OP_DIV_INT                    (** 0x93 *)
  | OP_REM_INT                    (** 0x94 *)
  | OP_AND_INT                    (** 0x95 *)
  | OP_OR_INT                     (** 0x96 *)
  | OP_XOR_INT                    (** 0x97 *)
  | OP_SHL_INT                    (** 0x98 *)
  | OP_SHR_INT                    (** 0x99 *)
  | OP_USHR_INT                   (** 0x9a *)

  | OP_ADD_LONG                   (** 0x9b *)
  | OP_SUB_LONG                   (** 0x9c *)
  | OP_MUL_LONG                   (** 0x9d *)
  | OP_DIV_LONG                   (** 0x9e *)
  | OP_REM_LONG                   (** 0x9f *)
  | OP_AND_LONG                   (** 0xa0 *)
  | OP_OR_LONG                    (** 0xa1 *)
  | OP_XOR_LONG                   (** 0xa2 *)
  | OP_SHL_LONG                   (** 0xa3 *)
  | OP_SHR_LONG                   (** 0xa4 *)
  | OP_USHR_LONG                  (** 0xa5 *)

  | OP_ADD_FLOAT                  (** 0xa6 *)
  | OP_SUB_FLOAT                  (** 0xa7 *)
  | OP_MUL_FLOAT                  (** 0xa8 *)
  | OP_DIV_FLOAT                  (** 0xa9 *)
  | OP_REM_FLOAT                  (** 0xaa *)
  | OP_ADD_DOUBLE                 (** 0xab *)
  | OP_SUB_DOUBLE                 (** 0xac *)
  | OP_MUL_DOUBLE                 (** 0xad *)
  | OP_DIV_DOUBLE                 (** 0xae *)
  | OP_REM_DOUBLE                 (** 0xaf *)

  | OP_ADD_INT_2ADDR              (** 0xb0 *)
  | OP_SUB_INT_2ADDR              (** 0xb1 *)
  | OP_MUL_INT_2ADDR              (** 0xb2 *)
  | OP_DIV_INT_2ADDR              (** 0xb3 *)
  | OP_REM_INT_2ADDR              (** 0xb4 *)
  | OP_AND_INT_2ADDR              (** 0xb5 *)
  | OP_OR_INT_2ADDR               (** 0xb6 *)
  | OP_XOR_INT_2ADDR              (** 0xb7 *)
  | OP_SHL_INT_2ADDR              (** 0xb8 *)
  | OP_SHR_INT_2ADDR              (** 0xb9 *)
  | OP_USHR_INT_2ADDR             (** 0xba *)

  | OP_ADD_LONG_2ADDR             (** 0xbb *)
  | OP_SUB_LONG_2ADDR             (** 0xbc *)
  | OP_MUL_LONG_2ADDR             (** 0xbd *)
  | OP_DIV_LONG_2ADDR             (** 0xbe *)
  | OP_REM_LONG_2ADDR             (** 0xbf *)
  | OP_AND_LONG_2ADDR             (** 0xc0 *)
  | OP_OR_LONG_2ADDR              (** 0xc1 *)
  | OP_XOR_LONG_2ADDR             (** 0xc2 *)
  | OP_SHL_LONG_2ADDR             (** 0xc3 *)
  | OP_SHR_LONG_2ADDR             (** 0xc4 *)
  | OP_USHR_LONG_2ADDR            (** 0xc5 *)

  | OP_ADD_FLOAT_2ADDR            (** 0xc6 *)
  | OP_SUB_FLOAT_2ADDR            (** 0xc7 *)
  | OP_MUL_FLOAT_2ADDR            (** 0xc8 *)
  | OP_DIV_FLOAT_2ADDR            (** 0xc9 *)
  | OP_REM_FLOAT_2ADDR            (** 0xca *)
  | OP_ADD_DOUBLE_2ADDR           (** 0xcb *)
  | OP_SUB_DOUBLE_2ADDR           (** 0xcc *)
  | OP_MUL_DOUBLE_2ADDR           (** 0xcd *)
  | OP_DIV_DOUBLE_2ADDR           (** 0xce *)
  | OP_REM_DOUBLE_2ADDR           (** 0xcf *)

  | OP_ADD_INT_LIT16              (** 0xd0 *)
  | OP_RSUB_INT                   (** 0xd1 *) (* no _LIT16 suffix for this *)
  | OP_MUL_INT_LIT16              (** 0xd2 *)
  | OP_DIV_INT_LIT16              (** 0xd3 *)
  | OP_REM_INT_LIT16              (** 0xd4 *)
  | OP_AND_INT_LIT16              (** 0xd5 *)
  | OP_OR_INT_LIT16               (** 0xd6 *)
  | OP_XOR_INT_LIT16              (** 0xd7 *)

  | OP_ADD_INT_LIT8               (** 0xd8 *)
  | OP_RSUB_INT_LIT8              (** 0xd9 *)
  | OP_MUL_INT_LIT8               (** 0xda *)
  | OP_DIV_INT_LIT8               (** 0xdb *)
  | OP_REM_INT_LIT8               (** 0xdc *)
  | OP_AND_INT_LIT8               (** 0xdd *)
  | OP_OR_INT_LIT8                (** 0xde *)
  | OP_XOR_INT_LIT8               (** 0xdf *)
  | OP_SHL_INT_LIT8               (** 0xe0 *)
  | OP_SHR_INT_LIT8               (** 0xe1 *)
  | OP_USHR_INT_LIT8              (** 0xe2 *)

(** {2 Utilities} *)

(** {!instr} to [string] *)
val instr_to_string : instr -> string

(** {!operand} to [string] *)
val opr_to_string : operand -> string

(** {!opcode} to [string] *)
val op_to_string : opcode -> string

(** hex to {!opcode} and size *)
val hx_to_op_and_size : int -> opcode * int

(** hex to {!opcode} *)
val hx_to_op : int -> opcode

(** {!opcode} to hex and size *)
val op_to_hx_and_size : opcode -> int * int

(** {!opcode} to hex *)
val op_to_hx : opcode -> int

(** sort of links in the [dex] *)
type link_sort =
  | STRING_IDS
  | TYPE_IDS
  | FIELD_IDS
  | METHOD_IDS
  | OFFSET
  | NOT_LINK

(** which {!link_sort} does this {!opcode} access to? *)
val access_link : opcode -> link_sort

(** number of "low" registers, registers numbers higher 
 than this must be moved to a low register before they 
 can be used for some instructions.
 Or, use *_RANGE invoke instructions *)
val low_reg : opcode -> int

(** retrieve actual parameters,
 e.g. for [invoke-*/range v0 v2 @...], return a list of v0, v1, and v2 *)
val get_argv : instr -> operand list

(** {2 Parsing and Dumping} *)

(** build {!instr} using {!opcode} and a [list] of arguments *)
val make_instr : opcode -> int list -> instr

(** according to given base address, translate {!instr} to bytes *)
val instr_to_bytes : int -> instr -> char list

(** {2 Generating} *)

(** for given a register number and constant,
 generate [OP_CONST]-kind {!instr} *)
val new_const : int -> int -> instr

(** for given register number and string or class id,
 generate [OP_CONST]-kind {!instr} *)
val new_const_id : int -> int -> int -> instr

(** for a given source and destination register,
 generate a new [OP_MOVE]-kind {!instr} *)
val new_move : int -> int -> int -> instr

(** for a given destination register and type,
 generate a new [OP_NEW_INSTANCE] {!instr} *)
val new_obj : int -> int -> instr

(** for a given destination register, size, and type,
 generate a new [OP_NEW_ARRAY] {!instr} *)
val new_arr : int -> int -> int -> instr

(** for a given {!offset},
 generate a new [OP_GOTO]-kind {!instr} *)
val new_goto : int -> offset -> instr

(** for the given test registers and {!offset},
 generate a new [OP_IF]-kind {!instr} *)
val new_if : int -> int -> int -> offset -> instr

(** for a given value, array, index registers,
 generate a new [OP_A(GET|PUT)]-kind {!instr} *)
val new_arr_op : int -> int list -> instr

(** for the given binary op and registers,
 generate a new binary operation {!instr} *)
val new_bin_op : int -> int list -> instr

(** for given registers and instance field id,
 generate [OP_I(GET|PUT)]-kind {!instr} *)
val new_ist_fld : int -> int -> int -> int -> instr

(** for given register number and static field id,
 generate [OP_S(GET|PUT)]-kind {!instr} *)
val new_stt_fld : int -> int -> int -> instr

(** for given hex code and a [list] of arguments,
 generate [OP_INVOKE]-kind {!instr} *)
val new_invoke : int -> int list -> instr

(** for given hex code and register number,
 generate [OP_MOVE_RESULT]-kind {!instr} *)
val new_move_result : int -> int -> instr

(** for given hex code and an [option] of register,
 generate [OP_RETURN]-kind {!instr} *)
val new_return : int -> int option -> instr

(** void return *)
val rv : instr

