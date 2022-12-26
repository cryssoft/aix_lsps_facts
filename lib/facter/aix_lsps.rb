#
#  FACT(S):     aix_lsps
#
#  PURPOSE:     This custom fact returns a hash of "lsps -a" output with
#		LV->details.
#
#  RETURNS:     (hash)
#
#  AUTHOR:      Chris Petersen, Crystallized Software
#
#  DATE:        March 16, 2021
#
#  NOTES:       Myriad names and acronyms are trademarked or copyrighted by IBM
#               including but not limited to IBM, PowerHA, AIX, RSCT (Reliable,
#               Scalable Cluster Technology), and CAA (Cluster-Aware AIX).  All
#               rights to such names and acronyms belong with their owner.
#
#		NEVER FORGET!  "\n" and '\n' are not the same in Ruby!
#
#-------------------------------------------------------------------------------
#
#  LAST MOD:    (never)
#
#  MODIFICATION HISTORY:
#
#       (none)
#
#-------------------------------------------------------------------------------
#
Facter.add(:aix_lsps) do
    #  This only applies to the AIX operating system
    confine :osfamily => 'AIX'

    #  Define an empty hash to return
    l_aixLSPS = {}

    #  Do the work
    setcode do
        #  Run the command to look at paging spaces
        l_lines = Facter::Util::Resolution.exec('/usr/sbin/lsps -a 2>/dev/null')

        #  Loop over the lines that were returned
        l_lines && l_lines.split("\n").each do |l_oneLine|
            #  Skip the header line
            next if (l_oneLine =~ /^Page Space/)

            #  Strip leading and trailing whitespace and split on any whitespace
            l_list = l_oneLine.strip().split()

            #  Stash the data in the hash by LV name
            l_aixLSPS[l_list[0]]           = {}
            l_aixLSPS[l_list[0]]['pv']     = l_list[1]
            l_aixLSPS[l_list[0]]['vg']     = l_list[2]
            l_aixLSPS[l_list[0]]['size']   = l_list[3]
            l_aixLSPS[l_list[0]]['active'] = l_list[5]
            l_aixLSPS[l_list[0]]['auto']   = l_list[6]
        end

        #  Implicitly return the contents of the variable
        l_aixLSPS
    end
end
