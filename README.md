# Single Port RAM — UVM-Style SystemVerilog Verification

A self-checking, constrained-random testbench built in SystemVerilog to verify a synchronous single-port RAM design (32 x 8-bit, 50 MHz).

## Design Under Verification

The RAM is a single-port, fully synchronous memory with one shared address bus for both read and write access. Because there's only one address port, read and write operations cannot be issued in the same cycle — this constraint shapes both the RTL and the verification strategy.

| Pin | Direction | Width | Description |
|---|---|---|---|
| `clk` | Input | 1 | Clock |
| `reset` | Input | 1 | Active-low reset |
| `write_enb` | Input | 1 | Active-high write enable |
| `read_enb` | Input | 1 | Active-high read enable |
| `data_in` | Input | 8 | Write data |
| `address` | Input | 5 | Memory location (0–31) |
| `data_out` | Output | 8 | Read data |

**Behavior summary**
- **Reset**: forces the RAM to idle — `data_in`/`data_out` go high-impedance (`Z`).
- **Write** (`write_enb=1, read_enb=0`): stores `data_in` at `address`. Invalid address → operation ignored, memory unchanged.
- **Read** (`write_enb=0, read_enb=1`): drives `data_out` from `address`. Invalid address → `data_out` goes to `Z`.
- **Illegal / simultaneous** (`write_enb=1, read_enb=1`): unsupported. Memory must not update and `data_out` must go high-impedance — checked directly via a bound SVA assertion.

## Testbench Architecture

Modular, layered, mailbox-connected components running concurrently:

```
generator --[mailbox]--> driver --[mailbox]--> scoreboard (golden model + compare)
                            |                          ^
                            v                          |
                           DUV -------> monitor --[mailbox]---+
```

| File | Component | Role |
|---|---|---|
| `ram_if.sv` | Interface | Physical DUV connection; separate `DRV`/`MON` clocking blocks and modports |
| `ram_transaction.sv` | Transaction | Randomizable stimulus (`write_enb`, `read_enb`, `address`, `data_in`); constraints map operation type to enable combinations |
| `ram_generator.sv` | Generator | Abstract base + `full_random_gen` — produces constrained-random transactions |
| `ram_driver.sv` | Driver | Drives the DUV via `drv_cb`; samples functional coverage (address, operation combinations, cross) |
| `ram_monitor.sv` | Monitor | Passively samples DUV outputs via `mon_cb`; no influence on DUV behavior |
| `ram_scoreboard.sv` | Reference model + Scoreboard | Maintains golden memory, predicts expected output, compares against monitor's observed data, tallies matches/mismatches |
| `ram_env.sv` | Environment | Wires up mailboxes/components, runs everything concurrently |
| `test_ram.sv` | Test | Configures environment, reports final pass/fail summary |
| `ram_assertions.sv` | Assertions | Bound directly to RTL — checks reset holds memory, and illegal read+write forces `data_out` to `Z` |
| `ram_package.sv` | Package | Bundles all classes for import |
| `top_ram.sv` | Top | Clock/reset generation, DUV + interface instantiation, assertion binding, test invocation |

## Verification Plan

| Combination | write_enb / read_enb | Bin Type | Purpose |
|---|---|---|---|
| Idle | `00` | `ignore_bin` | Legal no-op, excluded from coverage goal |
| Read | `01` | Normal | Verify read returns correct stored value |
| Write | `10` | Normal | Verify write stores correct value at address |
| Simultaneous | `11` | `illegal_bin` | Confirm design correctly rejects concurrent access |

Additional targeted tests: reset behavior, write-then-read, overwrite, boundary addresses (0/31), invalid-address truncation, read-from-never-written address, and full toggle coverage (every signal bit driven 1→0→1).

## Coverage Results

| Coverage Type | Result |
|---|---|
| DUV statements / branches / FEC conditions / toggles | 100% |
| Testbench components (transaction, generator, monitor, scoreboard) | 100% |
| Functional covergroups (address, data, operation cross) | 100% |
| Overall testbench + DUV coverage | 97.76% |

## Running

```bash
vlog top_ram.sv
vsim -c top -cover -do "run -all; exit"
vcover report -details vsim.ucdb
```
