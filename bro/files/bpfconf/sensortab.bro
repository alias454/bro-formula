{% from "bro/map.jinja" import host_lookup as config with context -%}
##! Managed by Salt Do not edit
##! Originally I found this solution in Security Onion and liked the way it worked.
##! Original source located https://github.com/Security-Onion-Solutions/securityonion-bro-scripts

@load ./readfile

module BPFconf;

@load base/frameworks/input
@load base/frameworks/cluster

export
{
    ## Event to capture when the interface is discovered.
    global BPFconf::found_interface: event(inter: string);

    ## Event to capture when the interface is discovered.
    global BPFconf::found_sensorname: event(name: string);

    ## Interface being sniffed.
    global interface = "";

    ## Name of the sensor.
    global sensorname = "";

    ## The filename where the sensortab is located.
    const sensortab_file = "{{ config.bro.CfgDir }}/node.cfg" &redef;
}

event bro_init()
{
    if ( Cluster::is_enabled() && Cluster::local_node_type() == Cluster::WORKER ) 
    {
        local node = Cluster::node;
        if ( node in Cluster::nodes && Cluster::nodes[node]?$interface )
        {
            interface = Cluster::nodes[node]$interface;
            event BPFconf::found_interface(interface);
        }
    }
    else if ( Cluster::local_node_type() != Cluster::MANAGER ) 
    {
        # If running in standalone mode...
        when ( local nodefile = readfile(sensortab_file) )
        {
            local lines = split_string_all(nodefile, /\n/);
            for ( i in lines )
            {
                if ( /^[[:blank:]]*#/ in lines[i] )
                    next;

                local fields = split_string_all(lines[i], /[[:blank:]]*=[[:blank:]]*/);
                if ( 2 in fields && fields[0] == "interface" )
                {
                    interface = fields[2];
                    event BPFconf::found_interface(interface);
                }
            }
        }
    }
}

event BPFconf::found_interface(interface: string)
{
    when ( local r = readfile("{{ config.bro.CfgDir }}/sensortab") )
    {
        local lines = split_string_all(r, /\n/);
        for ( i in lines )
        {
            local fields = split_string_all(lines[i], /\t/);
            if ( 6 !in fields )
                next;

            local name = fields[0];
            local iface = fields[6];

            if ( BPFconf::iface == interface )
            {
                #print "Sensorname: " + sensorname + " -- Interface: " + sensor_interface;
                sensorname = name;
                event BPFconf::found_sensorname(sensorname);
            }
        }
    }
}
