#IB topology

`ib_topology/run.rb`

Runs an `iblinkinfo` command and parses the output to generate an output file or files in a number of different possible formats. For now, that means editing `run.rb` to select the output format.

##Class documentation
  http://nesi.github.io/pan_ib_topology

Note that iblinkinfo_parser_.rb has switch and node name configuration data, tagged with rack location, so that parser can associate iblinkinfo output with the nodes and switches. Much of this is produced programmatically, by knowing the naming convention that maps node names to specific racks.

##Men at Work

We can produce a 
* Slurm topology file
* Confluence Wiki table showing the switches, with node names in table cells for each switch port
* Excel XML file showing the switches, with node names in table cells for each switch port
* Excel TSV file showing the switches, with node names in table cells for each switch port
* YML file, with switches, ports and nodes
* Dot file, showing the switches and links between them (which quickly becomes a mass of indistinguishable links ;( )
    
Looking for a nice way to represent the network pictorially, which isn't as cluttered as the dot file.

