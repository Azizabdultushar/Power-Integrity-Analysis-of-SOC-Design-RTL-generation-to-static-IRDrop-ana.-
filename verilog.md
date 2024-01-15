https://acg.cis.upenn.edu/milom/cis371-Spring13/lab/textbook-verilog-tutorial/VOL/main.htm



# History
- Very first HDL is ISP.
- The first HDL was ISP, invented by C. Gordon Bell and Alan Newell at Carnegie Mellon University and described in their book Computer Structures in 1972.
- HiLo > Verilog and ISP > N dot simulator
-  first implemented by Phil Moorby at Gateway Design Automation in 1984 and 1985
-  acquired by Cadence and make it OpenSource for public



# Building block
- A verilog Model is composed of one or many modules
- Module is sometimes called instances child instances module composed of parent instance module

```mermaid
flowchart LR

A[Behaviral level] -->|RTL| B(Synthesizable)
B --> C{Top module}
C -->|One| D[Module 1] --> |Three| F[ sub sub module 1]
C -->|Two| E[Module 2]

