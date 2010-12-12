/* a few things "borrowed" from kismet :) */

enum ieee_80211_type {
    packet_noise = -2,
    packet_unknown = -1,
    packet_management = 0,
    packet_phy = 1, 
    packet_data = 2 
};

enum ieee_80211_subtype {
    packet_sub_unknown = -1,
    // Management subtypes
    packet_sub_association_req = 0,
    packet_sub_association_resp = 1,
    packet_sub_reassociation_req = 2,
    packet_sub_reassociation_resp = 3,
    packet_sub_probe_req = 4,
    packet_sub_probe_resp = 5,
    packet_sub_beacon = 8,
    packet_sub_atim = 9,
    packet_sub_disassociation = 10,
    packet_sub_authentication = 11,
    packet_sub_deauthentication = 12,
    // Phy subtypes
	packet_sub_pspoll = 10,
    packet_sub_rts = 11,
    packet_sub_cts = 12,
    packet_sub_ack = 13,
    packet_sub_cf_end = 14,
    packet_sub_cf_end_ack = 15,
    // Data subtypes
    packet_sub_data = 0,
    packet_sub_data_cf_ack = 1,
    packet_sub_data_cf_poll = 2,
    packet_sub_data_cf_ack_poll = 3,
    packet_sub_data_null = 4,
    packet_sub_cf_ack = 5,
    packet_sub_cf_ack_poll = 6,
    packet_sub_data_qos_data = 8,
    packet_sub_data_qos_data_cf_ack = 9,
    packet_sub_data_qos_data_cf_poll = 10,
    packet_sub_data_qos_data_cf_ack_poll = 11,
    packet_sub_data_qos_null = 12,
    packet_sub_data_qos_cf_poll_nod = 14,
    packet_sub_data_qos_cf_ack_poll = 15
};

// distribution directions
enum ieee_80211_disttype {
    distrib_unknown, distrib_from, distrib_to,
    distrib_inter, distrib_adhoc
};

// Signalling layer info - what protocol are we seeing data on?
// Not all of these types are currently supported, of course
enum phy_carrier_type {
    carrier_unknown,
    carrier_80211b,
    carrier_80211bplus,
    carrier_80211a,
    carrier_80211g,
    carrier_80211fhss,
    carrier_80211dsss,
	carrier_80211n20,
	carrier_80211n40
};

// Packet encoding info - how are packets encoded?
enum phy_encoding_type {
    encoding_unknown,
    encoding_cck,
    encoding_pbcc,
    encoding_ofdm,
	encoding_dynamiccck,
	encoding_gfsk
};

// Turbocell modes
enum turbocell_type {
    turbocell_unknown,
    turbocell_ispbase, // 0xA0
    turbocell_pollbase, // 0x80
    turbocell_nonpollbase, // 0x00
    turbocell_base // 0x40
};

// IAPP crypt enums
enum iapp_type {
    iapp_announce_request = 0,
    iapp_announce_response = 1,
    iapp_handover_request = 2,
    iapp_handover_response = 3
};

enum iapp_pdu {
    iapp_pdu_ssid = 0x00,
    iapp_pdu_bssid = 0x01,
    iapp_pdu_oldbssid = 0x02,
    iapp_pdu_msaddr = 0x03,
    iapp_pdu_capability = 0x04,
    iapp_pdu_announceint = 0x05,
    iapp_pdu_hotimeout = 0x06,
    iapp_pdu_messageid = 0x07,
    iapp_pdu_phytype = 0x10,
    iapp_pdu_regdomain = 0x11,
    iapp_pdu_channel = 0x12,
    iapp_pdu_beaconint = 0x13,
    iapp_pdu_ouiident = 0x80,
    iapp_pdu_authinfo = 0x81
};

enum iapp_cap {
    iapp_cap_forwarding = 0x40,
    iapp_cap_wep = 0x20
};

enum iapp_phy {
    iapp_phy_prop = 0x00,
    iapp_phy_fhss = 0x01,
    iapp_phy_dsss = 0x02,
    iapp_phy_ir = 0x03,
    iapp_phy_ofdm = 0x04
};

enum iapp_dom {
    iapp_dom_fcc = 0x10,
    iapp_dom_ic = 0x20,
    iapp_dom_etsi = 0x30,
    iapp_dom_spain = 0x31,
    iapp_dom_france = 0x32,
    iapp_dom_mkk = 0x40
};

enum iapp_auth {
    iapp_auth_status = 0x01,
    iapp_auth_username = 0x02,
    iapp_auth_provname = 0x03,
    iapp_auth_rxpkts = 0x04,
    iapp_auth_txpkts = 0x05,
    iapp_auth_rxbytes = 0x06,
    iapp_auth_txbytes = 0x07,
    iapp_auth_logintime = 0x08,
    iapp_auth_timelimit = 0x09,
    iapp_auth_vollimit = 0x0a,
    iapp_auth_acccycle = 0x0b,
    iapp_auth_rxgwords = 0x0c,
    iapp_auth_txgwords = 0x0d,
    iapp_auth_ipaddr = 0x0e,
    iapp_auth_trailer = 0xff
};

typedef struct {
    unsigned iapp_version : 8;
    unsigned iapp_type : 8;
} __attribute__ ((packed)) iapp_header;

typedef struct {
    unsigned pdu_type : 8;
    unsigned pdu_len : 16;
} __attribute__ ((packed)) iapp_pdu_header;

// Crypt bitfield
enum crypt_type {
	crypt_none = 0,
	crypt_unknown = 1,
	crypt_wep = (1 << 1),
	crypt_layer3 = (1 << 2),
	// Derived from WPA headers
	crypt_wep40 = (1 << 3),
	crypt_wep104 = (1 << 4),
	crypt_tkip = (1 << 5),
	crypt_wpa = (1 << 6),
	crypt_psk = (1 << 7),
	crypt_aes_ocb = (1 << 8),
	crypt_aes_ccm = (1 << 9),
	//WPA Migration Mode
	crypt_wpa_migmode = (1 << 19),
	// Derived from data traffic
	crypt_leap = (1 << 10),
	crypt_ttls = (1 << 11),
	crypt_tls = (1 << 12),
	crypt_peap = (1 << 13),
	crypt_isakmp = (1 << 14),
    crypt_pptp = (1 << 15),
	crypt_fortress = (1 << 16),
	crypt_keyguard = (1 << 17),
	crypt_unknown_nonwep = (1 << 18),
};

enum network_type {
	network_ap = 0,
	network_adhoc = 1,
	network_probe = 2,
	network_turbocell = 3,
	network_data = 4,
	network_mixed = 255,
	network_remove = 256
};

enum client_type {
	client_unknown = 0,
	client_fromds = 1,
	client_tods = 2,
	client_interds = 3,
	client_established = 4,
	client_adhoc = 5,
	client_remove = 6
};

enum ipdata_type {
	ipdata_unknown = 0,
	ipdata_factoryguess = 1,
	ipdata_udptcp = 2,
	ipdata_arp = 3,
	ipdata_dhcp = 4,
	ipdata_group = 5
};

enum ssid_type {
	ssid_beacon = 0,
	ssid_proberesp = 1,
	ssid_probereq = 2,
	ssid_file = 3,
};

