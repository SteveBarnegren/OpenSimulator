# OpenSimulator
Swift script to open the iOS simulator's currently open application's container.

### Usage

1. Clone repo and put OpenSimulator.swift somewhere
2. Terminal
3. ```.../OpenSimulator.swift```

### How it works

The script looks through the simulator directories, and uses the 'Modification Date' attribute to determine which of the simulators was the most recently used.

It then does the same to determine the most recently used application.

This means that the wrong directory can be opened if your application does not write to disk on each run.