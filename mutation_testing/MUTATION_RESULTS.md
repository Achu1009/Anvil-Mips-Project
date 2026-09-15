# Mutation Testing Results

Ten deliberately broken variants of the SV baseline pipeline, each containing a single realistic edit.
Reproduce with: `python3 run_mutants.py --golden <path-to-src>`

Simulator: Verilator 5.020 (`--binary --timing --assert`). 

---

## Results

| | Mutation | Killed by SVA | Killed end-to-end (P11) |
|---|---|---|---|
| **M1** | Forwarding priority inverted (MEM/WB checked before EX/MEM for operand A) | P15, P6, P33 | yes |
| **M2** | `!= 5'd0` guard dropped on the EX/MEM &rarr; A forwarding path | **P24** | **no** |
| **M3** | Load-use detection compares `id_ex.rd` instead of `id_ex.rt` | P1, P29, P33 | yes |
| **M4** | IF/ID flush on a taken branch removed | **P8** | **no** |
| **M5** | ID/EX bubble on a taken branch removed | P8 | yes |
| **M6** | PC not frozen during a load-use stall | P1b, P4 | yes |
| **M7** | `$zero` hardwire writes `write_data` instead of zero | **P31** | **no** |
| **M8** | Forward-A mux arm wired to the wrong stage (select stays correct) | **P33** | yes |
| **M9** | Branch target off by one word | **&mdash; survived &mdash;** | yes |
| **M10** | Over-stall: stall after every load, dependency or not | **P1** | yes |

---


**The checks are complementary, not redundant:** Mutants M2, M4, and M7 are completely invisible to the end-to-end equivalence checker, but caught by SVA. Conversely, M9 (bad branch math) is invisible to SVA, but caught end-to-end. You need both to fully secure the pipeline.
