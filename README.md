# 🎵 FPGA Retro Music Box

A standalone, rechargeable digital melody generator implemented in **Verilog HDL** on the **Sipeed Tang Nano 9K** (Gowin GW1NR-9 FPGA).

## ⚙️ Hardware & Tools
* **FPGA Board:** Sipeed Tang Nano 9K (Gowin GW1NR-9)
* **HDL & IDE:** Verilog, Gowin EDA
* **Peripherals:** Passive Piezo Buzzer, Slide Switch
* **Power & Battery Management:** 3.7V LiPo Battery, TP4056 Li-Ion Charge & Protection Module, 5V DC-DC Boost Converter (Step-Up)

## 🧠 Architecture Overview
* **Clock Division & Frequency Synthesis:** Uses custom counter-based frequency dividers to step down the 27 MHz onboard crystal oscillator into precise musical note frequencies via square-wave synthesis.
* **Melody Sequencer:** Stores note sequences and durations in synchronous LUT/ROM structures, advancing automatically via a tempo control counter.
* **Standalone Portable Power Stage:** Engineered with a 3.7V LiPo battery managed by a TP4056 charging/protection circuit, stepped up to a regulated 5V rail via a DC-DC boost converter, and controlled by a physical slide switch.

## 📂 Repository Structure
* `src/` - Verilog RTL design files (`.v`) and physical pin constraints (`.cst`)
* `retro_music_box.gprj` - Gowin EDA project configuration file
