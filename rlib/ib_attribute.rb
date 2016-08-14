#put structure around the ib ports discovered by IBLinkInfo
#a = "           4    1[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>       3   18[  ] \"MF0;ib0-is5200-a2-bip-m:IS5200/L07/U1\" ( )"
#a = '           1   35[  ] ==( 4X  5.0 Gbps Active/  LinkUp)==>       2    1[  ] "Voltaire 4036E IO ib0gw-a2-001-m" ( )'
#a = '         223   33[  ] ==( 4X  10.0 Gbps (FDR10) Active/  LinkUp)==>     145    1[  ] "gpfs-a4-005-p HCA-1" ( )'
     #12345678901234567890123456789012345678901234567890123456789012345678901234567 8901234567890123456789012345678901234 567890
     #         1         2         3         4         5         6         7          8         9        10        11         12

class IB_attribute < Array
  def lid
    self[0]
  end
  def port
    self[1]
  end
  def speed
    self[3]
  end
  def active?
    self[4] == 'Active'
  end
  def up?
    self[5] == 'LinkUp'
  end
  def speed_40G?
    speed == "4X 10.0 Gbps"
  end
  def remote_lid
    self[6]
  end
  def remote_port
    self[7]
  end
  def remote_host
    self[9] == nil ? "" : self[9]
  end
  def short_name
    # l = location[self.remote_host]
    # "#{l == nil ? self.remote_host : "#{l[2]}/P#{"%02d"%self.remote_port}"}" #Alternate name
    self[10]
  end
  def node_type
    self[11]
  end
  def host_basename
    self[12]
  end
end

#Test
#ib = IB_attribute.new([4,1,'','4X 10.0 Gbps','Active','LinkUp',3,18,'','MF0;ib0-is5200-a2-bip-m:IS5200/L07/U1'])
#puts ib.lid,ib.port,ib.speed,ib.active?,ib.up?,ib.remote_lid,ib.remote_port,ib.remote_host


