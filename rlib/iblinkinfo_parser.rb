require 'scanf'
require 'pp'

#Parse IBLinkinfo output.
#Knowledge of the IB Switches is needed, and the compute nodes, so names can be associated with the iblinkinfo output.
class IBLinkInfo
  attr_reader :switch_location, :switches, :switch_lids, :location
  
  def initialize(file_name, command=false)
    @file_name = file_name
    if(@run_command = command) == true
      @command = file_name
    else
      @filename = file_name
    end
    
    
    #a = "           4    1[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>       3   18[  ] \"MF0;ib0-is5200-a2-bip-m:IS5200/L07/U1\" ( )"
    #a = '           1   35[  ] ==( 4X  5.0 Gbps Active/  LinkUp)==>       2    1[  ] "Voltaire 4036E IO ib0gw-a2-001-m" ( )'
         #12345678901234567890123456789012345678901234567890123456789012345678901234567 8901234567890123456789012345678901234 567890
         #         1         2         3         4         5         6         7          8         9        10        11         12

    #Switch name, Rack/U or Rack/U/module
    #This is a map to use to abbrieviate name, determine physical location, identify leaf, verses spine switches.
    #Ex-spine (external spine) is the core backbone, which also has some direct attached server nodes. 
    @location = {
        'MF0;ib0-is5200-a2-bip-m:IS5200/L01/U1' => ['C2/U5/L01', :leaf, 'IS5200/L01', '', 36],
        'MF0;ib0-is5200-a2-bip-m:IS5200/L03/U1' => ['C2/U5/L03', :leaf, 'IS5200/L03', '', 36],
        'MF0;ib0-is5200-a2-bip-m:IS5200/L05/U1' => ['C2/U5/L05', :leaf, 'IS5200/L05', '', 36],
        'MF0;ib0-is5200-a2-bip-m:IS5200/L07/U1' => ['C2/U5/L07', :leaf, 'IS5200/L07', '', 36],
        'MF0;ib0-is5200-a2-bip-m:IS5200/L09/U1' => ['C2/U5/L09', :leaf, 'IS5200/L09', '', 36],
        'MF0;ib0-is5200-a2-bip-m:IS5200/L11/U1' => ['C2/U5/L11', :leaf, 'IS5200/L11', '', 36],
        'MF0;ib0-is5200-a2-bip-m:IS5200/L02/U1' => ['C2/U5/L02', :leaf, 'IS5200/L02', '', 36],
        'MF0;ib0-is5200-a2-bip-m:IS5200/L04/U1' => ['C2/U5/L04', :leaf, 'IS5200/L04', '', 36],
        'MF0;ib0-is5200-a2-bip-m:IS5200/L06/U1' => ['C2/U5/L06', :leaf, 'IS5200/L06', '', 36],
        'MF0;ib0-is5200-a2-bip-m:IS5200/L08/U1' => ['C2/U5/L08', :leaf, 'IS5200/L08', '', 36],
        'MF0;ib0-is5200-a2-bip-m:IS5200/L10/U1' => ['C2/U5/L10', :leaf, 'IS5200/L10', '', 36],
        'MF0;ib0-is5200-a2-bip-m:IS5200/L12/U1' => ['C2/U5/L12', :leaf, 'IS5200/L12', '', 36],
 
        'MF0;ib0-is5300-c4-bip-m:IS5300/L01/U1' => ['C4/U5/L01', :leaf, 'IS5300/L01', '', 36],
        'MF0;ib0-is5300-c4-bip-m:IS5300/L03/U1' => ['C4/U5/L03', :leaf, 'IS5300/L03', '', 36],
        'MF0;ib0-is5300-c4-bip-m:IS5300/L05/U1' => ['C4/U5/L05', :leaf, 'IS5300/L05', '', 36],
        'MF0;ib0-is5300-c4-bip-m:IS5300/L07/U1' => ['C4/U5/L07', :leaf, 'IS5300/L07', '', 36],
        'MF0;ib0-is5300-c4-bip-m:IS5300/L09/U1' => ['C4/U5/L09', :leaf, 'IS5300/L09', '', 36],
        'MF0;ib0-is5300-c4-bip-m:IS5300/L11/U1' => ['C4/U5/L11', :leaf, 'IS5300/L11', '', 36],
        'MF0;ib0-is5300-c4-bip-m:IS5300/L13/U1' => ['C4/U5/L13', :leaf, 'IS5300/L13', '', 36],
        'MF0;ib0-is5300-c4-bip-m:IS5300/L02/U1' => ['C4/U5/L02', :leaf, 'IS5300/L02', '', 36],
        'MF0;ib0-is5300-c4-bip-m:IS5300/L04/U1' => ['C4/U5/L04', :leaf, 'IS5300/L04', '', 36],
        'MF0;ib0-is5300-c4-bip-m:IS5300/L06/U1' => ['C4/U5/L06', :leaf, 'IS5300/L06', '', 36],
        'MF0;ib0-is5300-c4-bip-m:IS5300/L08/U1' => ['C4/U5/L08', :leaf, 'IS5300/L08', '', 36],
        'MF0;ib0-is5300-c4-bip-m:IS5300/L10/U1' => ['C4/U5/L10', :leaf, 'IS5300/L10', '', 36],
        'MF0;ib0-is5300-c4-bip-m:IS5300/L12/U1' => ['C4/U5/L12', :leaf, 'IS5300/L12', '', 36],

        'Mellanox 4036E # ib0gw-a2-001-m' => ['E1/A/U42', :leaf, '4036E-1', '', 36], # Now shows up with this name.
        'Mellanox 4036E # ib0gw-a2-002-m' => ['E1/A/U43', :leaf, '4036E-2', '', 36], # Now shows up with this name.

        'MF0;ib-sx6036-a2-004-m:SX6036/U1' => ['O15/U16', :leaf, 'SX6036-4', '', 36],

        'MF0;ib0-is5200-a2-bip-m:IS5200/S01/U1' => ['C2/U5/S01', :spine, 'IS5200/S01', '', 36],
        'MF0;ib0-is5200-a2-bip-m:IS5200/S02/U1' => ['C2/U5/S02', :spine, 'IS5200/S02', '', 36],
        'MF0;ib0-is5200-a2-bip-m:IS5200/S03/U1' => ['C2/U5/S03', :spine, 'IS5200/S03', '', 36],
        'MF0;ib0-is5200-a2-bip-m:IS5200/S04/U1' => ['C2/U5/S04', :spine, 'IS5200/S04', '', 36],
        'MF0;ib0-is5200-a2-bip-m:IS5200/S05/U1' => ['C2/U5/S05', :spine, 'IS5200/S05', '', 36],
        'MF0;ib0-is5200-a2-bip-m:IS5200/S06/U1' => ['C2/U5/S06', :spine, 'IS5200/S06', '', 36],

        'MF0;ib0-is5300-c4-bip-m:IS5300/S01/U1' => ['C4/U5/S01', :spine, 'IS5300/S01', '', 36],
        'MF0;ib0-is5300-c4-bip-m:IS5300/S02/U1' => ['C4/U5/S02', :spine, 'IS5300/S02', '', 36],
        'MF0;ib0-is5300-c4-bip-m:IS5300/S03/U1' => ['C4/U5/S03', :spine, 'IS5300/S03', '', 36],
        'MF0;ib0-is5300-c4-bip-m:IS5300/S04/U1' => ['C4/U5/S04', :spine, 'IS5300/S04', '', 36],
        'MF0;ib0-is5300-c4-bip-m:IS5300/S05/U1' => ['C4/U5/S05', :spine, 'IS5300/S05', '', 36],
        'MF0;ib0-is5300-c4-bip-m:IS5300/S06/U1' => ['C4/U5/S06', :spine, 'IS5300/S06', '', 36],
        'MF0;ib0-is5300-c4-bip-m:IS5300/S07/U1' => ['C4/U5/S07', :spine, 'IS5300/S07', '', 36],
        'MF0;ib0-is5300-c4-bip-m:IS5300/S08/U1' => ['C4/U5/S08', :spine, 'IS5300/S08', '', 36],
        'MF0;ib0-is5300-c4-bip-m:IS5300/S09/U1' => ['C4/U5/S09', :spine, 'IS5300/S09', '', 36],

        'MF0;ib-sx6036-a2-001-m:SX6036/U1' => ['C2/U19', :ex_spine, 'SX6036-1', '', 36],
        'MF0;ib-sx6036-a2-002-m:SX6036/U1' => ['C2/U36', :ex_spine, 'SX6036-2', '', 36],
        'MF0;ib-sx6036-a2-003-m:SX6036/U1' => ['C2/U17', :ex_spine, 'SX6036-3', '', 36],
      }
    @switch_location = @location
    #Voltaire 10G
    @location["Mellanox 4036E IO ib0gw-a2-001-m"] = ["10G", :node, "10G", ""] #10G ports on the Voltaire switches.
    @location["Mellanox 4036E IO ib0gw-a2-002-m"] = ["10G", :node, "10G", ""]
    #A1 Rack
    (1..42).each { |i| @location["compute-a1-#{"%03d"%i}-p HCA-1"] = ["A1/A/U#{i}",:cnode, "a1-#{"%03d"%i}", "compute-a1-#{"%03d"%i}"] }
    (2..15).each { |i| @location["compute-a1-#{"%03d"%(43+i-2)}-p HCA-1"] = ["A1/C/U#{i}", :cnode, "a1-#{"%03d"%(43+i-2)}", "compute-a1-#{"%03d"%(43+i-2)}"] }
    (24..43).each { |i| @location["compute-a1-#{"%03d"%(57+i-24)}-p HCA-1"] = ["A1/C/U#{i}", :cnode, "a1-#{"%03d"%(57+i-24)}", "compute-a1-#{"%03d"%(57+i-24)}"] }
    @location["compute-gpu-a1-001-p HCA-1"] = ["A1/C/U#{16}", :cnode, "a1-gpu-1", "compute-gpu-a1-001"]
    @location["compute-gpu-a1-002-p HCA-1"] = ["A1/C/U#{18}", :cnode, "a1-gpu-2", "compute-gpu-a1-002"]
    @location["compute-gpu-a1-003-p HCA-1"] = ["A1/C/U#{20}", :cnode, "a1-gpu-3", "compute-gpu-a1-003"]
    @location["compute-gpu-a1-004-p HCA-1"] = ["A1/C/U#{22}", :cnode, "a1-gpu-4", "compute-gpu-a1-004"]
    #C1 Rack
    (1..34).each { |i| @location["compute-b1-#{"%03d"%i}-p HCA-1"] = ["C1/A/U#{i}", :cnode, "b1-#{"%03d"%i}", "compute-b1-#{"%03d"%i}"] }
    (2..35).each { |i| @location["compute-b1-#{"%03d"%(35+i-2)}-p HCA-1"] = ["C1/C/U#{i}", :cnode, "b1-#{"%03d"%(35+i-2)}", "compute-b1-#{"%03d"%(35+i-2)}"] }
    @location["compute-gpu-b1-001-p HCA-1"] = ["C1/A/U#{35}", :cnode, "b1-gpu-1", "compute-gpu-b1-001"]
    @location["compute-gpu-b1-002-p HCA-1"] = ["C1/A/U#{37}", :cnode, "b1-gpu-2", "compute-gpu-b1-002"]
    @location["compute-gpu-b1-003-p HCA-1"] = ["C1/A/U#{39}", :cnode, "b1-gpu-3", "compute-gpu-b1-003"]
    @location["compute-gpu-b1-004-p HCA-1"] = ["C1/A/U#{41}", :cnode, "b1-gpu-4", "compute-gpu-b1-004"]
    @location["compute-gpu-b1-005-p HCA-1"] = ["C1/C/U#{36}", :cnode, "b1-gpu-5", "compute-gpu-b1-005"]
    @location["compute-gpu-b1-006-p HCA-1"] = ["C1/C/U#{38}", :cnode, "b1-gpu-6", "compute-gpu-b1-006"]
    @location["compute-gpu-b1-007-p HCA-1"] = ["C1/C/U#{40}", :cnode, "b1-gpu-7", "compute-gpu-b1-007"]
    @location["compute-gpu-b1-008-p HCA-1"] = ["C1/C/U#{42}", :cnode, "b1-gpu-8", "compute-gpu-b1-008"]
    #C3 Rack
    (1..28).each { |i| @location["compute-c1-#{"%03d"%i}-p HCA-1"] = ["C3/A/U#{i}", :cnode, "c1-#{"%03d"%i}", "compute-c1-#{"%03d"%i}"] }
    (2..29).each { |i| @location["compute-c1-#{"%03d"%(29+i-2)}-p HCA-1"] = ["C3/C/U#{i}", :cnode, "c1-#{"%03d"%(29+i-2)}", "compute-c1-#{"%03d"%(29+i-2)}"] }
    @location["compute-gpu-c1-001-p HCA-1"] = ["C3/A/U#{29}", :cnode, "c1-gpu-1", "compute-gpu-c1-001"]
    @location["compute-gpu-c1-002-p HCA-1"] = ["C3/A/U#{31}", :cnode, "c1-gpu-2", "compute-gpu-c1-002"]
    @location["compute-gpu-c1-003-p HCA-1"] = ["C3/C/U#{30}", :cnode, "c1-gpu-3", "compute-gpu-c1-003"]
    @location["compute-gpu-c1-004-p HCA-1"] = ["C3/C/U#{32}", :cnode, "c1-gpu-4", "compute-gpu-c1-004"]
    #New Ivybridge nodes in C3 Rack
    @location["compute-c1-057-p HCA-1"] = ["C3/C/U#{36}", :cnode, "c1-057", "compute-c1-057"]
    @location["compute-c1-058-p HCA-1"] = ["C3/C/U#{37}", :cnode, "c1-058", "compute-c1-058"]
    @location["compute-c1-059-p HCA-1"] = ["C3/A/U#{37}", :cnode, "c1-059", "compute-c1-059"]
    @location["compute-c1-060-p HCA-1"] = ["C3/A/U#{38}", :cnode, "c1-060", "compute-c1-060"]
    #A4 Rack
    (1..36).each { |i| @location["compute-d1-#{"%03d"%i}-p HCA-1"] = ["A4/A/U#{i}", :cnode, "d1-#{"%03d"%i}", "compute-d1-#{"%03d"%i}"] }
    (2..35).each { |i| @location["compute-d1-#{"%03d"%(37+i-2)}-p HCA-1"] = ["A4/C/U#{i}", :cnode, "d1-#{"%03d"%(37+i-2)}", "compute-d1-#{"%03d"%(37+i-2)}"] }
    @location["compute-gpu-d1-001-p HCA-1"] = ["A4/A/U#{37}", :cnode, "d1-gpu-1", "compute-gpu-d1-001"]
    @location["compute-gpu-d1-002-p HCA-1"] = ["A4/A/U#{39}", :cnode, "d1-gpu-2", "compute-gpu-d1-002"]
    @location["compute-gpu-d1-003-p HCA-1"] = ["A4/C/U#{36}", :cnode, "d1-gpu-3", "compute-gpu-d1-003"]
    @location["compute-gpu-d1-004-p HCA-1"] = ["A4/C/U#{38}", :cnode, "d1-gpu-4", "compute-gpu-d1-004"]
    @location["compute-gpu-d1-005-p HCA-1"] = ["A4/C/U#{40}", :cnode, "d1-gpu-5", "compute-gpu-d1-005"]
    @location["compute-phi-d1-001-p HCA-1"] = ["A4/A/U#{41}", :cnode, "d1-phi-1", "compute-phi-d1-001"]
    @location["compute-phi-d1-002-p HCA-1"] = ["A4/C/U#{42}", :cnode, "d1-phi-2", "compute-phi-d1-002"]
    #A5 Rack
    (23..40).each { |i| @location["compute-e1-#{"%03d"% (i+45-23)}-p HCA-1"] = ["A5/A/U#{i}", :cnode, "e1-#{"%03d"% (i+45-23)}", "compute-e1-#{"%03d"% (i+45-23)}"] }
    (24..43).each { |i| @location["compute-e1-#{"%03d"% (i-24+63)}-p HCA-1"] = ["A5/C/U#{i}", :cnode, "e1-#{"%03d"% (i-24+63)}", "compute-e1-#{"%03d"% (i-24+63)}"] }
    #New Ivybridge nodes in A5 Rack
    (1..22).each { |i| @location["compute-e1-#{"%03d"%i}-p HCA-1"] = ["A5/A/U#{i}", :cnode, "e1-#{"%03d"%i}", "compute-e1-#{"%03d"%i}"] }
    (2..23).each { |i| @location["compute-e1-#{"%03d"%(23+i-2)}-p HCA-1"] = ["A5/C/U#{i}", :cnode, "e1-#{"%03d"%(23+i-2)}", "compute-e1-#{"%03d"%(23+i-2)}"] }
    #A2 Rack
    @location["vm-a2-001-p HCA-1"] = ["C4/U37/A", :node, "NeVE-1A", '']
    @location["vm-a2-001-p HCA-2"] = ["C4/U37/B", :node, "NeVE-1B", '']
    @location["vm-a2-002.ceres.auckland.ac.nz HCA-1"] = ["A2/U31/A", :node, "NeVE-2A", '']
    @location["vm-a2-002.ceres.auckland.ac.nz HCA-2"] = ["A2/U31/B", :node, "NeVE-2B", '']
    @location["vm-a2-003-p HCA-1"] = ["C4/U41/A", :node, "NeVE-3A", '']
    @location["vm-a2-003-p HCA-2"] = ["C4/U41/B", :node, "NeVE-3B", '']
    @location["login-p HCA-1"] = ["A2/U27/A", :node, "login-p/A", ''] #Alternate name for vm4
    @location["login-p HCA-2"] = ["A2/U27/B", :node, "login-p/B", ''] #Alternate name for vm4
    @location["pan HCA-1"] = ["A2/U23/A", :node, "pan", '']
    @location["login1-p HCA-1"] = ["A2/U23/A", :node, "login1", ''] #Loadleveler ?
    @location["xcat-p HCA-1"] = ["A2/U17/A", :node, "xcat/A", '']
    @location["xcat-p HCA-3"] = ["A2/U17/B", :node, "xcat/B", '']
    #A3 Rack
    @location["gpfs-a3-001-p HCA-1"] = ["A3/U1", :node, "gpfs1", '']
    @location["gpfs-a3-002-p HCA-1"] = ["A3/U3", :node, "gpfs2", '']
    @location["gpfs-a3-003-p HCA-1"] = ["A3/U5", :node, "gpfs3", '']
    @location["gpfs-a3-004-p HCA-1"] = ["A3/U7", :node, "gpfs4", '']
    #C4 Rack
    @location["compute-bigmem-001-p HCA-1"] = ["A2/U27", :cnode, "bm-1", "compute-bigmem-001"]
    @location["compute-bigmem-001-p HCA-2"] = ["A2/U27", :cnode, "bm-1", "compute-bigmem-001"]
    @location["compute-bigmem-c3-001-p HCA-1"] = ["A2/U27", :cnode, "bm-1", "compute-bigmem-001"]
    @location["compute-bigmem-c3-001-p HCA-2"] = ["A2/U27", :cnode, "bm-1", "compute-bigmem-001"]
    @location["compute-bigmem-002-p HCA-1"] = ["C4/U39", :cnode, "bm-2", "compute-bigmem-002"]
    @location["compute-bigmem-002-p HCA-2"] = ["C4/U39", :cnode, "bm-2", "compute-bigmem-002"]
    @location["compute-bigmem-003-p HCA-1"] = ["A2/U35", :cnode, "bm-3", "compute-bigmem-003"]
    @location["compute-bigmem-003-p HCA-2"] = ["A2/U35", :cnode, "bm-3", "compute-bigmem-003"]
    @location["compute-bigmem-004-p HCA-1"] = ["A2/U39", :cnode, "bm-4", "compute-bigmem-004"]
    @location["compute-bigmem-004-p HCA-2"] = ["A2/U39", :cnode, "bm-4", "compute-bigmem-004"]
    @location["gpfs-a4-005-p HCA-1"] = ["C4/U25", :node, "gpfs5", '']
    @location["gpfs-a4-006-p HCA-1"] = ["C4/U23", :node, "gpfs6", '']
    @location["xcat2-p HCA-1"] = ["C4/U27", :node, "xcat2/A"]
    #Chem Rack
    @location["compute-chem-001-p HCA-1"] = ["C2/U31/A", :cnode, "chem1/A", "compute-chem-001"]
    @location["compute-chem-001-p HCA-2"] = ["C2/U31/B", :cnode, "chem1/B", "compute-chem-001"]
    #CS
    @location["build-gpu-p HCA-1"] = ["C2/U29", :node, "build-gpu", '']
    @location["build-sn-gpu-p HCA-1"] = ["?", :node, "build-sn-gpu", '']
    @location["compute-cs-001-p HCA-1"] = ["C3/A/U35", :cnode, "cs-001", "compute-cs-001"]
    #Stats nodes
    (1..10).each { |i| @location["compute-stats-#{"%03d"%i}-p HCA-1"] = ["C2/U29/A", :cnode, "stats-#{"%03d"%i}", "compute-stats-#{"%03d"%i}"] }
    #FMHS
    (1..3).each { |i| @location["compute-fmhs-#{"%03d"%i}-p HCA-1"] = ["C2/U29/A", :cnode, "fmhs-#{"%03d"%i}", "compute-fmhs-#{"%03d"%i}"] }
    #Lustre
    (1..8).each { |i| @location["lustre-dev-#{"%d"%i}-p HCA-1"] = ["C2/U29/A", :node, "lustre-dev-#{"%03d"%i}", ''] }

    @switches = {}
    @switch_lids = {}
    parse_iblinkinfo
  end
    
  def parse_iblinkinfo
    if @run_command == true
      result = `#{@file_name}` 
    else
      result = File.read(@file_name)
    end
    result.each_line do |a|
      a.chomp!
      if a[0] != ' '
        fields = a.split(' ')
        @switch = fields[2..-1].join(' ').chomp(':')
        @switches[@switch] = []
      else
        b = a.split('==')
        fields = b[0].scanf('       %4d %4d[%2c] ') #LID , Port, ?
        c = b[1].split(' ')
        fields << c[1..-3].join(' ') #Drop leading '('. Speed of connection.
        fields << c[-2].chomp('/') #Active or Down
        fields << c[-1].chomp(')') # LinkUp or Polling
        b[2].scanf('>    %4d %4d[%2c] "%[^"]" (%1c)').each { |v| fields << v } #Remote LID, Remote Port, ?, name
        @switches[@switch][fields[1]] = fields
        @switch_lids[@switch] = fields[0] 
      end
    end
    i = 0
    @location.each do |k, l|
      if l[1] == :spine || l[1] == :leaf || l[1] == :ex_spine
        l[3] = "s#{i}"
        i = i + 1
      end
    end
  end
end


