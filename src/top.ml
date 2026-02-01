open! Core
open Hardcaml
open Signal
open Utils

module I = struct
  type 'a t =
    { clock : 'a
    ; reset_n : 'a
    ; _crs_dv : 'a
    ; _rx_err : 'a
    ; _rx_d : 'a [@bits 2]
    }
  [@@deriving hardcaml]
end

module O = struct
  type 'a t =
    { clock_50MHz : 'a
    ; phy_reset_n : 'a
    ; tx_en : 'a
    ; tx_d : 'a [@bits 2]
    ; anode_n : 'a [@bits 8]
    ; seg : 'a [@bits 7]
    ; dp : 'a
    }
  [@@deriving hardcaml]
end

let create scope ({ clock; reset_n; _crs_dv; _rx_err; _rx_d } : _ I.t) : _ O.t =
  (* Instantiate Clocking Wizard IP Core *)
  let clocking_wizard_50MHz =
    Instantiation.create
      ~name:"clocking_wizard_50MHz"
      ~inputs:[ "clock_in", clock; "resetn", reset_n ]
      ~outputs:[ "clock_50MHz", 1 ]
      ()
  in
  let clock_50MHz = Instantiation.output clocking_wizard_50MHz "clock_50MHz" in
  (* Ethernet MAC *)
  let eth_mac = Eth_mac.hierarchical scope { _clock_50MHz = clock_50MHz; reset_n; _crs_dv; _rx_d; _rx_err } in
  (* Set up 7-Segment Display *)
  let num_to_display = ones 32 in
  let display =
    Seven_segment_display.hierarchical scope { clock; reset_n; num = num_to_display }
  in
  { clock_50MHz = clock_50MHz
  ; phy_reset_n = reset_n
  ; tx_en = eth_mac.tx_en
  ; tx_d = eth_mac.tx_d
  ; anode_n = display.anode_n
  ; seg = display.seg
  ; dp = display.dp
  }
;;

let hierarchical scope =
  let module Scoped = Hierarchy.In_scope (I) (O) in
  Scoped.hierarchical ~scope ~name:"fpga_udp_ip" create
;;
