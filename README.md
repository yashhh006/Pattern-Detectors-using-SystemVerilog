# Pattern-Detectors-using-SystemVerilog


This repository contains the RTL for a highly flexible **Finite State Machine (FSM)** designed to detect a specific serial pattern in a stream of input data.

The key feature of this design is that the pattern is **not hard-coded**. It's defined by a Verilog `parameter`, meaning you can change the pattern it looks for without ever modifying the logic of the state machine.

---

### How It Works

The module works by processing a single bit of `data` on every clock cycle when the `valid` signal is high.

* **Explicit State Machine**: I designed this using an explicit FSM, where each state represents a partial match of the pattern. For example, if the pattern is `10110`, there's a state for successfully detecting `1`, another for `10`, another for `101`, and so on.
* **State Transitions**: If the incoming bit matches the next bit in the pattern, the FSM advances to the next state. If it doesn't match, the FSM intelligently resets or moves to an earlier state based on any partial matches in the new data.
* **Detection Flag**: Once the full pattern is successfully received, the `detect` output flag is raised for one clock cycle.

* **Implicit State Machine**: I designed this using an implicit FSM, where a internal register store the pattern from the parameter and checks directly to the inputs given by the testbench to check if both the pattern matches or not.

---

### Key Features

* **Fully Parameterized Pattern**: The `pattern` parameter can be changed at compile time to detect any 5-bit sequence you need.
* **Configurable Bit-Width**: The `num_bits` parameter allows for easy scaling of the design to detect patterns of different lengths in the future.
* **Overlap vs. Non-Overlap Detection**: The module can be configured at simulation time (using the `testcase` plusarg) to handle two different detection modes:
    * **`nonoverlap`**: Resets the FSM completely after a full pattern is found.
    * **`overlap`**: Allows the end of one pattern to be the start of a new one. For example, in the sequence `10101`, it can detect two instances of `101`.

---

### How It Was Tested

The RTL was verified using a straightforward **directed testbench**. This testbench module drives the `clk`, `rstn`, `data`, and `valid` inputs to the detector and monitors the `detect` output to ensure it behaves as expected for various input streams, including both matching and non-matching sequences.
