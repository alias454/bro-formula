{% from "bro/map.jinja" import host_lookup as config with context -%}
##! Managed by Salt Do not edit
##! Originally I found this solution in Security Onion and liked the way it worked.
##! Original source located https://github.com/Security-Onion-Solutions/securityonion-bro-scripts

module BPFconf;

@load base/frameworks/input
@load base/frameworks/cluster

export
{
    ## Event to capture when the interface is discovered.
    global BPFconf::found_interface: event(inter: string);

    ## Interface being sniffed.
    global interface = "";
}

type InterfaceCmdLine: record {
    s: string;
};

event BPFconf::interface_line(description: Input::EventDescription, tpe: Input::Event, s: string)
{
    local parts = split_all(s, /[[:blank:]]*=[[:blank:]]*/);
    if ( 3 in parts )
    {
        interface = parts[3];
        event BPFconf::found_interface(interface);
    }
}

event bro_init() &priority=5
{
    local peer = get_event_peer()$descr;
    if ( peer in Cluster::nodes && Cluster::nodes[peer]?$interface )
    {
        interface = Cluster::nodes[peer]$interface;
        event BPFconf::found_interface(interface);
        return;
    }
    else
    {
        Input::add_event([
            $source= "grep \"interface\" {{ config.bro.CfgDir }}/node.cfg 2>/dev/null | grep -v \"^[[:blank:]]*#\" |",
            $name="NSM-interface",
            $reader=Input::READER_RAW,
            $want_record=F,
            $fields=InterfaceCmdLine,
            $ev=BPFconf::interface_line]);		
    }
}
