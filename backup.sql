--
-- PostgreSQL database dump
--

\restrict mL8zNFIdBf7Kd5Rwsu8rwaScqgqlnfILZSTajyxekzr7tX21NnJiyijHzqF1MyM

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: aircraft; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aircraft (
    aircraft_id integer NOT NULL,
    registration character varying(12),
    icao24 character varying(6),
    aircraft_type_id integer,
    CONSTRAINT aircraft_id_present CHECK (((registration IS NOT NULL) OR (icao24 IS NOT NULL)))
);


ALTER TABLE public.aircraft OWNER TO postgres;

--
-- Name: aircraft_aircraft_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.aircraft ALTER COLUMN aircraft_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.aircraft_aircraft_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: aircraft_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aircraft_type (
    aircraft_type_id integer NOT NULL,
    iata_code character varying(4),
    icao_code character varying(4),
    CONSTRAINT aircraft_type_code_present CHECK (((iata_code IS NOT NULL) OR (icao_code IS NOT NULL)))
);


ALTER TABLE public.aircraft_type OWNER TO postgres;

--
-- Name: aircraft_type_aircraft_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.aircraft_type ALTER COLUMN aircraft_type_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.aircraft_type_aircraft_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: airline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.airline (
    airline_id integer NOT NULL,
    iata character varying(3),
    icao character varying(4),
    name character varying(100) NOT NULL,
    CONSTRAINT airline_code_present CHECK (((iata IS NOT NULL) OR (icao IS NOT NULL)))
);


ALTER TABLE public.airline OWNER TO postgres;

--
-- Name: airline_airline_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.airline ALTER COLUMN airline_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.airline_airline_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: airport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.airport (
    airport_id integer NOT NULL,
    iata character varying(3),
    icao character varying(4),
    name character varying(150),
    timezone character varying(50),
    CONSTRAINT airport_code_present CHECK (((iata IS NOT NULL) OR (icao IS NOT NULL)))
);


ALTER TABLE public.airport OWNER TO postgres;

--
-- Name: airport_airport_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.airport ALTER COLUMN airport_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.airport_airport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: arrival; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.arrival (
    flight_id bigint NOT NULL,
    terminal character varying(10),
    gate character varying(10),
    baggage character varying(10),
    delay integer,
    scheduled timestamp with time zone NOT NULL,
    estimated timestamp with time zone,
    actual timestamp with time zone,
    estimated_runway timestamp with time zone,
    actual_runway timestamp with time zone
);


ALTER TABLE public.arrival OWNER TO postgres;

--
-- Name: codeshare; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.codeshare (
    flight_id bigint NOT NULL,
    operating_airline_id integer NOT NULL,
    operating_flight_number character varying(6) NOT NULL
);


ALTER TABLE public.codeshare OWNER TO postgres;

--
-- Name: departure; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departure (
    flight_id bigint NOT NULL,
    terminal character varying(10),
    gate character varying(10),
    delay integer,
    scheduled timestamp with time zone NOT NULL,
    estimated timestamp with time zone,
    actual timestamp with time zone,
    estimated_runway timestamp with time zone,
    actual_runway timestamp with time zone
);


ALTER TABLE public.departure OWNER TO postgres;

--
-- Name: flight; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flight (
    flight_id bigint NOT NULL,
    flight_date date NOT NULL,
    flight_status character varying(12) NOT NULL,
    airline_id integer,
    flight_number character varying(6) NOT NULL,
    departure_airport_id integer NOT NULL,
    arrival_airport_id integer NOT NULL,
    aircraft_id integer,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT flight_status_valid CHECK (((flight_status)::text = ANY ((ARRAY['scheduled'::character varying, 'active'::character varying, 'landed'::character varying, 'cancelled'::character varying, 'incident'::character varying, 'diverted'::character varying, 'unknown'::character varying])::text[])))
);


ALTER TABLE public.flight OWNER TO postgres;

--
-- Name: flight_flight_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.flight ALTER COLUMN flight_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.flight_flight_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO postgres;

--
-- Name: live; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.live (
    flight_id bigint NOT NULL,
    updated timestamp with time zone NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    altitude double precision,
    direction double precision,
    speed_horizontal double precision,
    speed_vertical double precision,
    is_ground boolean,
    CONSTRAINT live_lat_range CHECK (((latitude >= ('-90'::integer)::double precision) AND (latitude <= (90)::double precision))),
    CONSTRAINT live_lon_range CHECK (((longitude >= ('-180'::integer)::double precision) AND (longitude <= (180)::double precision)))
);


ALTER TABLE public.live OWNER TO postgres;

--
-- Data for Name: aircraft; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aircraft (aircraft_id, registration, icao24, aircraft_type_id) FROM stdin;
1	\N	600B26	\N
2	\N	7C6DBA	\N
6	\N	7C6D30	\N
7	\N	7C7805	\N
8	\N	801667	\N
9	\N	7C19D2	\N
10	\N	781CE6	\N
11	\N	78160E	\N
13	\N	780B34	\N
14	\N	781104	\N
16	\N	3C6719	\N
18	\N	7C6DB4	\N
23	\N	7C6DE5	\N
28	\N	7C6DDB	\N
35	\N	600B20	\N
36	\N	7C7803	\N
38	\N	7C4A10	\N
39	\N	780A99	\N
40	\N	78929A	\N
41	\N	780190	\N
44	XXB	XXC	\N
43	VH-XCF	7C74BD	\N
46	\N	781CFD	\N
47	\N	C82269	\N
52	\N	C81D8E	\N
56	B-2869	7BD026	20
\.


--
-- Data for Name: aircraft_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aircraft_type (aircraft_type_id, iata_code, icao_code) FROM stdin;
20	B752	B752
\.


--
-- Data for Name: airline; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.airline (airline_id, iata, icao, name) FROM stdin;
75	KC	KZR	Air Astana
649	IU	SJV	Super Air Jet
308	VS	VIR	Virgin Atlantic
655	MZ	AHX	Amakusa Airlines
23	CX	CPA	Cathay Pacific
19	AZ	AZA	Alitalia
106	UO	HKE	HK express
951	RX	RGE	Regent Airways
617	8L	LKE	Lucky Air
13	VA	VOZ	Virgin Australia
57	QR	QTR	Qatar Airways
44	\N	RLY	Air Oceania
390	MS	MSR	Egyptair
8	ET	ETH	Ethiopian Airlines
389	UL	ALK	SriLankan Airlines
142	7C	JJA	Jeju Air
364	G5	HXA	China Express Airlines
709	GEC	GEC	Lufthansa Cargo
99	8M	MMA	Myanmar Airways International
167	LJ	JNA	Jin Air
378	LH	DLH	Lufthansa
193	ZH	CSZ	Shenzhen Airlines
72	\N	CFH	CareFlight
73	\N	CFH	CareFlight
74	\N	CFH	CareFlight
76	J2	AHY	Azerbaijan Airlines
338	MK	MAU	Air Mauritius
82	CF	CYZ	China Postal Airlines
78	DV	VSV	SCAT
328	UX	AEA	Air Europa
161	ZE	ESR	Eastar Jet
32	KL	KLM	KLM
1	7L	AZG	Silk Way West Airlines
21	FJ	FJA	Fiji Airways
171	GK	JJP	Jetstar Japan
163	MM	APJ	Peach
700	C6	MFX	My Freighter
599	PC	PGT	Pegasus
341	ID	BTK	Batik Air
66	AA	AAL	American Airlines
150	JT	LNI	Lion Air
11	QF	QFA	Qantas
326	TG	THA	Thai Airways
157	QG	CTV	Citilink
360	MF	CXA	Xiamen Air
673	JD	CBJ	Capital Airlines
314	DL	DAL	Delta Air Lines
303	VN	HVN	Vietnam Airlines
140	I9	HLF	Central Airlines
302	AI	AIC	Air India
89	GJ	CDC	Loong Air
95	BR	EVA	EVA Air
342	X6	CHZ	Challenge Airlines BE
406	HO	DKH	Juneyao Air
14	CA	CCA	Air China
134	JQ	JST	Jetstar
36	CI	CAL	China Airlines
90	S7	SBI	S7 Airlines
56	TK	THY	Turkish Airlines
3	LA	LAN	LATAM Airlines
104	MR	RMX	AirMaster
330	VJ	VJC	VietJet Air
124	GI	LHA	Air Central
331	N4	NWS	Nordwind Airlines
646	Q2	DQA	Maldivian
105	JG	JDL	JDL Airlines
376	SK	SAS	SAS
146	KA	ANK	Aero Nomad
147	X1	X1	aero nomad
87	O3	CSS	SF Airlines
126	YG	HYT	YTO Cargo Airlines
647	SZ	SMR	Somon Air
152	RI	OEY	Rimbun Air
408	PN	CHB	West Air
5	EK	UAE	Emirates
323	IW	WON	Wings Air
6	SQ	SIA	Singapore Airlines
317	HJ	TMN	DHL Air
54	MH	MAS	Malaysia Airlines
299	XY	KNE	flynas
363	EU	UEA	Chengdu Airlines
631	9C	CQH	Spring Airlines
413	OU	CTN	Croatia Airlines
388	B6	JBU	JetBlue
118	SC	CDG	Shandong Airlines
29	PG	BKP	Bangkok Airways
674	DZ	EPA	Donghai Airlines
45	H1	H1	vietjet air
4	NZ	ANZ	Air New Zealand
79	CZ	CSN	China Southern Airlines
62	AY	FIN	Finnair
100	AK	AXM	AirAsia
178	NH	ANA	All Nippon Airways
437	W1	W1	sun phuquoc airways
101	HU	CHH	Hainan Airlines
346	3S	BOX	DHL Air
347	FX	FDX	FedEx
918	TN	THT	Air Tahiti Nui
368	K6	KHV	Air Cambodia
53	OM	MGL	MIAT Mongolian Airlines
46	W2	FXT	Flexflight
722	QY	BCS	DHL Air
192	OZ	AAR	Asiana Airlines
608	KN	CUA	China United Airlines
9	TP	TAP	TAP Air Portugal
325	DE	CFG	Condor
55	GA	GIA	Garuda Indonesia
26	AS	JAG	AlphaSky
642	M0	MNG	Aero Mongolia
43	BA	BAW	British Airways
58	JL	JAL	Japan Airlines
169	KE	KAL	Korean Air
336	AC	ACA	Air Canada
377	LX	SWR	Swiss
2	6E	IGO	IndiGo
343	IL	TGN	Trigana Air
109	SU	AFL	Aeroflot
660	NS	HBH	Hebei Airlines
12	MU	CES	China Eastern Airlines
685	OQ	CQN	Chongqing Airlines
102	3U	CSC	Sichuan Airlines
724	D7	XAX	AirAsia
755	KJ	AIH	Air Zeta
796	2P	GAP	Philippine Airlines
344	IO	IAE	IrAero
716	5H	ABR	FedEx
96	UA	UAL	United Airlines
83	PX	ANG	Air Niugini
759	OI	HND	Hinterland Aviation
927	WS	WJA	WestJet
47	A1	A1	vietjet air
10	AF	AFR	Air France
410	JU	ASL	AirSERBIA
93	EY	ETD	Etihad Airways
440	AT	RAM	Royal Air Maroc
1225	FI	ICE	Icelandair
954	PR	PAL	Philippine Airlines
990	FZ	FDB	flydubai
1416	LS	EXS	Jet2
1417	CAO	CAO	Air China Cargo
1420	QN	SKP	Skytrans Australia
305	SV	SVA	Saudia
1620	CO	CNW	North-Western Cargo
1436	CG	TOK	PNG Air
1438	EW	EWG	Eurowings
1293	HT	CTJ	Tianjin Air Cargo
1294	DK	VKG	Sunclass Airlines
1299	TV	TBA	Tibet Airlines
1193	FY	FSQ	Fly Sky Airlines
1195	HM	SEY	Air Seychelles
1218	TS	TSC	Air Transat
1219	BI	RBA	Royal Brunei Airlines
1220	4O	AIJ	Interjet
1238	RJ	RJA	Royal Jordanian
952	KQ	KQA	Kenya Airways
1247	WB	RWD	RwandAir
1248	IB	IBE	Iberia
1185	5X	UPS	UPS
1346	HY	UZB	Uzbekistan Airways
1186	WY	OMA	Oman Air
1353	FM	CSH	Shanghai Airlines
1359	SA	SAA	South African Airways
1102	IE	SOL	Solomon Airlines
\.


--
-- Data for Name: airport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.airport (airport_id, iata, icao, name, timezone) FROM stdin;
148	DRW	YPDN	Darwin	Australia/Darwin
147	PKT	YPKT	Port Keats	Australia/Darwin
235	YNZ	ZSYN	Yancheng	Asia/Shanghai
167	PKX	ZBAD	Beijing Daxing International Airport	+8
4	SYD	YSSY	Sydney Kingsford Smith Airport	Australia/Sydney
89	WLS	NLWW	Wallis Island	Pacific/Wallis
90	FUT	NLWF	Futuna Island	Pacific/Wallis
14	TSV	YBTL	Townsville International	Australia/Brisbane
17	CMQ	YCMT	Clermont	Australia/Brisbane
18	ROK	YBRK	Rockhampton	Australia/Brisbane
20	BCN	LEBL	El Prat De Llobregat	Europe/Madrid
1	CGO	ZHCC	Zhengzhou	Asia/Shanghai
602	IST	LTFM	Istanbul Airport	Europe/Istanbul
212	UBN	ZMCK	New Ulaanbaator International Airport	\N
168	HGH	ZSHC	Hangzhou	Asia/Shanghai
285	VTE	VLVT	Wattay International Airport	Asia/Vientiane
325	TPE	RCTP	Taiwan Taoyuan International (Chiang Kai Shek International)	Asia/Taipei
186	WLG	NZWN	Wellington International	Pacific/Auckland
38	MUC	EDDM	Franz Josef Strauss	Europe/Berlin
141	HAN	VVNB	Noibai International	Asia/Ho_Chi_Minh
105	KGI	YPKG	Kalgoorlie	Australia/Perth
106	JAD	YPJT	Jandakot	Australia/Perth
166	SCO	UATE	Shevchenko	Asia/Aqtau
108	JFK	KJFK	John F Kennedy International	America/New_York
240	CRK	RPLC	Diosdado Macapagal International (Clark International)	Asia/Manila
1403	TAS	UZTT	Tashkent International	Asia/Tashkent
169	KVG	AYKV	Kavieng	Pacific/Port_Moresby
294	CXR	VVCR	Cam Ranh	Asia/Ho_Chi_Minh
170	RAB	AYTK	Rabaul Airport	\N
174	ZQN	NZQN	Queenstown	Pacific/Auckland
178	HFE	ZSOF	Shanghai	Asia/Shanghai
280	ROT	NZRO	Rotorua	Pacific/Auckland
153	NQZ	UACC	Astana	Asia/Almaty
19	PVG	ZSPD	Shanghai Pudong International	Asia/Shanghai
281	WEF	ZSWF	Weifang	Asia/Shanghai
355	TRV	VOTV	Thiruvananthapuram International	Asia/Kolkata
138	YVR	CYVR	Vancouver International	America/Vancouver
368	CTU	ZUUU	Shuangliu	Asia/Shanghai
206	VIE	LOWW	Vienna International	Europe/Vienna
310	SOQ	WASS	Jefman	Asia/Jayapura
149	MGT	YMGB	Milingimbi	Australia/Darwin
303	UPG	WAAA	Hasanudin	Asia/Makassar
1791	TLK	UECT	Talakan Airport	\N
292	HRB	ZYHB	Harbin	Asia/Shanghai
226	YNJ	ZYYJ	Yanji	Asia/Shanghai
64	DPS	WADD	Ngurah Rai International	Asia/Makassar
242	CEB	RPVM	Mactan-Cebu International	Asia/Manila
300	LHE	OPLA	Alama Iqbal International	Asia/Karachi
382	NTG	ZSNT	\N	\N
177	ZUH	ZGSD	Zhuhai Airport	Asia/Shanghai
268	BHE	NZWB	Woodbourne Air Station	Pacific/Auckland
330	NGO	RJGG	Chu-Bu Centrair International (Central Japan International)	Asia/Tokyo
308	CGK	WIII	Soekarno-Hatta International	Asia/Jakarta
15	BLR	VOBL	Bangalore International Airport	Asia/Kolkata
296	BSZ	UCFM	\N	\N
16	DEL	VIDP	Indira Gandhi International	Asia/Kolkata
304	BIK	WABB	Frans Kaisepo	Asia/Jayapura
351	UFA	UWUU	Ufa International Airport	Asia/Yekaterinburg
326	CJU	RKPC	Jeju Airport	Asia/Seoul
32	AKL	NZAA	Auckland International	Pacific/Auckland
2	GYD	UBBB	Heydar Aliyev International (Bina International)	Asia/Baku
352	HRG	HEGN	Hurghada	Africa/Cairo
314	MKQ	WAKK	Mopah	Asia/Jayapura
28	SIN	WSSS	Singapore Changi	Asia/Singapore
107	HKG	VHHH	Hong Kong International	Asia/Hong_Kong
202	RGN	VYYY	Mingaladon	Asia/Yangon
204	DMK	VTBD	Don Muang	Asia/Bangkok
214	SZX	ZGSZ	Shenzhen	Asia/Shanghai
208	FCO	LIRF	Leonardo Da Vinci (Fiumicino)	Europe/Rome
154	ALA	UAAA	Almaty	Asia/Almaty
366	ANC	PANC	Ted Stevens Anchorage International Airport	America/Anchorage
224	CAN	ZGGG	Guangzhou Baiyun International	Asia/Shanghai
172	POM	AYPY	Jackson Field	Pacific/Port_Moresby
249	WNZ	ZSWZ	Wenzhou	Asia/Shanghai
22	MEL	YMML	Melbourne - Tullamarine Airport	Australia/Melbourne
1401	NBX	WABI	Nabire	Asia/Jayapura
92	ICN	RKSI	Seoul (Incheon)	Asia/Seoul
116	NRT	RJAA	Narita International Airport	Asia/Tokyo
302	TBS	UGTB	Novo Alexeyevka International	Asia/Tbilisi
181	WUX	ZSWX	Wuxi	Asia/Shanghai
344	CJJ	RKTU	Cheongju	Asia/Seoul
328	PUS	RKPK	Gimhae	Asia/Seoul
3	BNE	YBBN	Brisbane International	Australia/Brisbane
353	TRZ	VOTR	Civil	Asia/Kolkata
140	URC	ZWWW	\N	\N
394	NKG	ZSNJ	Nanjing Lukou International Airport	Asia/Shanghai
358	HIA	ZSSH	Lianshui	Asia/Shanghai
91	SGN	VVTS	Tan Son Nhat International	Asia/Ho_Chi_Minh
201	TFU	ZUTF	Chengdu Tianfu International Airport	Asia/Chongqing
183	VVO	UHWW	Vladivostok	Asia/Vladivostok
400	SHE	ZYTX	Shenyang	Asia/Shanghai
396	BAR	ZJQH	\N	\N
357	TAO	ZSQD	Qingdao	Asia/Shanghai
318	DJJ	WAJJ	Sentani	Asia/Jayapura
104	MNL	RPLL	Ninoy Aquino International	Asia/Manila
247	WUH	ZHHH	Tianhe International	Asia/Shanghai
239	XMN	ZSAM	Xiamen	Asia/Shanghai
42	KUL	WMKK	Kuala Lumpur International Airport (klia)	Asia/Kuala_Lumpur
322	TIM	WAYY	Timika	Asia/Jayapura
720	LJG	ZPLJ	Lijiang	Asia/Shanghai
706	ASP	YBAS	Alice Springs	Australia/Darwin
1295	IFU	VREI	Ifuru Airport\r\n	\N
1296	DRV	VRMD	\N	\N
666	KJA	UNKL	Krasnojarsk	Asia/Krasnoyarsk
765	CAI	HECA	Cairo International Airport	Africa/Cairo
1297	ZIA	UUBW	Zhukovsky International Airport	\N
708	ZNE	YNWN	Newman	Australia/Perth
1298	DYU	UTDD	Dushanbe	Asia/Dushanbe
1222	PEK	ZBAA	Beijing Capital International	Asia/Shanghai
712	OKL	WAJO	Oksibil	Asia/Jayapura
716	TUO	NZAP	Taupo	Pacific/Auckland
692	BQS	UHBB	Blagoveschensk	Asia/Yakutsk
1299	YIA	WAHI	Yogyakarta International Airport	\N
782	GOI	VOGO	Goa International	Asia/Kolkata
772	DOH	OTHH	Doha International	Asia/Qatar
1302	BTH	WIDD	Hang Nadim	Asia/Jakarta
1201	RMO	LUKK	International Airport Chisinau	Europe/Chisinau
790	CDG	LFPG	Charles De Gaulle	Europe/Paris
802	HSC	ZGSG	\N	\N
836	LGW	EGKK	Gatwick	Europe/London
26	BKK	VTBS	Suvarnabhumi International	Asia/Bangkok
601	JED	OEJN	King Abdulaziz International	Asia/Riyadh
730	CKG	ZUCK	Chongqing Jiangbei International	Asia/Shanghai
819	SYX	ZJSY	Fenghuang International (Phoenix International)	Asia/Shanghai
794	CCU	VECC	Netaji Subhas Chandra	Asia/Kolkata
820	XUZ	ZSXZ	Xuzhou	Asia/Shanghai
814	LYI	ZSLY	Linyi	Asia/Shanghai
1210	YNT	ZSYT	Yantai	Asia/Shanghai
726	JNH	ZSJX	\N	\N
1328	JHG	ZPJH	\N	\N
1214	DCY	ZUDC	\N	\N
744	HPH	VVCI	Catbi	Asia/Ho_Chi_Minh
1378	WUZ	ZGWZ	Changzhoudao	Asia/Shanghai
1244	HAK	ZJHK	Haikou	Asia/Shanghai
768	MED	OEMA	Mohammad Bin Abdulaziz	Asia/Riyadh
674	CMB	VCBI	Bandaranaike International	Asia/Colombo
770	BEY	OLBA	Beirut Rafic Hariri Airport	Asia/Beirut
668	LIS	LPPT	Lisbon Portela	Europe/Lisbon
648	DLI	VVDL	Lienkhang	Asia/Ho_Chi_Minh
694	OVB	UNNT	Tolmachevo	Asia/Novosibirsk
1226	BHY	ZGBH	Beihai	Asia/Shanghai
620	ISB	OPIS	Islamabad International	Asia/Karachi
1232	LZH	ZGZH	Liuzhou	Asia/Shanghai
652	DXB	OMDB	Dubai	Asia/Dubai
665	AYT	LTAI	Antalya	Europe/Istanbul
680	MRU	FIMP	Sir Seewoosagur Ramgoolam International	Indian/Mauritius
1304	TRK	WAQQ	Juwata	Asia/Makassar
689	TMH	WAKT	Tanahmerah	Asia/Jayapura
1212	KOW	ZSGZ	Ganzhou	Asia/Shanghai
688	TLV	LLBG	Ben Gurion International	Asia/Jerusalem
685	DAC	VGHS	Zia International	Asia/Dhaka
1282	HET	ZBHH	Hohhot	Asia/Shanghai
684	MAN	EGCC	Manchester Airport	Europe/London
626	TNA	ZSJN	Jinan	Asia/Shanghai
633	HND	RJTT	Haneda Airport	Asia/Tokyo
699	PER	YPPH	Perth International	Australia/Perth
687	CGN	EDDK	Cologne/bonn	Europe/Berlin
604	ELQ	OEGS	Gassim Regional Airport	Asia/Riyadh
696	BRU	EBBR	Brussels Airport	Europe/Brussels
1254	DOY	ZSDY	Dongying	Asia/Shanghai
1258	LZY	ZUNZ	Nyingchi	Asia/Shanghai
1262	GZG	ZUGZ	Garze Gesar Airport	\N
1313	AXJ	RJDA	Amakusa Airfield\r\n	\N
632	ATL	KATL	Hartsfield-jackson Atlanta International	America/New_York
616	SAW	LTFJ	Sabiha Gokcen	Europe/Istanbul
883	JNB	FAOR	Oliver Reginald Tambo International (Jan Smuts International)	Africa/Johannesburg
658	AUH	OMAA	Abu Dhabi International	Asia/Dubai
634	NGS	RJFU	Nagasaki	Asia/Tokyo
670	BOM	VABB	Chhatrapati Shivaji International (Sahar International)	Asia/Kolkata
650	FKQ	WASF	Fak Fak	Asia/Jayapura
1264	KHN	ZSCN	Nanchang	Asia/Shanghai
1266	YIN	ZWYN	Yining	Asia/Shanghai
1344	XIY	ZLXY	Xianyang	Asia/Shanghai
1270	YTY	ZSYA	Taizhou	Asia/Shanghai
878	PQC	VVPQ	Duong Dong	Asia/Ho_Chi_Minh
1216	KTM	VNKT	Tribhuvan International	Asia/Kathmandu
678	MLE	VRMM	Malé International Airport	Indian/Maldives
1218	SHA	ZSSS	Shanghai Hongqiao International	Asia/Shanghai
1314	KMJ	RJFT	Kumamoto	Asia/Tokyo
618	TUU	OETB	Tabuk	Asia/Riyadh
1308	LNU	WALM	Robert Atty Bessing Airport	\N
798	LHR	EGLL	Heathrow	Europe/London
1294	ERL	ZBER	Saiwusu International	Asia/Shanghai
1303	BPN	WALL	Sultan Aji Muhamad Sulaiman Airport\r\n	\N
1310	SUB	WARR	Juanda	Asia/Jakarta
1324	HLD	ZBLA	Hailar	Asia/Shanghai
1278	FOC	ZSFZ	Fuzhou	Asia/Shanghai
1346	JGN	ZLJQ	Jiayuguan	Asia/Shanghai
1280	XNN	ZLXN	Xining	Asia/Shanghai
1352	CIH	ZBCZ	Changzhi	Asia/Shanghai
1228	CSX	ZGHA	Changsha	Asia/Shanghai
1358	LCX	ZSLD	\N	\N
1256	CGQ	ZYCC	Changchun	Asia/Shanghai
1354	KMG	ZPPP	Kunming	Asia/Shanghai
1370	KWL	ZGKL	Guilin	Asia/Shanghai
700	HKT	VTSP	Phuket International	Asia/Bangkok
1376	NZL	ZBZL	Chengjisihan Airport	\N
1380	NNG	ZGNN	\N	\N
1382	KWE	ZUGY	Guiyang	Asia/Shanghai
1388	ENH	ZHES	Enshi	Asia/Shanghai
1392	YIW	ZSYW	Yiwu	Asia/Shanghai
1394	YSQ	ZYSQ	\N	\N
1396	SWA	ZGOW	Shantou	Asia/Shanghai
1400	SVO	UUEE	Sheremetyevo International	Europe/Moscow
1798	MAA	VOMM	Madras International (Meenambakkam)	Asia/Kolkata
1822	MIG	ZUMY	Mian Yang	Asia/Shanghai
1838	PHE	YPPD	Port Hedland	Australia/Perth
1436	LGG	EBLG	Liege Airport	Europe/Brussels
2666	KTA	YPKA	Karratha	Australia/Perth
1440	MKW	WAUU	Rendani	Asia/Jayapura
1447	LEJ	EDDP	Halle	Europe/Berlin
1435	MXP	LIMC	Milano Malpensa	Europe/Rome
1450	KTI	VDTI	Techo International Airport	Asia/Phnom_Penh
2677	PNQ	VAPO	Lohegaon	Asia/Kolkata
2688	NGB	ZSNB	Lishe International Airport	Asia/Shanghai
2712	OKA	ROAH	Naha	Asia/Tokyo
2718	CTS	RJCC	Chitose	Asia/Tokyo
1473	HTI	YBHM	Hamilton Island	Australia/Lindeman
884	NBO	HKJK	Jomo Kenyatta International	Africa/Nairobi
1888	MRZ	YMOR	Moree	Australia/Sydney
614	RUH	OERK	King Khaled International	Asia/Riyadh
2745	CHY	AGGC	Choiseul Bay	Pacific/Guadalcanal
2210	GZO	AGGN	Gizo	Pacific/Guadalcanal
1864	DAD	VVDN	Da Nang	Asia/Ho_Chi_Minh
2752	VCA	VVCT	Can Tho	Asia/Ho_Chi_Minh
1920	KHI	OPKC	Quaid-e-azam International	Asia/Karachi
2758	HIJ	RJOA	Hiroshima Airport	Asia/Tokyo
2764	BMV	VVBM	Phung-Duc	Asia/Ho_Chi_Minh
1956	FUK	RJFF	Fukuoka	Asia/Tokyo
1521	KWM	YKOW	Kowanyama	Australia/Brisbane
1522	EDR	YPMP	Edward River	Australia/Brisbane
1985	BTS	LZIB	M. R. Štefánika	Europe/Bratislava
1988	THS	VTPO	Sukhothai	Asia/Bangkok
2208	SCZ	AGGL	Santa Cruz Island	Pacific/Guadalcanal
2207	HIR	AGGH	Henderson International	Pacific/Guadalcanal
2212	RNL	AGGR	Rennell	Pacific/Guadalcanal
1866	KHH	RCKH	Kaoshiung International Airport	Asia/Taipei
2225	GDX	UHMM	Magadan	Asia/Magadan
691	PKC	UHPP	Petropavlovsk-Kamchatsky	Asia/Kamchatka
1429	OKI	RJNO	Oki Island	Asia/Tokyo
1430	IZO	RJOC	Izumo	Asia/Tokyo
1431	SUV	NFNA	Nausori	Pacific/Fiji
1432	NAN	NFFN	Nadi International	Pacific/Fiji
1974	SEZ	FSIA	Seychelles International Airport	Indian/Mahe
2506	CMN	GMMN	Mohamed V	Africa/Casablanca
118	KIX	RJBB	Kansai International	Asia/Tokyo
2556	MAD	LEMD	Barajas	Europe/Madrid
2564	PDG	WIEE	Minangkabau International Airport	Asia/Jakarta
766	FRA	EDDF	Frankfurt International Airport	Europe/Berlin
2834	LPL	EGGP	Liverpool John Lennon	Europe/London
2843	LDH	YLHI	Lord Howe Island	Australia/Lord_Howe
2852	ADD	HAAB	Bole International	Africa/Addis_Ababa
3244	JJN	ZSQZ	Jinjiang	Asia/Shanghai
2870	AKJ	RJEC	Asahikawa	Asia/Tokyo
2875	GUR	AYGN	Gurney	Pacific/Port_Moresby
2591	CPH	EKCH	Kastrup	Europe/Copenhagen
2592	ARN	ESSA	Arlanda	Europe/Stockholm
2644	AAT	ZWAT	Altay	Asia/Shanghai
\.


--
-- Data for Name: arrival; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.arrival (flight_id, terminal, gate, baggage, delay, scheduled, estimated, actual, estimated_runway, actual_runway) FROM stdin;
1	\N	\N	\N	\N	2026-10-26 06:37:00+01	\N	\N	\N	\N
2	3	13	Q4	\N	2026-10-26 10:25:00+01	\N	\N	\N	\N
3	3	13	Q4	\N	2026-10-26 10:25:00+01	\N	\N	\N	\N
4	3	13	Q4	\N	2026-10-26 10:25:00+01	\N	\N	\N	\N
5	3	13	Q4	\N	2026-10-26 10:25:00+01	\N	\N	\N	\N
6	2	40	D2	\N	2026-10-26 10:10:00+01	\N	\N	\N	\N
7	\N	3	\N	\N	2026-10-26 09:35:00+01	\N	\N	\N	\N
8	3	\N	03	\N	2026-10-26 04:10:00+01	\N	\N	\N	\N
9	\N	\N	\N	\N	2026-10-26 03:34:00+01	\N	\N	\N	\N
10	1	\N	\N	\N	2026-10-26 08:25:00+01	\N	\N	\N	\N
11	2	18	7	\N	2026-10-26 15:05:00+01	\N	\N	\N	\N
12	2	18	7	\N	2026-10-26 15:05:00+01	\N	\N	\N	\N
13	\N	\N	\N	\N	2026-10-26 05:05:00+01	\N	\N	\N	\N
14	\N	\N	\N	\N	2026-10-26 07:00:00+01	\N	\N	\N	\N
15	\N	\N	\N	\N	2026-10-26 07:00:00+01	\N	\N	\N	\N
16	I	9	6	\N	2026-10-26 17:35:00+01	\N	\N	\N	\N
17	1	33	13	\N	2026-10-26 14:35:00+01	\N	\N	\N	\N
18	1	33	13	\N	2026-10-26 14:35:00+01	\N	\N	\N	\N
19	2	M15	\N	\N	2026-10-26 07:35:00+01	\N	\N	\N	\N
20	2	M15	\N	\N	2026-10-26 07:35:00+01	\N	\N	\N	\N
21	1	\N	\N	\N	2026-10-26 06:40:00+01	\N	\N	\N	\N
22	D	\N	D02	\N	2026-10-26 09:15:00+01	\N	\N	\N	\N
23	D	\N	D02	\N	2026-10-26 09:15:00+01	\N	\N	\N	\N
24	D	\N	D02	\N	2026-10-26 09:15:00+01	\N	\N	\N	\N
25	D	\N	D02	\N	2026-10-26 09:15:00+01	\N	\N	\N	\N
26	D	\N	D02	\N	2026-10-26 09:15:00+01	\N	\N	\N	\N
27	3	7	Q3	\N	2026-10-26 09:35:00+01	\N	\N	\N	\N
28	3	7	Q3	\N	2026-10-26 09:35:00+01	\N	\N	\N	\N
29	3	7	Q3	\N	2026-10-26 09:35:00+01	\N	\N	\N	\N
30	3	7	Q3	\N	2026-10-26 09:35:00+01	\N	\N	\N	\N
31	3	7	Q3	\N	2026-10-26 09:35:00+01	\N	\N	\N	\N
32	I	\N	\N	\N	2026-10-26 11:00:00+01	\N	\N	\N	\N
33	I	\N	\N	\N	2026-10-26 11:00:00+01	\N	\N	\N	\N
34	I	\N	\N	\N	2026-10-26 11:00:00+01	\N	\N	\N	\N
35	I	\N	\N	\N	2026-10-26 11:00:00+01	\N	\N	\N	\N
36	I	\N	\N	\N	2026-10-26 11:00:00+01	\N	\N	\N	\N
37	I	\N	\N	\N	2026-10-26 11:00:00+01	\N	\N	\N	\N
38	3	1	Q3	\N	2026-10-26 09:15:00+01	\N	\N	\N	\N
39	3	1	Q3	\N	2026-10-26 09:15:00+01	\N	\N	\N	\N
40	3	1	Q3	\N	2026-10-26 09:15:00+01	\N	\N	\N	\N
41	3	1	Q3	\N	2026-10-26 09:15:00+01	\N	\N	\N	\N
42	3	1	Q3	\N	2026-10-26 09:15:00+01	\N	\N	\N	\N
43	3	1	Q3	\N	2026-10-26 09:15:00+01	\N	\N	\N	\N
44	3	1	Q3	\N	2026-10-26 09:15:00+01	\N	\N	\N	\N
45	\N	\N	\N	\N	2026-10-26 09:30:00+01	\N	\N	\N	\N
46	1	129	13	\N	2026-10-26 10:50:00+01	\N	\N	\N	\N
47	1	129	13	\N	2026-10-26 10:50:00+01	\N	\N	\N	\N
48	1	129	13	\N	2026-10-26 10:50:00+01	\N	\N	\N	\N
49	\N	\N	\N	\N	2026-10-26 07:25:00+01	\N	\N	\N	\N
50	I	9	1	\N	2026-10-26 13:20:00+01	\N	\N	\N	\N
51	I	9	1	\N	2026-10-26 13:20:00+01	\N	\N	\N	\N
52	1	\N	\N	\N	2026-10-26 05:35:00+01	\N	\N	\N	\N
53	\N	\N	\N	\N	2026-10-26 02:54:00+01	\N	\N	\N	\N
54	8	\N	\N	\N	2026-10-26 06:45:00+01	\N	\N	\N	\N
55	8	\N	\N	\N	2026-10-26 06:45:00+01	\N	\N	\N	\N
56	8	\N	\N	\N	2026-10-26 06:45:00+01	\N	\N	\N	\N
57	I	\N	\N	\N	2026-10-26 08:05:00+01	\N	\N	\N	\N
58	1	\N	\N	\N	2026-10-26 08:15:00+01	\N	\N	\N	\N
59	1	\N	5	\N	2026-10-26 07:20:00+01	\N	\N	\N	\N
60	1	\N	5	\N	2026-10-26 07:20:00+01	\N	\N	\N	\N
61	4	\N	\N	\N	2026-10-26 06:40:00+01	\N	\N	\N	\N
62	4	\N	\N	\N	2026-10-26 06:40:00+01	\N	\N	\N	\N
63	4	\N	\N	\N	2026-10-26 06:40:00+01	\N	\N	\N	\N
64	4	\N	\N	\N	2026-10-26 06:40:00+01	\N	\N	\N	\N
65	2	72	\N	\N	2026-10-26 07:30:00+01	\N	\N	\N	\N
66	2	72	\N	\N	2026-10-26 07:30:00+01	\N	\N	\N	\N
67	2	72	\N	\N	2026-10-26 07:30:00+01	\N	\N	\N	\N
68	2	72	\N	\N	2026-10-26 07:30:00+01	\N	\N	\N	\N
69	M	\N	22	\N	2026-10-25 22:35:00+01	\N	\N	\N	\N
70	4	\N	\N	\N	2026-10-26 08:00:00+01	\N	\N	\N	\N
71	1	117	12	\N	2026-10-26 08:55:00+01	\N	\N	\N	\N
72	1	117	12	\N	2026-10-26 08:55:00+01	\N	\N	\N	\N
73	1	\N	\N	\N	2026-10-26 08:50:00+01	\N	\N	\N	\N
74	\N	\N	\N	\N	2026-10-26 03:04:00+01	\N	\N	\N	\N
75	\N	\N	\N	\N	2026-10-26 02:26:00+01	\N	\N	\N	\N
76	\N	\N	\N	\N	2026-10-26 01:54:00+01	\N	\N	\N	\N
77	1	\N	\N	\N	2026-10-26 04:55:00+01	\N	\N	\N	\N
78	1	\N	\N	\N	2026-10-26 05:20:00+01	\N	\N	\N	\N
79	1	\N	\N	\N	2026-10-26 05:20:00+01	\N	\N	\N	\N
80	1	\N	\N	\N	2026-10-26 05:20:00+01	\N	\N	\N	\N
81	3	\N	\N	\N	2026-10-26 08:00:00+01	\N	\N	\N	\N
82	3	\N	\N	\N	2026-10-26 08:00:00+01	\N	\N	\N	\N
83	\N	\N	\N	\N	2026-10-26 05:00:00+01	\N	\N	\N	\N
84	\N	\N	\N	\N	2026-10-26 08:10:00+01	\N	\N	\N	\N
85	\N	\N	\N	\N	2026-10-26 07:35:00+01	\N	\N	\N	\N
86	D	\N	\N	\N	2026-10-26 09:25:00+01	\N	\N	\N	\N
87	\N	4	\N	\N	2026-10-26 11:05:00+01	\N	\N	\N	\N
88	\N	4	\N	\N	2026-10-26 11:05:00+01	\N	\N	\N	\N
89	\N	\N	\N	\N	2026-10-26 07:45:00+01	\N	\N	\N	\N
90	\N	\N	\N	\N	2026-10-26 07:50:00+01	\N	\N	\N	\N
91	\N	\N	\N	\N	2026-10-26 06:35:00+01	\N	\N	\N	\N
92	\N	\N	\N	\N	2026-10-26 08:35:00+01	\N	\N	\N	\N
93	\N	13	\N	\N	2026-10-26 11:05:00+01	\N	\N	\N	\N
94	\N	13	\N	\N	2026-10-26 11:05:00+01	\N	\N	\N	\N
95	\N	13	\N	\N	2026-10-26 11:05:00+01	\N	\N	\N	\N
96	\N	13	\N	\N	2026-10-26 11:05:00+01	\N	\N	\N	\N
97	\N	13	\N	\N	2026-10-26 11:05:00+01	\N	\N	\N	\N
98	\N	16	\N	\N	2026-10-26 10:25:00+01	\N	\N	\N	\N
99	\N	16	\N	\N	2026-10-26 10:25:00+01	\N	\N	\N	\N
100	\N	16	\N	\N	2026-10-26 10:25:00+01	\N	\N	\N	\N
399	2	\N	\N	\N	2026-11-03 06:35:00+01	\N	\N	\N	\N
400	3	\N	17	\N	2026-11-03 11:55:00+01	\N	\N	\N	\N
401	1	48	17	\N	2026-11-03 14:30:00+01	\N	\N	\N	\N
402	3	\N	\N	\N	2026-11-03 12:25:00+01	\N	\N	\N	\N
403	T2	\N	4	\N	2026-11-03 12:30:00+01	\N	\N	\N	\N
404	T2	\N	\N	\N	2026-11-03 11:55:00+01	\N	\N	\N	\N
405	\N	\N	\N	\N	2026-11-03 11:00:00+01	\N	\N	\N	\N
406	I	\N	\N	\N	2026-11-03 11:30:00+01	\N	\N	\N	\N
407	2	\N	26	\N	2026-11-03 12:15:00+01	\N	\N	\N	\N
408	\N	\N	\N	\N	2026-11-03 12:35:00+01	\N	\N	\N	\N
409	2	\N	14	\N	2026-11-03 12:45:00+01	\N	\N	\N	\N
410	\N	\N	\N	\N	2026-11-03 12:15:00+01	\N	\N	\N	\N
411	\N	\N	3	\N	2026-11-03 11:55:00+01	\N	\N	\N	\N
412	1	\N	\N	\N	2026-11-03 11:55:00+01	\N	\N	\N	\N
413	\N	\N	\N	\N	2026-11-03 12:40:00+01	\N	\N	\N	\N
414	\N	\N	2	\N	2026-11-03 11:45:00+01	\N	\N	\N	\N
415	1	\N	\N	\N	2026-11-03 11:45:00+01	\N	\N	\N	\N
416	\N	\N	\N	\N	2026-11-03 11:55:00+01	\N	\N	\N	\N
417	T2	\N	\N	\N	2026-11-03 11:55:00+01	\N	\N	\N	\N
418	\N	\N	\N	\N	2026-11-03 11:55:00+01	\N	\N	\N	\N
419	T3	\N	10	\N	2026-11-03 11:55:00+01	\N	\N	\N	\N
420	1	\N	5	\N	2026-11-03 11:30:00+01	\N	\N	\N	\N
421	2	\N	25	\N	2026-11-03 12:00:00+01	\N	\N	\N	\N
422	3	\N	62	\N	2026-11-03 11:55:00+01	\N	\N	\N	\N
423	3	\N	\N	\N	2026-11-03 12:20:00+01	\N	\N	\N	\N
424	T3	\N	\N	\N	2026-11-03 12:40:00+01	\N	\N	\N	\N
425	\N	\N	\N	\N	2026-11-03 11:45:00+01	\N	\N	\N	\N
426	2	\N	5	\N	2026-11-03 13:10:00+01	\N	\N	\N	\N
427	\N	\N	\N	\N	2026-11-03 11:55:00+01	\N	\N	\N	\N
428	1	16	7	\N	2026-11-03 13:55:00+01	\N	\N	\N	\N
429	\N	\N	\N	\N	2026-11-03 10:40:00+01	\N	\N	\N	\N
430	T2	\N	\N	\N	2026-11-03 11:15:00+01	\N	\N	\N	\N
431	\N	\N	\N	\N	2026-11-03 13:55:00+01	\N	\N	\N	\N
432	1	\N	\N	\N	2026-11-03 11:00:00+01	\N	\N	\N	\N
433	\N	\N	\N	\N	2026-11-03 11:40:00+01	\N	\N	\N	\N
434	\N	\N	\N	\N	2026-11-03 10:40:00+01	\N	\N	\N	\N
435	4	73	\N	\N	2026-11-03 11:50:00+01	\N	\N	\N	\N
436	3	\N	\N	\N	2026-11-03 11:45:00+01	\N	\N	\N	\N
437	1	\N	\N	\N	2026-11-03 11:40:00+01	\N	\N	\N	\N
438	T3	\N	\N	\N	2026-11-03 10:55:00+01	\N	\N	\N	\N
439	\N	\N	\N	\N	2026-11-03 11:30:00+01	\N	\N	\N	\N
440	4	\N	\N	\N	2026-11-03 11:40:00+01	\N	\N	\N	\N
441	\N	\N	\N	\N	2026-11-03 11:30:00+01	\N	\N	\N	\N
442	1	24	\N	\N	2026-11-03 15:30:00+01	\N	\N	\N	\N
443	2	88	\N	\N	2026-11-03 15:30:00+01	\N	\N	\N	\N
445	\N	\N	\N	\N	2026-11-03 11:00:00+01	\N	\N	\N	\N
446	\N	\N	\N	\N	2026-11-03 07:15:00+01	\N	\N	\N	\N
447	\N	\N	\N	\N	2026-11-03 10:50:00+01	\N	\N	\N	\N
448	2	\N	\N	\N	2026-11-03 10:05:00+01	\N	\N	\N	\N
449	\N	\N	\N	\N	2026-11-03 10:35:00+01	\N	\N	\N	\N
450	\N	\N	\N	\N	2026-11-03 11:10:00+01	\N	\N	\N	\N
451	2	\N	\N	\N	2026-11-03 10:55:00+01	\N	\N	\N	\N
452	\N	\N	\N	\N	2026-11-03 11:15:00+01	\N	\N	\N	\N
453	1	\N	\N	\N	2026-11-03 09:45:00+01	\N	\N	\N	\N
690	\N	\N	11	\N	2026-11-03 09:25:00+01	\N	\N	\N	\N
455	\N	\N	\N	\N	2026-11-03 11:15:00+01	\N	\N	\N	\N
691	\N	\N	11	\N	2026-11-03 09:25:00+01	\N	\N	\N	\N
692	2	\N	\N	\N	2026-11-03 09:45:00+01	\N	\N	\N	\N
458	\N	\N	\N	\N	2026-11-03 13:35:00+01	\N	\N	\N	\N
459	\N	\N	\N	\N	2026-11-03 14:30:00+01	\N	\N	\N	\N
460	\N	\N	\N	\N	2026-11-03 12:20:00+01	\N	\N	\N	\N
461	2	\N	\N	\N	2026-11-03 12:55:00+01	\N	\N	\N	\N
462	\N	\N	\N	\N	2026-11-03 13:55:00+01	\N	\N	\N	\N
463	1	\N	\N	\N	2026-11-03 12:55:00+01	\N	\N	\N	\N
464	2	\N	\N	\N	2026-11-03 12:55:00+01	\N	\N	\N	\N
465	2	\N	\N	\N	2026-11-03 12:10:00+01	\N	\N	\N	\N
466	1	\N	\N	\N	2026-11-03 12:55:00+01	\N	\N	\N	\N
467	3	\N	\N	\N	2026-11-03 14:35:00+01	\N	\N	\N	\N
468	\N	\N	\N	\N	2026-11-03 13:20:00+01	\N	\N	\N	\N
469	\N	\N	\N	\N	2026-11-03 12:05:00+01	\N	\N	\N	\N
470	5	\N	\N	\N	2026-11-03 11:55:00+01	\N	\N	\N	\N
471	T2	\N	\N	\N	2026-11-03 13:10:00+01	\N	\N	\N	\N
472	3	\N	\N	\N	2026-11-03 11:55:00+01	\N	\N	\N	\N
473	T3	\N	\N	\N	2026-11-03 12:25:00+01	\N	\N	\N	\N
474	\N	\N	\N	\N	2026-11-03 10:55:00+01	\N	\N	\N	\N
475	\N	\N	\N	\N	2026-11-03 13:10:00+01	\N	\N	\N	\N
476	2	\N	\N	\N	2026-11-03 12:15:00+01	\N	\N	\N	\N
477	\N	\N	\N	\N	2026-11-03 12:20:00+01	\N	\N	\N	\N
478	3	3	\N	\N	2026-11-03 12:30:00+01	\N	\N	\N	\N
479	4	\N	\N	\N	2026-11-03 11:35:00+01	\N	\N	\N	\N
480	5	\N	\N	\N	2026-11-03 11:40:00+01	\N	\N	\N	\N
481	2	\N	4	\N	2026-11-03 11:30:00+01	\N	\N	\N	\N
482	\N	\N	11	\N	2026-11-03 12:55:00+01	\N	\N	\N	\N
483	2	\N	4	\N	2026-11-03 12:30:00+01	\N	\N	\N	\N
484	2	\N	34	\N	2026-11-03 12:45:00+01	\N	\N	\N	\N
485	T3	\N	\N	\N	2026-11-03 12:15:00+01	\N	\N	\N	\N
486	\N	\N	\N	\N	2026-11-03 11:35:00+01	\N	\N	\N	\N
487	\N	\N	\N	\N	2026-11-03 13:00:00+01	\N	\N	\N	\N
488	T2	\N	4	\N	2026-11-03 12:50:00+01	\N	\N	\N	\N
489	2	\N	\N	\N	2026-11-03 12:05:00+01	\N	\N	\N	\N
490	3	\N	67	\N	2026-11-03 12:30:00+01	\N	\N	\N	\N
491	1	\N	\N	\N	2026-11-03 12:40:00+01	\N	\N	\N	\N
492	\N	\N	\N	\N	2026-11-03 11:45:00+01	\N	\N	\N	\N
493	3	\N	\N	\N	2026-11-03 11:25:00+01	\N	\N	\N	\N
494	\N	\N	\N	\N	2026-11-03 11:25:00+01	\N	\N	\N	\N
495	\N	\N	\N	\N	2026-11-03 11:05:00+01	\N	\N	\N	\N
496	\N	\N	\N	\N	2026-11-03 12:15:00+01	\N	\N	\N	\N
693	2	\N	\N	\N	2026-11-03 09:45:00+01	\N	\N	\N	\N
498	C	\N	\N	\N	2026-11-03 08:55:00+01	\N	\N	\N	\N
694	2	\N	\N	\N	2026-11-03 09:45:00+01	\N	\N	\N	\N
695	I	\N	2	\N	2026-11-03 10:30:00+01	\N	\N	\N	\N
696	I	\N	2	\N	2026-11-03 10:30:00+01	\N	\N	\N	\N
697	I	\N	2	\N	2026-11-03 10:30:00+01	\N	\N	\N	\N
698	\N	\N	\N	\N	2026-11-03 09:15:00+01	\N	\N	\N	\N
699	1	54	\N	\N	2026-11-03 15:30:00+01	\N	\N	\N	\N
700	1	54	\N	\N	2026-11-03 15:30:00+01	\N	\N	\N	\N
701	1	54	\N	\N	2026-11-03 15:30:00+01	\N	\N	\N	\N
702	I	\N	\N	\N	2026-11-03 11:00:00+01	\N	\N	\N	\N
703	1	\N	\N	\N	2026-11-03 09:50:00+01	\N	\N	\N	\N
515	\N	\N	\N	0	2026-11-03 07:30:00+01	2026-11-03 07:22:00+01	\N	2026-11-03 07:22:00+01	\N
704	T2	\N	\N	\N	2026-11-03 10:55:00+01	\N	\N	\N	\N
524	1	\N	8	\N	2026-11-03 10:45:00+01	\N	\N	\N	\N
525	1	\N	\N	\N	2026-11-03 09:15:00+01	\N	\N	\N	\N
705	\N	\N	\N	\N	2026-11-03 11:45:00+01	\N	\N	\N	\N
706	\N	\N	\N	\N	2026-11-03 11:45:00+01	\N	\N	\N	\N
707	\N	\N	\N	\N	2026-11-03 11:45:00+01	\N	\N	\N	\N
708	1	\N	\N	\N	2026-11-03 16:15:00+01	\N	\N	\N	\N
709	1	\N	\N	\N	2026-11-03 16:15:00+01	\N	\N	\N	\N
710	1	\N	\N	\N	2026-11-03 16:15:00+01	\N	\N	\N	\N
711	1	\N	\N	\N	2026-11-03 16:15:00+01	\N	\N	\N	\N
712	\N	\N	\N	\N	2026-11-03 11:40:00+01	\N	\N	\N	\N
713	3	8	Q2	\N	2026-11-03 16:20:00+01	\N	\N	\N	\N
714	3	8	Q2	\N	2026-11-03 16:20:00+01	\N	\N	\N	\N
715	3	8	Q2	\N	2026-11-03 16:20:00+01	\N	\N	\N	\N
716	3	8	Q2	\N	2026-11-03 16:20:00+01	\N	\N	\N	\N
509	\N	\N	\N	\N	2026-11-03 13:30:00+01	\N	\N	\N	\N
720	2	93	\N	\N	2026-11-03 16:25:00+01	\N	\N	\N	\N
721	2	93	\N	\N	2026-11-03 16:25:00+01	\N	\N	\N	\N
722	2	93	\N	\N	2026-11-03 16:25:00+01	\N	\N	\N	\N
723	2	93	\N	\N	2026-11-03 16:25:00+01	\N	\N	\N	\N
724	1	\N	\N	\N	2026-11-03 10:05:00+01	\N	\N	\N	\N
725	I	31	\N	\N	2026-11-03 12:45:00+01	\N	\N	\N	\N
726	I	31	\N	\N	2026-11-03 12:45:00+01	\N	\N	\N	\N
727	I	31	\N	\N	2026-11-03 12:45:00+01	\N	\N	\N	\N
510	\N	\N	\N	\N	2026-11-03 09:15:00+01	\N	\N	\N	\N
512	\N	\N	\N	\N	2026-11-03 11:40:00+01	\N	\N	\N	\N
730	3	8	Q2	\N	2026-11-03 16:20:00+01	\N	\N	\N	\N
513	\N	\N	\N	\N	2026-11-03 11:30:00+01	\N	\N	\N	\N
514	\N	\N	\N	\N	2026-11-03 08:00:00+01	\N	\N	\N	\N
516	\N	\N	\N	\N	2026-11-03 03:23:00+01	\N	\N	\N	\N
518	\N	\N	\N	\N	2026-11-03 09:35:00+01	\N	\N	\N	\N
555	T2	\N	\N	83	2026-11-03 04:30:00+01	2026-11-03 05:53:00+01	\N	2026-11-03 05:53:00+01	\N
735	\N	\N	\N	\N	2026-11-03 10:40:00+01	\N	\N	\N	\N
519	\N	\N	\N	\N	2026-11-03 09:00:00+01	\N	\N	\N	\N
520	\N	\N	\N	\N	2026-11-03 08:40:00+01	\N	\N	\N	\N
521	\N	\N	\N	\N	2026-11-03 08:40:00+01	\N	\N	\N	\N
522	T1	\N	\N	\N	2026-11-03 03:05:00+01	\N	\N	\N	\N
523	\N	\N	6	\N	2026-11-03 10:40:00+01	\N	\N	\N	\N
535	3	8	2	\N	2026-11-03 15:15:00+01	\N	\N	\N	\N
742	1	\N	A11	\N	2026-11-03 06:40:00+01	\N	\N	\N	\N
743	1	\N	A11	\N	2026-11-03 06:40:00+01	\N	\N	\N	\N
744	1	\N	A11	\N	2026-11-03 06:40:00+01	\N	\N	\N	\N
745	1	\N	\N	\N	2026-11-03 20:00:00+01	\N	\N	\N	\N
746	3	\N	\N	\N	2026-11-03 06:25:00+01	\N	\N	\N	\N
747	M	\N	\N	\N	2026-11-03 10:45:00+01	\N	\N	\N	\N
748	3	\N	\N	\N	2026-11-03 05:25:00+01	\N	\N	\N	\N
749	M	\N	\N	\N	2026-11-03 09:30:00+01	\N	\N	\N	\N
750	\N	\N	\N	\N	2026-11-03 15:25:00+01	\N	\N	\N	\N
752	3	8	2	\N	2026-11-03 15:15:00+01	\N	\N	\N	\N
575	\N	\N	\N	\N	2026-11-03 02:38:00+01	\N	\N	\N	\N
753	3	8	2	\N	2026-11-03 15:15:00+01	\N	\N	\N	\N
754	3	8	2	\N	2026-11-03 15:15:00+01	\N	\N	\N	\N
755	\N	\N	\N	\N	2026-11-03 11:35:00+01	\N	\N	\N	\N
756	1	B5	3	\N	2026-11-03 11:10:00+01	\N	\N	\N	\N
757	3	\N	41	\N	2026-11-03 12:55:00+01	\N	\N	\N	\N
758	I	\N	5	\N	2026-11-03 12:20:00+01	\N	\N	\N	\N
759	I	\N	5	\N	2026-11-03 12:20:00+01	\N	\N	\N	\N
760	2	\N	\N	\N	2026-11-03 12:10:00+01	\N	\N	\N	\N
761	2	\N	\N	\N	2026-11-03 12:10:00+01	\N	\N	\N	\N
762	2	\N	\N	\N	2026-11-03 12:10:00+01	\N	\N	\N	\N
763	2	\N	\N	\N	2026-11-03 12:10:00+01	\N	\N	\N	\N
764	2	\N	\N	\N	2026-11-03 12:10:00+01	\N	\N	\N	\N
765	1	\N	5	\N	2026-11-03 13:45:00+01	\N	\N	\N	\N
766	1	\N	5	\N	2026-11-03 13:45:00+01	\N	\N	\N	\N
767	I	\N	\N	\N	2026-11-03 13:25:00+01	\N	\N	\N	\N
559	\N	\N	\N	\N	2026-11-03 10:45:00+01	\N	\N	\N	\N
689	\N	\N	\N	\N	2026-11-03 11:15:00+01	\N	\N	\N	\N
500	\N	\N	\N	\N	2026-11-03 05:56:00+01	\N	\N	\N	\N
883	\N	\N	\N	\N	2026-11-03 05:15:00+01	\N	\N	\N	\N
887	\N	\N	\N	\N	2026-11-03 14:05:00+01	\N	\N	\N	\N
768	2	\N	\N	\N	2026-11-03 14:10:00+01	\N	\N	\N	\N
769	2	\N	\N	\N	2026-11-03 14:10:00+01	\N	\N	\N	\N
770	2	\N	\N	\N	2026-11-03 14:10:00+01	\N	\N	\N	\N
771	1	\N	\N	\N	2026-11-03 10:10:00+01	\N	\N	\N	\N
772	3	\N	\N	\N	2026-11-03 10:25:00+01	\N	\N	\N	\N
773	3	\N	\N	\N	2026-11-03 10:15:00+01	\N	\N	\N	\N
775	I	\N	\N	\N	2026-11-03 08:05:00+01	\N	\N	\N	\N
776	I	\N	\N	\N	2026-11-03 08:05:00+01	\N	\N	\N	\N
777	I	\N	\N	\N	2026-11-03 08:05:00+01	\N	\N	\N	\N
778	I	\N	\N	\N	2026-11-03 08:05:00+01	\N	\N	\N	\N
779	I	\N	\N	\N	2026-11-03 08:05:00+01	\N	\N	\N	\N
780	I	\N	\N	\N	2026-11-03 16:25:00+01	\N	\N	\N	\N
781	\N	\N	\N	\N	2026-11-03 03:50:00+01	\N	\N	\N	\N
782	\N	\N	\N	\N	2026-11-03 09:20:00+01	\N	\N	\N	\N
783	\N	\N	\N	\N	2026-11-03 09:20:00+01	\N	\N	\N	\N
596	1	\N	\N	\N	2026-11-03 04:45:00+01	\N	\N	\N	\N
784	\N	\N	\N	\N	2026-11-03 09:20:00+01	\N	\N	\N	\N
785	\N	\N	\N	\N	2026-11-03 09:20:00+01	\N	\N	\N	\N
786	\N	\N	\N	\N	2026-11-03 09:20:00+01	\N	\N	\N	\N
624	\N	\N	\N	\N	2026-11-03 11:58:00+01	\N	\N	\N	\N
499	\N	\N	\N	\N	2026-11-03 08:55:00+01	\N	\N	\N	\N
888	\N	\N	\N	\N	2026-11-03 09:30:00+01	\N	\N	\N	\N
889	\N	\N	\N	\N	2026-11-03 09:00:00+01	\N	\N	\N	\N
896	\N	\N	\N	\N	2026-11-03 12:50:00+01	\N	\N	\N	\N
970	\N	\N	\N	\N	2026-11-03 16:19:00+01	\N	\N	\N	\N
971	1	59	5	\N	2026-11-03 21:35:00+01	\N	\N	\N	\N
972	1	59	5	\N	2026-11-03 21:35:00+01	\N	\N	\N	\N
973	1	59	5	\N	2026-11-03 21:35:00+01	\N	\N	\N	\N
974	1	59	5	\N	2026-11-03 21:35:00+01	\N	\N	\N	\N
975	1	59	5	\N	2026-11-03 21:35:00+01	\N	\N	\N	\N
976	1	59	5	\N	2026-11-03 21:35:00+01	\N	\N	\N	\N
977	1	59	5	\N	2026-11-03 21:35:00+01	\N	\N	\N	\N
978	1	59	5	\N	2026-11-03 21:35:00+01	\N	\N	\N	\N
979	1	59	5	\N	2026-11-03 21:35:00+01	\N	\N	\N	\N
980	\N	\N	\N	\N	2026-11-03 10:50:00+01	\N	\N	\N	\N
981	\N	\N	\N	\N	2026-11-03 10:50:00+01	\N	\N	\N	\N
983	\N	\N	\N	\N	2026-11-03 15:25:00+01	\N	\N	\N	\N
984	\N	\N	\N	\N	2026-11-03 15:25:00+01	\N	\N	\N	\N
985	1	\N	\N	\N	2026-11-03 11:45:00+01	\N	\N	\N	\N
989	1	\N	\N	\N	2026-11-03 10:55:00+01	\N	\N	\N	\N
990	1	B1R	5	\N	2026-11-03 12:10:00+01	\N	\N	\N	\N
991	1	B1R	5	\N	2026-11-03 12:10:00+01	\N	\N	\N	\N
992	1	B1R	5	\N	2026-11-03 12:10:00+01	\N	\N	\N	\N
993	I	24	\N	\N	2026-11-03 11:50:00+01	\N	\N	\N	\N
994	I	24	\N	\N	2026-11-03 11:50:00+01	\N	\N	\N	\N
996	1	\N	\N	\N	2026-11-03 18:05:00+01	\N	\N	\N	\N
997	I	\N	\N	\N	2026-11-03 09:45:00+01	\N	\N	\N	\N
998	1	\N	4	\N	2026-11-03 13:10:00+01	\N	\N	\N	\N
999	1	\N	4	\N	2026-11-03 13:10:00+01	\N	\N	\N	\N
1000	1	\N	4	\N	2026-11-03 13:10:00+01	\N	\N	\N	\N
1001	2	9	\N	\N	2026-11-04 00:20:00+01	\N	\N	\N	\N
1002	2	66	\N	\N	2026-11-03 18:20:00+01	\N	\N	\N	\N
1003	\N	\N	\N	\N	2026-11-03 07:55:00+01	\N	\N	\N	\N
1004	\N	\N	\N	\N	2026-11-03 07:55:00+01	\N	\N	\N	\N
1005	\N	\N	\N	\N	2026-11-03 07:55:00+01	\N	\N	\N	\N
1006	I	75	I07	\N	2026-11-03 23:40:00+01	\N	\N	\N	\N
1007	I	75	I07	\N	2026-11-03 23:40:00+01	\N	\N	\N	\N
1008	I	75	I07	\N	2026-11-03 23:40:00+01	\N	\N	\N	\N
1009	N	\N	\N	\N	2026-11-03 07:40:00+01	\N	\N	\N	\N
1010	N	\N	\N	\N	2026-11-03 07:40:00+01	\N	\N	\N	\N
1011	1	\N	\N	\N	2026-11-03 18:30:00+01	\N	\N	\N	\N
1012	1	\N	\N	\N	2026-11-03 18:30:00+01	\N	\N	\N	\N
1013	1	\N	\N	\N	2026-11-03 18:30:00+01	\N	\N	\N	\N
1014	I	\N	\N	\N	2026-11-03 08:05:00+01	\N	\N	\N	\N
1015	\N	\N	\N	\N	2026-11-03 10:15:00+01	\N	\N	\N	\N
1016	\N	\N	\N	\N	2026-11-03 10:15:00+01	\N	\N	\N	\N
1017	\N	\N	\N	\N	2026-11-03 10:15:00+01	\N	\N	\N	\N
1018	A	A11	\N	\N	2026-11-03 09:40:00+01	\N	\N	\N	\N
1019	A	A11	\N	\N	2026-11-03 09:40:00+01	\N	\N	\N	\N
1020	A	A11	\N	\N	2026-11-03 09:40:00+01	\N	\N	\N	\N
1021	A	A11	\N	\N	2026-11-03 09:40:00+01	\N	\N	\N	\N
1022	A	A11	\N	\N	2026-11-03 09:40:00+01	\N	\N	\N	\N
1023	A	A11	\N	\N	2026-11-03 09:40:00+01	\N	\N	\N	\N
1024	A	A11	\N	\N	2026-11-03 09:40:00+01	\N	\N	\N	\N
1025	1	\N	\N	\N	2026-11-03 08:50:00+01	\N	\N	\N	\N
1026	1	\N	\N	\N	2026-11-03 08:50:00+01	\N	\N	\N	\N
1027	1	\N	\N	\N	2026-11-03 08:50:00+01	\N	\N	\N	\N
1028	1	\N	\N	\N	2026-11-03 08:50:00+01	\N	\N	\N	\N
1029	1	\N	\N	\N	2026-11-03 08:50:00+01	\N	\N	\N	\N
1030	1	\N	\N	\N	2026-11-03 08:50:00+01	\N	\N	\N	\N
1031	1	\N	\N	\N	2026-11-03 08:50:00+01	\N	\N	\N	\N
1032	1	\N	\N	\N	2026-11-03 08:50:00+01	\N	\N	\N	\N
1033	1	\N	\N	\N	2026-11-03 08:50:00+01	\N	\N	\N	\N
1034	1	\N	\N	\N	2026-11-03 08:50:00+01	\N	\N	\N	\N
1035	1	\N	\N	\N	2026-11-03 08:50:00+01	\N	\N	\N	\N
1036	2	\N	\N	\N	2026-11-03 07:35:00+01	\N	\N	\N	\N
1037	2	\N	\N	\N	2026-11-03 07:35:00+01	\N	\N	\N	\N
1038	1	\N	05	\N	2026-11-03 04:40:00+01	\N	\N	\N	\N
1039	1	\N	05	\N	2026-11-03 04:40:00+01	\N	\N	\N	\N
1040	1	\N	05	\N	2026-11-03 04:40:00+01	\N	\N	\N	\N
1041	1	\N	05	\N	2026-11-03 04:40:00+01	\N	\N	\N	\N
1042	1	\N	05	\N	2026-11-03 04:40:00+01	\N	\N	\N	\N
1043	1	\N	05	\N	2026-11-03 04:40:00+01	\N	\N	\N	\N
1044	1	\N	05	\N	2026-11-03 04:40:00+01	\N	\N	\N	\N
1045	1	\N	05	\N	2026-11-03 04:40:00+01	\N	\N	\N	\N
1046	1	\N	05	\N	2026-11-03 04:40:00+01	\N	\N	\N	\N
1047	\N	\N	\N	\N	2026-11-03 07:50:00+01	\N	\N	\N	\N
1048	\N	\N	\N	\N	2026-11-03 07:50:00+01	\N	\N	\N	\N
1049	\N	\N	\N	\N	2026-11-03 07:50:00+01	\N	\N	\N	\N
1050	\N	\N	\N	\N	2026-11-03 07:50:00+01	\N	\N	\N	\N
1051	\N	\N	\N	\N	2026-11-03 07:50:00+01	\N	\N	\N	\N
1052	\N	\N	\N	\N	2026-11-03 07:50:00+01	\N	\N	\N	\N
1053	1	\N	\N	\N	2026-11-03 17:25:00+01	\N	\N	\N	\N
1054	1	\N	\N	\N	2026-11-03 17:25:00+01	\N	\N	\N	\N
1055	1	\N	\N	\N	2026-11-03 07:20:00+01	\N	\N	\N	\N
1056	1	\N	\N	\N	2026-11-03 07:20:00+01	\N	\N	\N	\N
1057	1	\N	\N	\N	2026-11-03 07:20:00+01	\N	\N	\N	\N
1058	1	\N	\N	\N	2026-11-03 07:20:00+01	\N	\N	\N	\N
1059	1	\N	\N	\N	2026-11-03 07:20:00+01	\N	\N	\N	\N
1060	1	\N	\N	\N	2026-11-03 07:20:00+01	\N	\N	\N	\N
1061	4	\N	\N	\N	2026-11-03 07:35:00+01	\N	\N	\N	\N
1062	4	\N	\N	\N	2026-11-03 07:35:00+01	\N	\N	\N	\N
1063	4	\N	\N	\N	2026-11-03 07:35:00+01	\N	\N	\N	\N
1064	4	\N	\N	\N	2026-11-03 07:35:00+01	\N	\N	\N	\N
1065	\N	\N	\N	\N	2026-11-03 09:30:00+01	\N	\N	\N	\N
1066	2	60	\N	\N	2026-11-03 16:50:00+01	\N	\N	\N	\N
1067	2	60	\N	\N	2026-11-03 16:50:00+01	\N	\N	\N	\N
1068	2	60	\N	\N	2026-11-03 16:50:00+01	\N	\N	\N	\N
1106	3	\N	\N	\N	2026-11-05 09:55:00+01	\N	\N	\N	\N
1107	3	\N	\N	\N	2026-11-05 09:55:00+01	\N	\N	\N	\N
1108	3	\N	\N	\N	2026-11-05 09:55:00+01	\N	\N	\N	\N
1109	3	\N	\N	\N	2026-11-05 09:55:00+01	\N	\N	\N	\N
1113	I	\N	\N	\N	2026-11-05 14:25:00+01	\N	\N	\N	\N
1114	I	\N	\N	\N	2026-11-05 14:25:00+01	\N	\N	\N	\N
1115	I	\N	\N	\N	2026-11-05 14:25:00+01	\N	\N	\N	\N
1116	\N	\N	\N	\N	2026-11-05 11:05:00+01	\N	\N	\N	\N
1117	\N	\N	\N	\N	2026-11-05 11:05:00+01	\N	\N	\N	\N
1118	2	\N	35	\N	2026-11-05 10:55:00+01	\N	\N	\N	\N
1119	1	\N	\N	\N	2026-11-05 12:10:00+01	\N	\N	\N	\N
1120	4	\N	\N	\N	2026-11-05 10:45:00+01	\N	\N	\N	\N
1121	2	\N	22	\N	2026-11-05 11:00:00+01	\N	\N	\N	\N
1122	2	\N	04	\N	2026-11-05 08:15:00+01	\N	\N	\N	\N
1123	1	35	5A	\N	2026-11-05 07:20:00+01	\N	\N	\N	\N
1124	\N	\N	\N	\N	2026-11-05 09:35:00+01	\N	\N	\N	\N
1074	T2	\N	\N	\N	2026-11-05 09:50:00+01	\N	\N	\N	\N
1075	T2	\N	\N	\N	2026-11-05 09:50:00+01	\N	\N	\N	\N
1076	T2	\N	\N	\N	2026-11-05 09:50:00+01	\N	\N	\N	\N
1077	T2	\N	\N	\N	2026-11-05 09:50:00+01	\N	\N	\N	\N
1078	\N	\N	\N	\N	2026-11-05 06:40:00+01	\N	\N	\N	\N
1079	\N	\N	\N	\N	2026-11-05 02:12:00+01	\N	\N	\N	\N
1080	T2	\N	\N	\N	2026-11-05 10:10:00+01	\N	\N	\N	\N
1081	T2	\N	\N	\N	2026-11-05 10:10:00+01	\N	\N	\N	\N
1082	T2	\N	\N	\N	2026-11-05 10:10:00+01	\N	\N	\N	\N
1083	T2	\N	\N	\N	2026-11-05 10:10:00+01	\N	\N	\N	\N
1084	T2	\N	\N	\N	2026-11-05 10:10:00+01	\N	\N	\N	\N
1085	T2	\N	\N	\N	2026-11-05 10:10:00+01	\N	\N	\N	\N
1086	T2	\N	\N	\N	2026-11-05 10:10:00+01	\N	\N	\N	\N
1087	T2	\N	\N	\N	2026-11-05 09:25:00+01	\N	\N	\N	\N
1088	T2	\N	\N	\N	2026-11-05 09:25:00+01	\N	\N	\N	\N
1089	T2	\N	\N	\N	2026-11-05 09:25:00+01	\N	\N	\N	\N
1090	T2	\N	\N	\N	2026-11-05 09:25:00+01	\N	\N	\N	\N
1091	T2	\N	\N	\N	2026-11-05 09:25:00+01	\N	\N	\N	\N
1092	2	\N	\N	\N	2026-11-05 12:05:00+01	\N	\N	\N	\N
1093	2	\N	\N	\N	2026-11-05 12:05:00+01	\N	\N	\N	\N
1094	A	B26	10	\N	2026-11-05 07:45:00+01	\N	\N	\N	\N
1095	A	B26	10	\N	2026-11-05 07:45:00+01	\N	\N	\N	\N
1096	A	B26	10	\N	2026-11-05 07:45:00+01	\N	\N	\N	\N
1097	A	B26	10	\N	2026-11-05 07:45:00+01	\N	\N	\N	\N
1098	A	B26	10	\N	2026-11-05 07:45:00+01	\N	\N	\N	\N
1099	A	B26	10	\N	2026-11-05 07:45:00+01	\N	\N	\N	\N
1100	T3	\N	\N	\N	2026-11-05 07:15:00+01	\N	\N	\N	\N
1101	T3	\N	\N	\N	2026-11-05 07:15:00+01	\N	\N	\N	\N
1102	\N	\N	\N	\N	2026-11-05 10:25:00+01	\N	\N	\N	\N
1103	\N	\N	\N	\N	2026-11-05 09:50:00+01	\N	\N	\N	\N
1104	\N	\N	\N	\N	2026-11-05 09:50:00+01	\N	\N	\N	\N
1105	\N	\N	\N	\N	2026-11-05 13:55:00+01	\N	\N	\N	\N
1071	MAIN	\N	\N	\N	2026-11-05 10:10:00+01	\N	\N	\N	\N
1072	2	66	\N	\N	2026-11-05 16:40:00+01	\N	\N	\N	\N
1073	T2	\N	\N	\N	2026-11-05 09:50:00+01	\N	\N	\N	\N
1125	\N	\N	\N	\N	2026-11-05 09:15:00+01	\N	\N	\N	\N
1126	\N	\N	\N	\N	2026-11-05 06:25:00+01	\N	\N	\N	\N
1127	\N	\N	\N	\N	2026-11-05 11:00:00+01	\N	\N	\N	\N
1128	\N	\N	6	\N	2026-11-05 11:00:00+01	\N	\N	\N	\N
1129	\N	\N	\N	\N	2026-11-05 11:15:00+01	\N	\N	\N	\N
1130	1	\N	\N	\N	2026-11-05 08:40:00+01	\N	\N	\N	\N
1131	1	\N	\N	\N	2026-11-05 08:40:00+01	\N	\N	\N	\N
1132	1	\N	\N	\N	2026-11-05 08:40:00+01	\N	\N	\N	\N
1133	1	\N	\N	\N	2026-11-05 08:40:00+01	\N	\N	\N	\N
1134	\N	\N	\N	\N	2026-11-05 10:20:00+01	\N	\N	\N	\N
1135	\N	\N	\N	\N	2026-11-05 10:20:00+01	\N	\N	\N	\N
1136	I	\N	\N	\N	2026-11-05 12:00:00+01	\N	\N	\N	\N
1137	I	\N	\N	\N	2026-11-05 12:00:00+01	\N	\N	\N	\N
1138	I	\N	\N	\N	2026-11-05 12:00:00+01	\N	\N	\N	\N
1139	I	\N	\N	\N	2026-11-05 12:15:00+01	\N	\N	\N	\N
1140	1A	\N	\N	\N	2026-11-05 07:40:00+01	\N	\N	\N	\N
1141	1A	\N	\N	\N	2026-11-05 07:40:00+01	\N	\N	\N	\N
1142	1A	\N	\N	\N	2026-11-05 07:40:00+01	\N	\N	\N	\N
1143	\N	\N	\N	\N	2026-11-05 07:10:00+01	\N	\N	\N	\N
1144	1	\N	\N	\N	2026-11-05 04:40:00+01	\N	\N	\N	\N
1145	1	\N	\N	\N	2026-11-05 04:40:00+01	\N	\N	\N	\N
1146	1	\N	\N	\N	2026-11-05 04:40:00+01	\N	\N	\N	\N
1147	1	\N	\N	\N	2026-11-05 04:40:00+01	\N	\N	\N	\N
1148	T1	\N	\N	\N	2026-11-05 04:35:00+01	\N	\N	\N	\N
1149	\N	\N	\N	\N	2026-11-05 09:45:00+01	\N	\N	\N	\N
1150	T3	\N	\N	\N	2026-11-05 10:30:00+01	\N	\N	\N	\N
1151	\N	\N	\N	\N	2026-11-05 11:45:00+01	\N	\N	\N	\N
1152	\N	\N	\N	\N	2026-11-05 09:50:00+01	\N	\N	\N	\N
1153	1	\N	\N	\N	2026-11-05 09:05:00+01	\N	\N	\N	\N
1154	\N	\N	\N	\N	2026-11-05 09:50:00+01	\N	\N	\N	\N
1155	\N	\N	\N	\N	2026-11-05 09:50:00+01	\N	\N	\N	\N
1156	\N	\N	\N	\N	2026-11-05 09:50:00+01	\N	\N	\N	\N
1157	\N	\N	\N	\N	2026-11-05 13:30:00+01	\N	\N	\N	\N
1158	\N	\N	\N	\N	2026-11-05 13:30:00+01	\N	\N	\N	\N
1159	\N	\N	\N	\N	2026-11-05 13:30:00+01	\N	\N	\N	\N
1160	\N	\N	\N	\N	2026-11-05 09:15:00+01	\N	\N	\N	\N
1195	\N	\N	\N	\N	2026-11-05 03:10:00+01	\N	\N	\N	\N
1196	\N	\N	\N	\N	2026-11-05 02:46:00+01	\N	\N	\N	\N
1197	\N	\N	\N	\N	2026-11-05 18:35:00+01	\N	\N	\N	\N
1198	2	\N	35	\N	2026-11-05 10:55:00+01	\N	\N	\N	\N
1199	2	\N	35	\N	2026-11-05 10:55:00+01	\N	\N	\N	\N
1200	2	AG7	D6	\N	2026-11-05 12:55:00+01	\N	\N	\N	\N
1161	\N	\N	\N	\N	2026-11-05 05:50:00+01	\N	\N	\N	\N
1162	T2	\N	\N	\N	2026-11-05 10:20:00+01	\N	\N	\N	\N
1163	T2	\N	\N	\N	2026-11-05 10:20:00+01	\N	\N	\N	\N
1164	T2	\N	\N	\N	2026-11-05 10:20:00+01	\N	\N	\N	\N
1165	\N	\N	B1	\N	2026-11-05 10:40:00+01	\N	\N	\N	\N
1167	\N	\N	B1	\N	2026-11-05 10:40:00+01	\N	\N	\N	\N
1168	T3	\N	\N	\N	2026-11-05 08:20:00+01	\N	\N	\N	\N
1169	3	\N	\N	\N	2026-11-05 09:30:00+01	\N	\N	\N	\N
1170	1	\N	\N	\N	2026-11-05 10:20:00+01	\N	\N	\N	\N
1171	1	\N	\N	\N	2026-11-05 10:20:00+01	\N	\N	\N	\N
1172	1	\N	\N	\N	2026-11-05 10:20:00+01	\N	\N	\N	\N
1173	N	\N	\N	\N	2026-11-05 10:05:00+01	\N	\N	\N	\N
1174	1	46	19	\N	2026-11-05 10:50:00+01	\N	\N	\N	\N
1175	1	46	19	\N	2026-11-05 10:50:00+01	\N	\N	\N	\N
1176	1	46	19	\N	2026-11-05 10:50:00+01	\N	\N	\N	\N
1177	3	\N	4	\N	2026-11-05 07:00:00+01	\N	\N	\N	\N
1178	3	\N	4	\N	2026-11-05 07:00:00+01	\N	\N	\N	\N
1179	3	\N	4	\N	2026-11-05 07:00:00+01	\N	\N	\N	\N
1180	3	\N	4	\N	2026-11-05 07:00:00+01	\N	\N	\N	\N
1181	3	\N	14	\N	2026-11-05 06:40:00+01	\N	\N	\N	\N
1182	3	\N	14	\N	2026-11-05 06:40:00+01	\N	\N	\N	\N
1183	3	\N	14	\N	2026-11-05 06:40:00+01	\N	\N	\N	\N
1184	3	\N	14	\N	2026-11-05 06:40:00+01	\N	\N	\N	\N
1185	3	\N	14	\N	2026-11-05 06:40:00+01	\N	\N	\N	\N
1186	3	\N	\N	\N	2026-11-05 10:55:00+01	\N	\N	\N	\N
1187	3	\N	\N	\N	2026-11-05 10:55:00+01	\N	\N	\N	\N
1188	3	\N	\N	\N	2026-11-05 10:55:00+01	\N	\N	\N	\N
1189	3	\N	\N	\N	2026-11-05 10:55:00+01	\N	\N	\N	\N
1190	3	\N	\N	\N	2026-11-05 10:55:00+01	\N	\N	\N	\N
1191	3	\N	\N	\N	2026-11-05 10:55:00+01	\N	\N	\N	\N
1192	1	\N	\N	\N	2026-11-05 07:45:00+01	\N	\N	\N	\N
1193	1	\N	\N	\N	2026-11-05 07:45:00+01	\N	\N	\N	\N
1194	2	\N	\N	\N	2026-11-05 09:35:00+01	\N	\N	\N	\N
1201	2	AG7	D6	\N	2026-11-05 12:55:00+01	\N	\N	\N	\N
1202	2	AG7	D6	\N	2026-11-05 12:55:00+01	\N	\N	\N	\N
1203	T2	\N	\N	\N	2026-11-05 04:45:00+01	\N	\N	\N	\N
1204	2	\N	\N	\N	2026-11-05 05:40:00+01	\N	\N	\N	\N
1205	\N	\N	\N	\N	2026-11-05 07:30:00+01	\N	\N	\N	\N
1206	\N	\N	\N	\N	2026-11-05 04:40:00+01	\N	\N	\N	\N
1207	\N	\N	\N	\N	2026-11-05 04:40:00+01	\N	\N	\N	\N
1208	\N	\N	\N	\N	2026-11-05 04:40:00+01	\N	\N	\N	\N
1209	3	\N	\N	\N	2026-11-05 17:00:00+01	\N	\N	\N	\N
1210	3	\N	\N	\N	2026-11-05 17:00:00+01	\N	\N	\N	\N
1211	2	\N	\N	\N	2026-11-05 10:25:00+01	\N	\N	\N	\N
1399	\N	\N	\N	\N	2026-11-05 04:00:00+01	\N	\N	\N	\N
1212	\N	\N	\N	\N	2026-11-05 10:15:00+01	\N	\N	\N	\N
1213	\N	\N	\N	\N	2026-11-05 10:15:00+01	\N	\N	\N	\N
1214	\N	\N	\N	\N	2026-11-05 10:15:00+01	\N	\N	\N	\N
1215	\N	\N	\N	\N	2026-11-05 12:00:00+01	\N	\N	\N	\N
1216	\N	\N	\N	\N	2026-11-05 02:50:00+01	\N	\N	\N	\N
1217	2	\N	213	\N	2026-11-05 07:40:00+01	\N	\N	\N	\N
1070	MAIN	\N	\N	\N	2026-11-05 10:10:00+01	\N	\N	\N	\N
1166	\N	\N	B1	\N	2026-11-05 10:40:00+01	\N	\N	\N	\N
\.


--
-- Data for Name: codeshare; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.codeshare (flight_id, operating_airline_id, operating_flight_number) FROM stdin;
690	377	706
691	336	706
692	13	524
693	4	524
694	302	524
695	192	934
696	55	934
697	302	934
698	6	608
699	96	802
700	336	802
701	6	802
702	6	118
703	47	612
704	12	9409
705	93	6145
706	360	6145
707	406	6145
708	4	776
709	58	776
710	2	776
711	5	776
712	4	1636
713	918	644
714	26	644
715	4	644
716	5	644
720	26	750
721	927	750
722	53	750
723	66	750
724	437	962
725	45	886
726	46	886
727	47	886
730	2	644
735	4	2180
742	951	1014
743	952	1014
744	10	1014
745	954	870
746	305	160
747	308	734
748	305	162
749	308	700
750	302	607
752	6	1752
753	57	1752
754	302	1752
755	66	705
756	58	564
757	23	118
758	62	787
759	336	787
760	954	921
761	377	921
762	378	921
763	62	921
764	336	921
765	57	596
766	58	596
767	93	638
768	57	526
769	58	526
770	66	526
771	437	1143
772	437	811
773	368	207
775	96	705
776	11	705
777	325	705
778	79	705
779	336	705
780	990	338
782	326	211
783	58	211
784	93	211
785	5	211
786	36	211
971	1186	141
972	389	141
973	56	141
974	305	141
975	57	141
976	11	141
977	32	141
978	1193	141
979	99	141
980	1195	319
981	54	319
983	13	607
984	192	607
985	53	723
989	58	135
990	45	940
991	46	940
992	47	940
993	93	584
994	36	584
996	58	316
997	45	766
998	326	378
999	325	378
1000	336	378
1001	11	408
1002	58	318
1003	1218	761
1004	1219	761
1005	1220	761
1006	11	430
1007	325	430
1008	19	430
1009	11	11
1010	1225	11
1011	11	420
1012	325	420
1013	19	420
1014	9	705
1015	360	2745
1016	12	2745
1017	89	2745
1018	3	1363
1019	26	1363
1020	389	1363
1021	62	1363
1022	43	1363
1023	1238	1363
1024	23	1363
1025	66	676
1026	3	676
1027	410	676
1028	1186	676
1029	62	676
1030	43	676
1031	26	676
1032	1247	676
1033	1248	676
1034	388	676
1035	952	676
1036	57	217
1037	54	217
1038	389	1184
1039	1247	1184
1040	1248	1184
1041	66	1184
1042	3	1184
1043	23	1184
1044	13	1184
1045	43	1184
1046	54	1184
1047	1247	195
1048	1186	195
1049	389	195
1050	54	195
1051	13	195
1052	1248	195
1053	3	802
1054	58	802
1055	1247	343
1056	389	343
1057	3	343
1058	1248	343
1059	54	343
1060	58	343
1061	13	147
1062	389	147
1063	54	147
1064	1248	147
1065	93	160
1066	55	720
1067	26	720
1068	66	720
1075	360	4607
1076	89	4607
1070	338	701
1071	336	701
1074	12	4607
1106	363	8176
1107	364	8176
1108	79	8176
1109	360	8176
1113	11	71
1114	62	71
1115	2	71
1116	5	1728
1117	4	1728
1118	378	8357
1119	14	345
1120	118	1704
1121	118	1507
1122	11	2419
1123	11	6877
1130	1346	602
1131	1186	602
1132	6	602
1133	57	602
1134	169	2044
1135	1353	2044
1136	192	2147
1137	58	2147
1138	308	2147
1139	169	203
1140	305	765
1141	1359	765
1142	440	765
1143	299	695
1144	328	1096
1145	951	1096
1146	54	1096
1147	302	1096
1148	55	1547
1149	308	722
1150	1299	8737
1152	178	1573
1153	437	907
1154	45	463
1155	46	463
1156	47	463
1157	46	952
1158	47	952
1159	45	952
1160	46	495
1162	118	8913
1163	406	8913
1164	14	8913
1165	193	1945
1166	12	1945
1188	26	38
1189	66	38
1190	389	38
1191	11	38
1192	303	857
1193	55	857
1194	4	302
1198	193	8357
1199	4	8357
1201	11	12
1202	46	12
1203	305	1399
1204	8	685
1205	299	95
1206	54	1254
1082	364	8945
1083	101	8945
1084	1299	8945
1085	363	8945
1086	12	8945
1087	360	8331
1088	364	8331
1089	101	8331
1090	1299	8331
1091	363	8331
1092	9	129
1093	336	129
1094	328	401
1095	29	401
1096	390	401
1097	368	401
1098	55	401
1099	325	401
1100	326	306
1101	14	306
1103	118	8125
1104	14	8125
1105	102	5481
1167	360	1945
1168	14	228
1169	6	60
1170	413	330
1171	4	330
1172	378	330
1173	4	314
1174	13	612
1175	192	612
1176	302	612
1177	9	349
1178	11	349
1179	325	349
1180	336	349
1181	13	402
1182	4	402
1183	178	402
1184	302	402
1185	336	402
1187	2	38
1207	55	1254
1208	302	1254
1209	303	818
1210	55	818
1211	302	770
1212	57	551
1213	36	551
1214	26	551
1217	1438	579
1073	118	4607
1077	14	4607
1080	360	8945
1081	79	8945
\.


--
-- Data for Name: departure; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departure (flight_id, terminal, gate, delay, scheduled, estimated, actual, estimated_runway, actual_runway) FROM stdin;
1	\N	\N	\N	2026-10-26 03:00:00+01	2026-10-26 03:00:00+01	\N	\N	\N
2	D	\N	0	2026-10-26 07:45:00+01	2026-10-26 07:45:00+01	\N	2026-10-26 07:45:00+01	\N
3	D	\N	0	2026-10-26 07:45:00+01	2026-10-26 07:45:00+01	\N	2026-10-26 07:45:00+01	\N
4	D	\N	0	2026-10-26 07:45:00+01	2026-10-26 07:45:00+01	\N	2026-10-26 07:45:00+01	\N
5	D	\N	0	2026-10-26 07:45:00+01	2026-10-26 07:45:00+01	\N	2026-10-26 07:45:00+01	\N
6	D	44A	0	2026-10-26 07:35:00+01	2026-10-26 07:35:00+01	\N	2026-10-26 07:35:00+01	\N
7	D	20	0	2026-10-26 07:35:00+01	2026-10-26 07:35:00+01	\N	2026-10-26 07:35:00+01	\N
8	2	D12	0	2026-10-26 01:15:00+01	2026-10-26 01:15:00+01	\N	2026-10-26 01:15:00+01	\N
9	\N	\N	\N	2026-10-26 03:00:00+01	2026-10-26 03:00:00+01	\N	\N	\N
10	2	G154	0	2026-10-26 01:35:00+01	2026-10-26 01:35:00+01	\N	2026-10-26 01:35:00+01	\N
11	1	21	0	2026-10-26 01:15:00+01	2026-10-26 01:15:00+01	\N	2026-10-26 01:15:00+01	\N
12	1	21	0	2026-10-26 01:15:00+01	2026-10-26 01:15:00+01	\N	2026-10-26 01:15:00+01	\N
13	1	G123	0	2026-10-26 01:15:00+01	2026-10-26 01:15:00+01	\N	2026-10-26 01:15:00+01	\N
14	2	D77	\N	2026-10-26 01:10:00+01	2026-10-26 01:10:00+01	\N	\N	\N
15	2	D77	\N	2026-10-26 01:10:00+01	2026-10-26 01:10:00+01	\N	\N	\N
16	1	G134	0	2026-10-26 01:10:00+01	2026-10-26 01:10:00+01	\N	2026-10-26 01:10:00+01	\N
17	1	G119	0	2026-10-26 01:10:00+01	2026-10-26 01:10:00+01	\N	2026-10-26 01:10:00+01	\N
18	1	G119	0	2026-10-26 01:10:00+01	2026-10-26 01:10:00+01	\N	2026-10-26 01:10:00+01	\N
19	2	D61	0	2026-10-26 01:10:00+01	2026-10-26 01:10:00+01	\N	2026-10-26 01:10:00+01	\N
20	2	D61	0	2026-10-26 01:10:00+01	2026-10-26 01:10:00+01	\N	2026-10-26 01:10:00+01	\N
21	1	G139	\N	2026-10-26 01:10:00+01	2026-10-26 01:10:00+01	\N	\N	\N
22	1	1	0	2026-10-26 08:00:00+01	2026-10-26 08:00:00+01	\N	2026-10-26 08:00:00+01	\N
23	1	1	0	2026-10-26 08:00:00+01	2026-10-26 08:00:00+01	\N	2026-10-26 08:00:00+01	\N
24	1	1	0	2026-10-26 08:00:00+01	2026-10-26 08:00:00+01	\N	2026-10-26 08:00:00+01	\N
25	1	1	0	2026-10-26 08:00:00+01	2026-10-26 08:00:00+01	\N	2026-10-26 08:00:00+01	\N
26	1	1	0	2026-10-26 08:00:00+01	2026-10-26 08:00:00+01	\N	2026-10-26 08:00:00+01	\N
27	1	4	0	2026-10-26 08:00:00+01	2026-10-26 08:00:00+01	\N	2026-10-26 08:00:00+01	\N
28	1	4	0	2026-10-26 08:00:00+01	2026-10-26 08:00:00+01	\N	2026-10-26 08:00:00+01	\N
29	1	4	0	2026-10-26 08:00:00+01	2026-10-26 08:00:00+01	\N	2026-10-26 08:00:00+01	\N
30	1	4	0	2026-10-26 08:00:00+01	2026-10-26 08:00:00+01	\N	2026-10-26 08:00:00+01	\N
31	1	4	0	2026-10-26 08:00:00+01	2026-10-26 08:00:00+01	\N	2026-10-26 08:00:00+01	\N
32	2	16A	0	2026-10-26 08:00:00+01	2026-10-26 08:00:00+01	\N	2026-10-26 08:00:00+01	\N
33	2	16A	0	2026-10-26 08:00:00+01	2026-10-26 08:00:00+01	\N	2026-10-26 08:00:00+01	\N
34	2	16A	0	2026-10-26 08:00:00+01	2026-10-26 08:00:00+01	\N	2026-10-26 08:00:00+01	\N
35	2	4	0	2026-10-26 08:00:00+01	2026-10-26 08:00:00+01	\N	2026-10-26 08:00:00+01	\N
36	2	4	0	2026-10-26 08:00:00+01	2026-10-26 08:00:00+01	\N	2026-10-26 08:00:00+01	\N
37	2	4	0	2026-10-26 08:00:00+01	2026-10-26 08:00:00+01	\N	2026-10-26 08:00:00+01	\N
38	1	5	0	2026-10-26 07:45:00+01	2026-10-26 07:45:00+01	\N	2026-10-26 07:45:00+01	\N
39	1	5	0	2026-10-26 07:45:00+01	2026-10-26 07:45:00+01	\N	2026-10-26 07:45:00+01	\N
40	1	5	0	2026-10-26 07:45:00+01	2026-10-26 07:45:00+01	\N	2026-10-26 07:45:00+01	\N
41	1	5	0	2026-10-26 07:45:00+01	2026-10-26 07:45:00+01	\N	2026-10-26 07:45:00+01	\N
42	1	5	0	2026-10-26 07:45:00+01	2026-10-26 07:45:00+01	\N	2026-10-26 07:45:00+01	\N
43	1	5	0	2026-10-26 07:45:00+01	2026-10-26 07:45:00+01	\N	2026-10-26 07:45:00+01	\N
44	1	5	0	2026-10-26 07:45:00+01	2026-10-26 07:45:00+01	\N	2026-10-26 07:45:00+01	\N
45	\N	\N	\N	2026-10-26 08:30:00+01	2026-10-26 08:30:00+01	\N	\N	\N
46	2	\N	0	2026-10-26 03:40:00+01	2026-10-26 03:40:00+01	\N	2026-10-26 03:40:00+01	\N
47	2	\N	0	2026-10-26 03:40:00+01	2026-10-26 03:40:00+01	\N	2026-10-26 03:40:00+01	\N
48	2	\N	0	2026-10-26 03:40:00+01	2026-10-26 03:40:00+01	\N	2026-10-26 03:40:00+01	\N
49	\N	\N	10	2026-10-26 02:40:00+01	2026-10-26 02:40:00+01	\N	2026-10-26 02:50:00+01	\N
50	2	2	0	2026-10-26 07:45:00+01	2026-10-26 07:45:00+01	\N	2026-10-26 07:45:00+01	\N
51	2	2	0	2026-10-26 07:45:00+01	2026-10-26 07:45:00+01	\N	2026-10-26 07:45:00+01	\N
52	2	F52	0	2026-10-26 01:55:00+01	2026-10-26 01:55:00+01	\N	2026-10-26 01:55:00+01	\N
53	\N	\N	\N	2026-10-26 01:30:00+01	2026-10-26 01:30:00+01	\N	\N	\N
54	1	\N	0	2026-10-26 03:25:00+01	2026-10-26 03:25:00+01	\N	2026-10-26 03:25:00+01	\N
55	1	\N	0	2026-10-26 03:25:00+01	2026-10-26 03:25:00+01	\N	2026-10-26 03:25:00+01	\N
56	1	\N	0	2026-10-26 03:25:00+01	2026-10-26 03:25:00+01	\N	2026-10-26 03:25:00+01	\N
57	2	211	0	2026-10-26 02:55:00+01	2026-10-26 02:55:00+01	\N	2026-10-26 02:55:00+01	\N
58	2	218	0	2026-10-26 02:50:00+01	2026-10-26 02:50:00+01	\N	2026-10-26 02:50:00+01	\N
59	1	\N	0	2026-10-26 02:50:00+01	2026-10-26 02:50:00+01	\N	2026-10-26 02:50:00+01	\N
60	1	\N	0	2026-10-26 02:50:00+01	2026-10-26 02:50:00+01	\N	2026-10-26 02:50:00+01	\N
61	1	\N	0	2026-10-26 02:40:00+01	2026-10-26 02:40:00+01	\N	2026-10-26 02:40:00+01	\N
62	1	\N	0	2026-10-26 02:40:00+01	2026-10-26 02:40:00+01	\N	2026-10-26 02:40:00+01	\N
63	1	\N	0	2026-10-26 02:40:00+01	2026-10-26 02:40:00+01	\N	2026-10-26 02:40:00+01	\N
64	1	\N	0	2026-10-26 02:40:00+01	2026-10-26 02:40:00+01	\N	2026-10-26 02:40:00+01	\N
65	1	\N	0	2026-10-26 02:25:00+01	2026-10-26 02:25:00+01	\N	2026-10-26 02:25:00+01	\N
66	1	\N	0	2026-10-26 02:25:00+01	2026-10-26 02:25:00+01	\N	2026-10-26 02:25:00+01	\N
67	1	\N	0	2026-10-26 02:25:00+01	2026-10-26 02:25:00+01	\N	2026-10-26 02:25:00+01	\N
68	1	\N	0	2026-10-26 02:25:00+01	2026-10-26 02:25:00+01	\N	2026-10-26 02:25:00+01	\N
69	1	2	0	2026-10-26 02:05:00+01	2026-10-26 02:05:00+01	\N	2026-10-26 02:05:00+01	\N
70	1	42	0	2026-10-26 02:00:00+01	2026-10-26 02:00:00+01	\N	2026-10-26 02:00:00+01	\N
71	2	\N	0	2026-10-26 02:45:00+01	2026-10-26 02:45:00+01	\N	2026-10-26 02:45:00+01	\N
72	2	\N	0	2026-10-26 02:45:00+01	2026-10-26 02:45:00+01	\N	2026-10-26 02:45:00+01	\N
73	2	\N	0	2026-10-26 02:40:00+01	2026-10-26 02:40:00+01	\N	2026-10-26 02:40:00+01	\N
74	\N	\N	\N	2026-10-26 02:25:00+01	2026-10-26 02:25:00+01	\N	\N	\N
75	\N	\N	\N	2026-10-26 01:20:00+01	2026-10-26 01:20:00+01	\N	\N	\N
76	\N	\N	\N	2026-10-26 01:15:00+01	2026-10-26 01:15:00+01	\N	\N	\N
77	2	\N	\N	2026-10-26 03:05:00+01	2026-10-26 03:05:00+01	\N	\N	\N
78	1	\N	10	2026-10-26 02:45:00+01	2026-10-26 02:45:00+01	\N	2026-10-26 02:55:00+01	\N
79	1	\N	10	2026-10-26 02:45:00+01	2026-10-26 02:45:00+01	\N	2026-10-26 02:55:00+01	\N
80	1	\N	10	2026-10-26 02:45:00+01	2026-10-26 02:45:00+01	\N	2026-10-26 02:55:00+01	\N
81	1	\N	0	2026-10-26 02:30:00+01	2026-10-26 02:30:00+01	\N	2026-10-26 02:30:00+01	\N
82	1	\N	0	2026-10-26 02:30:00+01	2026-10-26 02:30:00+01	\N	2026-10-26 02:30:00+01	\N
83	2	\N	0	2026-10-26 02:10:00+01	2026-10-26 02:10:00+01	\N	2026-10-26 02:10:00+01	\N
84	\N	\N	\N	2026-10-26 05:50:00+01	2026-10-26 05:50:00+01	\N	\N	\N
85	\N	\N	\N	2026-10-26 07:00:00+01	2026-10-26 07:00:00+01	\N	\N	\N
86	\N	\N	\N	2026-10-26 08:05:00+01	2026-10-26 08:05:00+01	\N	\N	\N
87	D	20	0	2026-10-26 09:15:00+01	2026-10-26 09:15:00+01	\N	2026-10-26 09:15:00+01	\N
88	D	20	0	2026-10-26 09:15:00+01	2026-10-26 09:15:00+01	\N	2026-10-26 09:15:00+01	\N
89	\N	\N	\N	2026-10-26 06:00:00+01	2026-10-26 06:00:00+01	\N	\N	\N
90	\N	\N	\N	2026-10-26 05:50:00+01	2026-10-26 05:50:00+01	\N	\N	\N
91	\N	\N	\N	2026-10-26 05:30:00+01	2026-10-26 05:30:00+01	\N	\N	\N
92	\N	\N	\N	2026-10-26 07:35:00+01	2026-10-26 07:35:00+01	\N	\N	\N
93	D	28	0	2026-10-26 09:55:00+01	2026-10-26 09:55:00+01	\N	2026-10-26 09:55:00+01	\N
94	D	28	0	2026-10-26 09:55:00+01	2026-10-26 09:55:00+01	\N	2026-10-26 09:55:00+01	\N
95	D	28	0	2026-10-26 09:55:00+01	2026-10-26 09:55:00+01	\N	2026-10-26 09:55:00+01	\N
96	D	28	0	2026-10-26 09:55:00+01	2026-10-26 09:55:00+01	\N	2026-10-26 09:55:00+01	\N
97	D	28	0	2026-10-26 09:55:00+01	2026-10-26 09:55:00+01	\N	2026-10-26 09:55:00+01	\N
98	D	33	0	2026-10-26 09:15:00+01	2026-10-26 09:15:00+01	\N	2026-10-26 09:15:00+01	\N
99	D	33	0	2026-10-26 09:15:00+01	2026-10-26 09:15:00+01	\N	2026-10-26 09:15:00+01	\N
100	D	33	0	2026-10-26 09:15:00+01	2026-10-26 09:15:00+01	\N	2026-10-26 09:15:00+01	\N
399	\N	\N	\N	2026-11-03 03:40:00+01	2026-11-03 03:40:00+01	\N	\N	\N
400	2	\N	0	2026-11-03 10:05:00+01	2026-11-03 10:05:00+01	\N	2026-11-03 10:05:00+01	\N
401	1	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
402	2	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
403	2	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
404	2	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
405	2	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
406	1	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
407	2	\N	0	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	2026-11-03 10:00:00+01	\N
408	2	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
409	2	\N	0	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	2026-11-03 10:00:00+01	\N
410	2	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
411	2	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
412	2	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
413	2	\N	0	2026-11-03 09:55:00+01	2026-11-03 09:55:00+01	\N	2026-11-03 09:55:00+01	\N
414	2	\N	\N	2026-11-03 09:55:00+01	2026-11-03 09:55:00+01	\N	\N	\N
415	2	\N	\N	2026-11-03 09:55:00+01	2026-11-03 09:55:00+01	\N	\N	\N
416	2	\N	0	2026-11-03 09:45:00+01	2026-11-03 09:45:00+01	\N	2026-11-03 09:45:00+01	\N
417	2	\N	\N	2026-11-03 09:40:00+01	2026-11-03 09:40:00+01	\N	\N	\N
418	2	\N	\N	2026-11-03 09:35:00+01	2026-11-03 09:35:00+01	\N	\N	\N
419	2	\N	\N	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	\N	\N
420	2	\N	\N	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	\N	\N
421	2	\N	0	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	2026-11-03 09:30:00+01	\N
422	2	\N	0	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	2026-11-03 09:30:00+01	\N
423	2	\N	0	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	2026-11-03 09:30:00+01	\N
424	2	\N	0	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	2026-11-03 09:30:00+01	\N
425	2	\N	0	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	2026-11-03 09:30:00+01	\N
426	2	\N	0	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	2026-11-03 09:30:00+01	\N
427	2	\N	0	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	2026-11-03 09:30:00+01	\N
428	1	\N	0	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	2026-11-03 09:30:00+01	\N
429	2	\N	\N	2026-11-03 09:20:00+01	2026-11-03 09:20:00+01	\N	\N	\N
430	2	\N	0	2026-11-03 09:20:00+01	2026-11-03 09:20:00+01	\N	2026-11-03 09:20:00+01	\N
431	2	\N	0	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	2026-11-03 09:15:00+01	\N
432	2	\N	\N	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	\N	\N
433	2	\N	\N	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	\N	\N
434	2	\N	\N	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	\N	\N
435	2	\N	0	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	2026-11-03 09:15:00+01	\N
436	2	\N	0	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	2026-11-03 09:15:00+01	\N
437	2	\N	0	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	2026-11-03 09:15:00+01	\N
438	2	\N	0	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	2026-11-03 09:15:00+01	\N
439	T2	\N	\N	2026-11-03 09:10:00+01	2026-11-03 09:10:00+01	\N	\N	\N
440	2	\N	\N	2026-11-03 09:10:00+01	2026-11-03 09:10:00+01	\N	\N	\N
441	2	\N	\N	2026-11-03 09:10:00+01	2026-11-03 09:10:00+01	\N	\N	\N
442	\N	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
443	\N	\N	\N	2026-11-03 09:50:00+01	2026-11-03 09:50:00+01	\N	\N	\N
445	\N	\N	\N	2026-11-03 09:45:00+01	2026-11-03 09:45:00+01	\N	\N	\N
446	\N	\N	\N	2026-11-03 06:55:00+01	2026-11-03 06:55:00+01	\N	\N	\N
447	\N	\N	\N	2026-11-03 04:50:00+01	2026-11-03 04:50:00+01	\N	\N	\N
448	\N	\N	\N	2026-11-03 08:55:00+01	2026-11-03 08:55:00+01	\N	\N	\N
449	\N	\N	\N	2026-11-03 08:30:00+01	2026-11-03 08:30:00+01	\N	\N	\N
450	\N	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
451	\N	\N	\N	2026-11-03 09:50:00+01	2026-11-03 09:50:00+01	\N	\N	\N
452	\N	\N	\N	2026-11-03 09:40:00+01	2026-11-03 09:40:00+01	\N	\N	\N
453	\N	\N	\N	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	\N	\N
690	2	E22	0	2026-11-03 08:00:00+01	2026-11-03 08:00:00+01	\N	2026-11-03 08:00:00+01	\N
455	\N	\N	\N	2026-11-03 10:55:00+01	2026-11-03 10:55:00+01	\N	\N	\N
691	2	E22	0	2026-11-03 08:00:00+01	2026-11-03 08:00:00+01	\N	2026-11-03 08:00:00+01	\N
692	3	A21	0	2026-11-03 08:00:00+01	2026-11-03 08:00:00+01	\N	2026-11-03 08:00:00+01	\N
458	\N	\N	\N	2026-11-03 10:05:00+01	2026-11-03 10:05:00+01	\N	\N	\N
459	\N	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
460	\N	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
461	\N	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
462	\N	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
463	\N	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
464	\N	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
465	\N	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
466	\N	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
467	\N	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
468	\N	\N	\N	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	\N	\N
469	\N	\N	\N	2026-11-03 09:55:00+01	2026-11-03 09:55:00+01	\N	\N	\N
470	\N	\N	\N	2026-11-03 09:55:00+01	2026-11-03 09:55:00+01	\N	\N	\N
471	\N	\N	0	2026-11-03 09:50:00+01	2026-11-03 09:50:00+01	\N	2026-11-03 09:50:00+01	\N
472	\N	\N	0	2026-11-03 09:50:00+01	2026-11-03 09:50:00+01	\N	2026-11-03 09:50:00+01	\N
473	\N	\N	\N	2026-11-03 09:45:00+01	2026-11-03 09:45:00+01	\N	\N	\N
474	\N	\N	\N	2026-11-03 09:45:00+01	2026-11-03 09:45:00+01	\N	\N	\N
475	\N	\N	\N	2026-11-03 09:40:00+01	2026-11-03 09:40:00+01	\N	\N	\N
476	\N	\N	\N	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	\N	\N
477	\N	\N	0	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	2026-11-03 09:30:00+01	\N
478	\N	\N	0	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	2026-11-03 09:30:00+01	\N
479	\N	\N	0	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	2026-11-03 09:30:00+01	\N
480	\N	\N	0	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	2026-11-03 09:30:00+01	\N
481	\N	\N	0	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	2026-11-03 09:30:00+01	\N
482	\N	\N	0	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	2026-11-03 09:30:00+01	\N
483	\N	\N	0	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	2026-11-03 09:30:00+01	\N
484	\N	\N	0	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	2026-11-03 09:30:00+01	\N
485	\N	\N	\N	2026-11-03 09:25:00+01	2026-11-03 09:25:00+01	\N	\N	\N
486	\N	\N	\N	2026-11-03 09:25:00+01	2026-11-03 09:25:00+01	\N	\N	\N
487	\N	\N	\N	2026-11-03 09:25:00+01	2026-11-03 09:25:00+01	\N	\N	\N
488	\N	\N	\N	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	\N	\N
489	\N	\N	\N	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	\N	\N
490	\N	\N	0	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	2026-11-03 09:15:00+01	\N
491	\N	\N	0	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	2026-11-03 09:15:00+01	\N
492	\N	\N	0	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	2026-11-03 09:15:00+01	\N
493	\N	\N	\N	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	\N	\N
494	\N	\N	\N	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	\N	\N
495	\N	\N	\N	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	\N	\N
496	\N	\N	0	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	2026-11-03 09:15:00+01	\N
693	3	A21	0	2026-11-03 08:00:00+01	2026-11-03 08:00:00+01	\N	2026-11-03 08:00:00+01	\N
498	1	\N	\N	2026-11-03 07:05:00+01	2026-11-03 07:05:00+01	\N	\N	\N
694	3	A21	0	2026-11-03 08:00:00+01	2026-11-03 08:00:00+01	\N	2026-11-03 08:00:00+01	\N
695	2	E10	0	2026-11-03 07:45:00+01	2026-11-03 07:45:00+01	\N	2026-11-03 07:45:00+01	\N
696	2	E10	0	2026-11-03 07:45:00+01	2026-11-03 07:45:00+01	\N	2026-11-03 07:45:00+01	\N
697	2	E10	0	2026-11-03 07:45:00+01	2026-11-03 07:45:00+01	\N	2026-11-03 07:45:00+01	\N
698	1	D32	0	2026-11-03 07:40:00+01	2026-11-03 07:40:00+01	\N	2026-11-03 07:40:00+01	\N
699	2	E12	0	2026-11-03 07:35:00+01	2026-11-03 07:35:00+01	\N	2026-11-03 07:35:00+01	\N
509	2	\N	23	2026-11-03 06:30:00+01	2026-11-03 06:30:00+01	\N	2026-11-03 06:53:00+01	\N
510	\N	\N	\N	2026-11-03 03:10:00+01	2026-11-03 03:10:00+01	\N	\N	\N
512	\N	\N	10	2026-11-03 06:25:00+01	2026-11-03 06:25:00+01	\N	2026-11-03 06:35:00+01	\N
515	\N	\N	1	2026-11-03 07:00:00+01	2026-11-03 07:00:00+01	2026-11-03 07:01:00+01	2026-11-03 07:01:00+01	2026-11-03 07:01:00+01
513	\N	1	0	2026-11-03 11:00:00+01	2026-11-03 11:00:00+01	\N	2026-11-03 11:00:00+01	\N
524	2	Q8	0	2026-11-03 03:15:00+01	2026-11-03 03:15:00+01	\N	2026-11-03 03:04:00+01	\N
514	\N	\N	0	2026-11-03 07:30:00+01	2026-11-03 07:30:00+01	\N	2026-11-03 07:30:00+01	\N
516	\N	\N	\N	2026-11-03 01:20:00+01	2026-11-03 01:20:00+01	\N	\N	\N
518	\N	\N	\N	2026-11-03 08:40:00+01	2026-11-03 08:40:00+01	\N	\N	\N
519	\N	\N	\N	2026-11-03 08:00:00+01	2026-11-03 08:00:00+01	\N	\N	\N
520	\N	\N	0	2026-11-03 07:45:00+01	2026-11-03 07:45:00+01	\N	2026-11-03 07:45:00+01	\N
521	\N	\N	0	2026-11-03 07:45:00+01	2026-11-03 07:45:00+01	\N	2026-11-03 07:45:00+01	\N
522	\N	\N	\N	2026-11-03 01:15:00+01	2026-11-03 01:15:00+01	\N	\N	\N
523	2	P9	0	2026-11-03 09:40:00+01	2026-11-03 09:40:00+01	\N	2026-11-03 09:40:00+01	\N
535	\N	\N	0	2026-11-03 11:10:00+01	2026-11-03 11:10:00+01	\N	2026-11-03 11:10:00+01	\N
689	\N	\N	\N	2026-11-03 10:25:00+01	2026-11-03 10:25:00+01	\N	\N	\N
500	\N	\N	\N	2026-11-03 03:30:00+01	2026-11-03 03:30:00+01	\N	\N	\N
525	\N	E2	7	2026-11-03 02:00:00+01	2026-11-03 02:00:00+01	\N	2026-11-03 02:07:00+01	\N
700	2	E12	0	2026-11-03 07:35:00+01	2026-11-03 07:35:00+01	\N	2026-11-03 07:35:00+01	\N
701	2	E12	0	2026-11-03 07:35:00+01	2026-11-03 07:35:00+01	\N	2026-11-03 07:35:00+01	\N
702	1	C16	0	2026-11-03 07:20:00+01	2026-11-03 07:20:00+01	\N	2026-11-03 07:20:00+01	\N
703	1	\N	0	2026-11-03 08:50:00+01	2026-11-03 08:50:00+01	\N	2026-11-03 08:50:00+01	\N
704	1	4	\N	2026-11-03 07:40:00+01	2026-11-03 07:40:00+01	\N	\N	\N
705	1	H136	0	2026-11-03 07:30:00+01	2026-11-03 07:30:00+01	\N	2026-11-03 07:30:00+01	\N
706	1	H136	0	2026-11-03 07:30:00+01	2026-11-03 07:30:00+01	\N	2026-11-03 07:30:00+01	\N
707	1	H136	0	2026-11-03 07:30:00+01	2026-11-03 07:30:00+01	\N	2026-11-03 07:30:00+01	\N
708	3	17	0	2026-11-03 09:45:00+01	2026-11-03 09:45:00+01	\N	2026-11-03 09:45:00+01	\N
709	3	17	0	2026-11-03 09:45:00+01	2026-11-03 09:45:00+01	\N	2026-11-03 09:45:00+01	\N
710	3	17	0	2026-11-03 09:45:00+01	2026-11-03 09:45:00+01	\N	2026-11-03 09:45:00+01	\N
711	3	17	0	2026-11-03 09:45:00+01	2026-11-03 09:45:00+01	\N	2026-11-03 09:45:00+01	\N
712	3	16	0	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	2026-11-03 09:30:00+01	\N
713	4	12	0	2026-11-03 09:10:00+01	2026-11-03 09:10:00+01	\N	2026-11-03 09:10:00+01	\N
714	4	12	0	2026-11-03 09:10:00+01	2026-11-03 09:10:00+01	\N	2026-11-03 09:10:00+01	\N
715	4	12	0	2026-11-03 09:10:00+01	2026-11-03 09:10:00+01	\N	2026-11-03 09:10:00+01	\N
716	4	12	0	2026-11-03 09:10:00+01	2026-11-03 09:10:00+01	\N	2026-11-03 09:10:00+01	\N
883	\N	\N	\N	2026-11-03 03:15:00+01	2026-11-03 03:15:00+01	\N	\N	\N
720	2	\N	0	2026-11-03 08:50:00+01	2026-11-03 08:50:00+01	\N	2026-11-03 08:50:00+01	\N
721	2	\N	0	2026-11-03 08:50:00+01	2026-11-03 08:50:00+01	\N	2026-11-03 08:50:00+01	\N
722	2	\N	0	2026-11-03 08:50:00+01	2026-11-03 08:50:00+01	\N	2026-11-03 08:50:00+01	\N
723	2	\N	0	2026-11-03 08:50:00+01	2026-11-03 08:50:00+01	\N	2026-11-03 08:50:00+01	\N
724	3	\N	\N	2026-11-03 08:40:00+01	2026-11-03 08:40:00+01	\N	\N	\N
725	2	\N	0	2026-11-03 08:35:00+01	2026-11-03 08:35:00+01	\N	2026-11-03 08:35:00+01	\N
726	2	\N	0	2026-11-03 08:35:00+01	2026-11-03 08:35:00+01	\N	2026-11-03 08:35:00+01	\N
727	2	\N	0	2026-11-03 08:35:00+01	2026-11-03 08:35:00+01	\N	2026-11-03 08:35:00+01	\N
730	4	12	0	2026-11-03 09:10:00+01	2026-11-03 09:10:00+01	\N	2026-11-03 09:10:00+01	\N
735	3	1C	0	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	2026-11-03 09:15:00+01	\N
555	\N	\N	133	2026-11-03 01:40:00+01	2026-11-03 01:40:00+01	2026-11-03 03:53:00+01	2026-11-03 03:53:00+01	2026-11-03 03:53:00+01
742	1	A20A	0	2026-11-03 05:00:00+01	2026-11-03 05:00:00+01	\N	2026-11-03 05:00:00+01	\N
743	1	A20A	0	2026-11-03 05:00:00+01	2026-11-03 05:00:00+01	\N	2026-11-03 05:00:00+01	\N
744	1	A20A	0	2026-11-03 05:00:00+01	2026-11-03 05:00:00+01	\N	2026-11-03 05:00:00+01	\N
745	1	A11A	0	2026-11-03 04:55:00+01	2026-11-03 04:55:00+01	\N	2026-11-03 04:55:00+01	\N
746	1	\N	\N	2026-11-03 04:50:00+01	2026-11-03 04:50:00+01	\N	\N	\N
747	1	A38A	0	2026-11-03 04:05:00+01	2026-11-03 04:05:00+01	\N	2026-11-03 04:05:00+01	\N
748	1	\N	\N	2026-11-03 03:50:00+01	2026-11-03 03:50:00+01	\N	\N	\N
749	1	A10A	0	2026-11-03 03:45:00+01	2026-11-03 03:45:00+01	\N	2026-11-03 03:45:00+01	\N
750	1	46	0	2026-11-03 09:50:00+01	2026-11-03 09:50:00+01	\N	2026-11-03 09:50:00+01	\N
752	\N	\N	0	2026-11-03 11:10:00+01	2026-11-03 11:10:00+01	\N	2026-11-03 11:10:00+01	\N
753	\N	\N	0	2026-11-03 11:10:00+01	2026-11-03 11:10:00+01	\N	2026-11-03 11:10:00+01	\N
754	\N	\N	0	2026-11-03 11:10:00+01	2026-11-03 11:10:00+01	\N	2026-11-03 11:10:00+01	\N
755	1	\N	0	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	2026-11-03 09:30:00+01	\N
756	1	\N	0	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	2026-11-03 09:30:00+01	\N
757	1	\N	0	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	2026-11-03 09:30:00+01	\N
758	1	\N	0	2026-11-03 09:25:00+01	2026-11-03 09:25:00+01	\N	2026-11-03 09:25:00+01	\N
759	1	\N	0	2026-11-03 09:25:00+01	2026-11-03 09:25:00+01	\N	2026-11-03 09:25:00+01	\N
760	1	\N	0	2026-11-03 09:20:00+01	2026-11-03 09:20:00+01	\N	2026-11-03 09:20:00+01	\N
575	\N	\N	\N	2026-11-03 01:20:00+01	2026-11-03 01:20:00+01	\N	\N	\N
761	1	\N	0	2026-11-03 09:20:00+01	2026-11-03 09:20:00+01	\N	2026-11-03 09:20:00+01	\N
762	1	\N	0	2026-11-03 09:20:00+01	2026-11-03 09:20:00+01	\N	2026-11-03 09:20:00+01	\N
763	1	\N	0	2026-11-03 09:20:00+01	2026-11-03 09:20:00+01	\N	2026-11-03 09:20:00+01	\N
764	1	\N	0	2026-11-03 09:20:00+01	2026-11-03 09:20:00+01	\N	2026-11-03 09:20:00+01	\N
765	1	\N	0	2026-11-03 09:20:00+01	2026-11-03 09:20:00+01	\N	2026-11-03 09:20:00+01	\N
766	1	\N	0	2026-11-03 09:20:00+01	2026-11-03 09:20:00+01	\N	2026-11-03 09:20:00+01	\N
767	2	\N	0	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	2026-11-03 09:15:00+01	\N
768	1	\N	0	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	2026-11-03 09:15:00+01	\N
769	1	\N	0	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	2026-11-03 09:15:00+01	\N
770	1	\N	0	2026-11-03 09:15:00+01	2026-11-03 09:15:00+01	\N	2026-11-03 09:15:00+01	\N
771	T1	\N	0	2026-11-03 08:15:00+01	2026-11-03 08:15:00+01	\N	2026-11-03 08:15:00+01	\N
772	T1	\N	0	2026-11-03 08:15:00+01	2026-11-03 08:15:00+01	\N	2026-11-03 08:15:00+01	\N
773	T1	\N	0	2026-11-03 08:00:00+01	2026-11-03 08:00:00+01	\N	2026-11-03 08:00:00+01	\N
559	\N	\N	\N	2026-11-03 10:20:00+01	2026-11-03 10:20:00+01	\N	\N	\N
775	3	C12	0	2026-11-03 03:40:00+01	2026-11-03 03:40:00+01	\N	2026-11-03 03:40:00+01	\N
776	3	C12	0	2026-11-03 03:40:00+01	2026-11-03 03:40:00+01	\N	2026-11-03 03:40:00+01	\N
777	3	C12	0	2026-11-03 03:40:00+01	2026-11-03 03:40:00+01	\N	2026-11-03 03:40:00+01	\N
778	3	C12	0	2026-11-03 03:40:00+01	2026-11-03 03:40:00+01	\N	2026-11-03 03:40:00+01	\N
779	3	C12	0	2026-11-03 03:40:00+01	2026-11-03 03:40:00+01	\N	2026-11-03 03:40:00+01	\N
780	3	C6	0	2026-11-03 03:40:00+01	2026-11-03 03:40:00+01	\N	2026-11-03 03:40:00+01	\N
596	2	\N	0	2026-11-03 03:25:00+01	2026-11-03 03:25:00+01	\N	2026-11-03 03:25:00+01	\N
781	\N	\N	\N	2026-11-03 01:55:00+01	2026-11-03 01:55:00+01	\N	\N	\N
782	\N	A3	0	2026-11-03 08:00:00+01	2026-11-03 08:00:00+01	\N	2026-11-03 08:00:00+01	\N
783	\N	A3	0	2026-11-03 08:00:00+01	2026-11-03 08:00:00+01	\N	2026-11-03 08:00:00+01	\N
784	\N	A3	0	2026-11-03 08:00:00+01	2026-11-03 08:00:00+01	\N	2026-11-03 08:00:00+01	\N
785	\N	A3	0	2026-11-03 08:00:00+01	2026-11-03 08:00:00+01	\N	2026-11-03 08:00:00+01	\N
786	\N	A3	0	2026-11-03 08:00:00+01	2026-11-03 08:00:00+01	\N	2026-11-03 08:00:00+01	\N
887	\N	\N	\N	2026-11-03 11:35:00+01	2026-11-03 11:35:00+01	\N	\N	\N
888	\N	\N	\N	2026-11-03 08:00:00+01	2026-11-03 08:00:00+01	\N	\N	\N
624	\N	\N	\N	2026-11-03 09:30:00+01	2026-11-03 09:30:00+01	\N	\N	\N
499	\N	\N	\N	2026-11-03 08:00:00+01	2026-11-03 08:00:00+01	\N	\N	\N
889	\N	\N	\N	2026-11-03 08:00:00+01	2026-11-03 08:00:00+01	\N	\N	\N
971	1	C24	0	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	2026-11-03 10:00:00+01	\N
972	1	C24	0	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	2026-11-03 10:00:00+01	\N
973	1	C24	0	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	2026-11-03 10:00:00+01	\N
974	1	C24	0	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	2026-11-03 10:00:00+01	\N
975	1	C24	0	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	2026-11-03 10:00:00+01	\N
976	1	C24	0	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	2026-11-03 10:00:00+01	\N
977	1	C24	0	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	2026-11-03 10:00:00+01	\N
978	1	C24	0	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	2026-11-03 10:00:00+01	\N
979	1	C24	0	2026-11-03 10:00:00+01	2026-11-03 10:00:00+01	\N	2026-11-03 10:00:00+01	\N
980	1	C13	0	2026-11-03 09:50:00+01	2026-11-03 09:50:00+01	\N	2026-11-03 09:50:00+01	\N
981	1	C13	0	2026-11-03 09:50:00+01	2026-11-03 09:50:00+01	\N	2026-11-03 09:50:00+01	\N
983	1	46	0	2026-11-03 09:50:00+01	2026-11-03 09:50:00+01	\N	2026-11-03 09:50:00+01	\N
984	1	46	0	2026-11-03 09:50:00+01	2026-11-03 09:50:00+01	\N	2026-11-03 09:50:00+01	\N
985	2	257	0	2026-11-03 09:50:00+01	2026-11-03 09:50:00+01	\N	2026-11-03 09:50:00+01	\N
989	T1	\N	0	2026-11-03 08:45:00+01	2026-11-03 08:45:00+01	\N	2026-11-03 08:45:00+01	\N
990	T2	\N	0	2026-11-03 08:35:00+01	2026-11-03 08:35:00+01	\N	2026-11-03 08:35:00+01	\N
991	T2	\N	0	2026-11-03 08:35:00+01	2026-11-03 08:35:00+01	\N	2026-11-03 08:35:00+01	\N
992	T2	\N	0	2026-11-03 08:35:00+01	2026-11-03 08:35:00+01	\N	2026-11-03 08:35:00+01	\N
993	2	\N	0	2026-11-03 08:30:00+01	2026-11-03 08:30:00+01	\N	2026-11-03 08:30:00+01	\N
994	2	\N	0	2026-11-03 08:30:00+01	2026-11-03 08:30:00+01	\N	2026-11-03 08:30:00+01	\N
896	\N	\N	\N	2026-11-03 11:10:00+01	2026-11-03 11:10:00+01	\N	\N	\N
996	3	C17	0	2026-11-03 04:05:00+01	2026-11-03 04:05:00+01	\N	2026-11-03 04:05:00+01	\N
997	2	F3	0	2026-11-03 04:00:00+01	2026-11-03 04:00:00+01	\N	2026-11-03 04:00:00+01	\N
998	3	A10	0	2026-11-03 04:00:00+01	2026-11-03 04:00:00+01	\N	2026-11-03 04:00:00+01	\N
970	\N	\N	\N	2026-11-03 05:30:00+01	2026-11-03 05:30:00+01	\N	\N	\N
1109	T3	\N	\N	2026-11-05 07:45:00+01	2026-11-05 07:45:00+01	\N	\N	\N
1113	1	\N	0	2026-11-05 09:00:00+01	2026-11-05 09:00:00+01	\N	2026-11-05 09:00:00+01	\N
1114	1	\N	0	2026-11-05 09:00:00+01	2026-11-05 09:00:00+01	\N	2026-11-05 09:00:00+01	\N
1115	1	\N	0	2026-11-05 09:00:00+01	2026-11-05 09:00:00+01	\N	2026-11-05 09:00:00+01	\N
1116	4	16	0	2026-11-05 09:00:00+01	2026-11-05 09:00:00+01	\N	2026-11-05 09:00:00+01	\N
1117	4	16	0	2026-11-05 09:00:00+01	2026-11-05 09:00:00+01	\N	2026-11-05 09:00:00+01	\N
1118	3	D32	0	2026-11-05 08:30:00+01	2026-11-05 08:30:00+01	\N	2026-11-05 08:30:00+01	\N
1119	3	E16	0	2026-11-05 08:30:00+01	2026-11-05 08:30:00+01	\N	2026-11-05 08:30:00+01	\N
1120	3	C07	0	2026-11-05 08:25:00+01	2026-11-05 08:25:00+01	\N	2026-11-05 08:25:00+01	\N
1121	3	C53	0	2026-11-05 08:25:00+01	2026-11-05 08:25:00+01	\N	2026-11-05 08:25:00+01	\N
1122	\N	\N	10	2026-11-05 06:05:00+01	2026-11-05 06:05:00+01	\N	2026-11-05 06:15:00+01	\N
1123	\N	\N	10	2026-11-05 05:40:00+01	2026-11-05 05:40:00+01	\N	2026-11-05 05:50:00+01	\N
1124	\N	\N	\N	2026-11-05 08:40:00+01	2026-11-05 08:40:00+01	\N	\N	\N
1125	\N	\N	\N	2026-11-05 08:25:00+01	2026-11-05 08:25:00+01	\N	\N	\N
1126	\N	\N	0	2026-11-05 04:35:00+01	2026-11-05 04:35:00+01	\N	2026-11-05 01:14:00+01	\N
1127	\N	\N	\N	2026-11-05 08:45:00+01	2026-11-05 08:45:00+01	\N	\N	\N
1128	\N	\N	0	2026-11-05 08:45:00+01	2026-11-05 08:45:00+01	\N	2026-11-05 08:45:00+01	\N
1129	\N	\N	0	2026-11-05 10:00:00+01	2026-11-05 10:00:00+01	\N	2026-11-05 10:00:00+01	\N
1130	2	F35	0	2026-11-05 07:20:00+01	2026-11-05 07:20:00+01	\N	2026-11-05 07:20:00+01	\N
1131	2	F35	0	2026-11-05 07:20:00+01	2026-11-05 07:20:00+01	\N	2026-11-05 07:20:00+01	\N
1132	2	F35	0	2026-11-05 07:20:00+01	2026-11-05 07:20:00+01	\N	2026-11-05 07:20:00+01	\N
1133	2	F35	0	2026-11-05 07:20:00+01	2026-11-05 07:20:00+01	\N	2026-11-05 07:20:00+01	\N
1134	1	123	0	2026-11-05 09:30:00+01	2026-11-05 09:30:00+01	\N	2026-11-05 09:30:00+01	\N
1135	1	123	0	2026-11-05 09:30:00+01	2026-11-05 09:30:00+01	\N	2026-11-05 09:30:00+01	\N
1136	2	238	0	2026-11-05 09:30:00+01	2026-11-05 09:30:00+01	\N	2026-11-05 09:30:00+01	\N
1137	2	238	0	2026-11-05 09:30:00+01	2026-11-05 09:30:00+01	\N	2026-11-05 09:30:00+01	\N
1138	2	238	0	2026-11-05 09:30:00+01	2026-11-05 09:30:00+01	\N	2026-11-05 09:30:00+01	\N
1139	2	209	0	2026-11-05 09:30:00+01	2026-11-05 09:30:00+01	\N	2026-11-05 09:30:00+01	\N
1140	A	A05	\N	2026-11-05 02:35:00+01	2026-11-05 02:35:00+01	\N	\N	\N
1141	A	A05	\N	2026-11-05 02:35:00+01	2026-11-05 02:35:00+01	\N	\N	\N
1142	A	A05	\N	2026-11-05 02:35:00+01	2026-11-05 02:35:00+01	\N	\N	\N
1143	4	\N	0	2026-11-05 03:10:00+01	2026-11-05 03:10:00+01	\N	2026-11-05 03:10:00+01	\N
1144	1	\N	\N	2026-11-05 03:00:00+01	2026-11-05 03:00:00+01	\N	\N	\N
1145	1	\N	\N	2026-11-05 03:00:00+01	2026-11-05 03:00:00+01	\N	\N	\N
1146	1	\N	\N	2026-11-05 03:00:00+01	2026-11-05 03:00:00+01	\N	\N	\N
1147	1	\N	\N	2026-11-05 03:00:00+01	2026-11-05 03:00:00+01	\N	\N	\N
1148	1	A6B	0	2026-11-05 03:00:00+01	2026-11-05 03:00:00+01	\N	2026-11-05 03:00:00+01	\N
1149	1	A33	0	2026-11-05 02:55:00+01	2026-11-05 02:55:00+01	\N	2026-11-05 02:55:00+01	\N
1150	3	\N	\N	2026-11-05 08:10:00+01	2026-11-05 08:10:00+01	\N	\N	\N
1151	\N	\N	\N	2026-11-05 11:05:00+01	2026-11-05 11:05:00+01	\N	\N	\N
1152	T1	\N	0	2026-11-05 07:55:00+01	2026-11-05 07:55:00+01	\N	2026-11-05 07:55:00+01	\N
1153	T1	\N	0	2026-11-05 07:45:00+01	2026-11-05 07:45:00+01	\N	2026-11-05 07:45:00+01	\N
1154	T1	\N	\N	2026-11-05 07:40:00+01	2026-11-05 07:40:00+01	\N	\N	\N
1155	T1	\N	\N	2026-11-05 07:40:00+01	2026-11-05 07:40:00+01	\N	\N	\N
1156	T1	\N	\N	2026-11-05 07:40:00+01	2026-11-05 07:40:00+01	\N	\N	\N
1157	T2	\N	0	2026-11-05 07:35:00+01	2026-11-05 07:35:00+01	\N	2026-11-05 07:35:00+01	\N
1158	T2	\N	0	2026-11-05 07:35:00+01	2026-11-05 07:35:00+01	\N	2026-11-05 07:35:00+01	\N
1159	T2	\N	0	2026-11-05 07:35:00+01	2026-11-05 07:35:00+01	\N	2026-11-05 07:35:00+01	\N
1160	T1	\N	0	2026-11-05 07:30:00+01	2026-11-05 07:30:00+01	\N	2026-11-05 07:30:00+01	\N
1163	T3	\N	\N	2026-11-05 07:50:00+01	2026-11-05 07:50:00+01	\N	\N	\N
1164	T3	\N	\N	2026-11-05 07:50:00+01	2026-11-05 07:50:00+01	\N	\N	\N
1165	T3	\N	\N	2026-11-05 07:50:00+01	2026-11-05 07:50:00+01	\N	\N	\N
1166	T3	\N	\N	2026-11-05 07:50:00+01	2026-11-05 07:50:00+01	\N	\N	\N
1167	T3	\N	\N	2026-11-05 07:50:00+01	2026-11-05 07:50:00+01	\N	\N	\N
1168	1	D40	0	2026-11-05 04:00:00+01	2026-11-05 04:00:00+01	\N	2026-11-05 04:00:00+01	\N
1169	1	D41	0	2026-11-05 03:45:00+01	2026-11-05 03:45:00+01	\N	2026-11-05 03:45:00+01	\N
1170	3	A17	0	2026-11-05 03:45:00+01	2026-11-05 03:45:00+01	\N	2026-11-05 03:45:00+01	\N
1171	3	A17	0	2026-11-05 03:45:00+01	2026-11-05 03:45:00+01	\N	2026-11-05 03:45:00+01	\N
1172	3	A17	0	2026-11-05 03:45:00+01	2026-11-05 03:45:00+01	\N	2026-11-05 03:45:00+01	\N
1173	3	B7	0	2026-11-05 03:35:00+01	2026-11-05 03:35:00+01	\N	2026-11-05 03:35:00+01	\N
1174	2	F50	0	2026-11-05 03:30:00+01	2026-11-05 03:30:00+01	\N	2026-11-05 03:30:00+01	\N
1175	2	F50	0	2026-11-05 03:30:00+01	2026-11-05 03:30:00+01	\N	2026-11-05 03:30:00+01	\N
1176	2	F50	0	2026-11-05 03:30:00+01	2026-11-05 03:30:00+01	\N	2026-11-05 03:30:00+01	\N
1177	1	C20	60	2026-11-05 03:30:00+01	2026-11-05 03:30:00+01	\N	2026-11-05 04:30:00+01	\N
1178	1	C20	60	2026-11-05 03:30:00+01	2026-11-05 03:30:00+01	\N	2026-11-05 04:30:00+01	\N
1179	1	C20	60	2026-11-05 03:30:00+01	2026-11-05 03:30:00+01	\N	2026-11-05 04:30:00+01	\N
1180	1	C20	60	2026-11-05 03:30:00+01	2026-11-05 03:30:00+01	\N	2026-11-05 04:30:00+01	\N
1181	3	A4	0	2026-11-05 03:25:00+01	2026-11-05 03:25:00+01	\N	2026-11-05 03:25:00+01	\N
1182	3	A4	0	2026-11-05 03:25:00+01	2026-11-05 03:25:00+01	\N	2026-11-05 03:25:00+01	\N
1183	3	A4	0	2026-11-05 03:25:00+01	2026-11-05 03:25:00+01	\N	2026-11-05 03:25:00+01	\N
1161	\N	\N	\N	2026-11-05 03:30:00+01	2026-11-05 03:30:00+01	\N	\N	\N
1162	T3	\N	\N	2026-11-05 07:50:00+01	2026-11-05 07:50:00+01	\N	\N	\N
999	3	A10	0	2026-11-03 04:00:00+01	2026-11-03 04:00:00+01	\N	2026-11-03 04:00:00+01	\N
1000	3	A10	0	2026-11-03 04:00:00+01	2026-11-03 04:00:00+01	\N	2026-11-03 04:00:00+01	\N
1001	3	A23	0	2026-11-03 03:55:00+01	2026-11-03 03:55:00+01	\N	2026-11-03 03:55:00+01	\N
1002	3	A3	0	2026-11-03 03:55:00+01	2026-11-03 03:55:00+01	\N	2026-11-03 03:55:00+01	\N
1003	1	D16	0	2026-11-03 03:50:00+01	2026-11-03 03:50:00+01	\N	2026-11-03 03:50:00+01	\N
1004	1	D16	0	2026-11-03 03:50:00+01	2026-11-03 03:50:00+01	\N	2026-11-03 03:50:00+01	\N
1005	1	D16	0	2026-11-03 03:50:00+01	2026-11-03 03:50:00+01	\N	2026-11-03 03:50:00+01	\N
1006	3	B27	0	2026-11-03 03:50:00+01	2026-11-03 03:50:00+01	\N	2026-11-03 03:50:00+01	\N
1007	3	B27	0	2026-11-03 03:50:00+01	2026-11-03 03:50:00+01	\N	2026-11-03 03:50:00+01	\N
1008	3	B27	0	2026-11-03 03:50:00+01	2026-11-03 03:50:00+01	\N	2026-11-03 03:50:00+01	\N
1009	3	B28	0	2026-11-03 03:50:00+01	2026-11-03 03:50:00+01	\N	2026-11-03 03:50:00+01	\N
1010	3	B28	0	2026-11-03 03:50:00+01	2026-11-03 03:50:00+01	\N	2026-11-03 03:50:00+01	\N
1011	3	A22	0	2026-11-03 03:45:00+01	2026-11-03 03:45:00+01	\N	2026-11-03 03:45:00+01	\N
1012	3	A22	0	2026-11-03 03:45:00+01	2026-11-03 03:45:00+01	\N	2026-11-03 03:45:00+01	\N
1013	3	A22	0	2026-11-03 03:45:00+01	2026-11-03 03:45:00+01	\N	2026-11-03 03:45:00+01	\N
1014	3	C12	0	2026-11-03 03:40:00+01	2026-11-03 03:40:00+01	\N	2026-11-03 03:40:00+01	\N
1015	3	\N	\N	2026-11-03 08:00:00+01	2026-11-03 08:00:00+01	\N	\N	\N
1016	3	\N	\N	2026-11-03 08:00:00+01	2026-11-03 08:00:00+01	\N	\N	\N
1017	3	\N	\N	2026-11-03 08:00:00+01	2026-11-03 08:00:00+01	\N	\N	\N
1018	\N	\N	0	2026-11-03 02:10:00+01	2026-11-03 02:10:00+01	\N	2026-11-03 02:10:00+01	\N
1019	\N	\N	0	2026-11-03 02:10:00+01	2026-11-03 02:10:00+01	\N	2026-11-03 02:10:00+01	\N
1020	\N	\N	0	2026-11-03 02:10:00+01	2026-11-03 02:10:00+01	\N	2026-11-03 02:10:00+01	\N
1021	\N	\N	0	2026-11-03 02:10:00+01	2026-11-03 02:10:00+01	\N	2026-11-03 02:10:00+01	\N
1022	\N	\N	0	2026-11-03 02:10:00+01	2026-11-03 02:10:00+01	\N	2026-11-03 02:10:00+01	\N
1023	\N	\N	0	2026-11-03 02:10:00+01	2026-11-03 02:10:00+01	\N	2026-11-03 02:10:00+01	\N
1024	\N	\N	0	2026-11-03 02:10:00+01	2026-11-03 02:10:00+01	\N	2026-11-03 02:10:00+01	\N
1025	\N	\N	0	2026-11-03 02:10:00+01	2026-11-03 02:10:00+01	\N	2026-11-03 02:10:00+01	\N
1026	\N	\N	0	2026-11-03 02:10:00+01	2026-11-03 02:10:00+01	\N	2026-11-03 02:10:00+01	\N
1027	\N	\N	0	2026-11-03 02:10:00+01	2026-11-03 02:10:00+01	\N	2026-11-03 02:10:00+01	\N
1028	\N	\N	0	2026-11-03 02:10:00+01	2026-11-03 02:10:00+01	\N	2026-11-03 02:10:00+01	\N
1029	\N	\N	0	2026-11-03 02:10:00+01	2026-11-03 02:10:00+01	\N	2026-11-03 02:10:00+01	\N
1030	\N	\N	0	2026-11-03 02:10:00+01	2026-11-03 02:10:00+01	\N	2026-11-03 02:10:00+01	\N
1031	\N	\N	0	2026-11-03 02:10:00+01	2026-11-03 02:10:00+01	\N	2026-11-03 02:10:00+01	\N
1032	\N	\N	0	2026-11-03 02:10:00+01	2026-11-03 02:10:00+01	\N	2026-11-03 02:10:00+01	\N
1033	\N	\N	0	2026-11-03 02:10:00+01	2026-11-03 02:10:00+01	\N	2026-11-03 02:10:00+01	\N
1034	\N	\N	0	2026-11-03 02:10:00+01	2026-11-03 02:10:00+01	\N	2026-11-03 02:10:00+01	\N
1035	\N	\N	0	2026-11-03 02:10:00+01	2026-11-03 02:10:00+01	\N	2026-11-03 02:10:00+01	\N
1036	\N	\N	0	2026-11-03 02:10:00+01	2026-11-03 02:10:00+01	\N	2026-11-03 02:10:00+01	\N
1037	\N	\N	0	2026-11-03 02:10:00+01	2026-11-03 02:10:00+01	\N	2026-11-03 02:10:00+01	\N
1038	\N	\N	0	2026-11-03 02:00:00+01	2026-11-03 02:00:00+01	\N	2026-11-03 02:00:00+01	\N
1039	\N	\N	0	2026-11-03 02:00:00+01	2026-11-03 02:00:00+01	\N	2026-11-03 02:00:00+01	\N
1040	\N	\N	0	2026-11-03 02:00:00+01	2026-11-03 02:00:00+01	\N	2026-11-03 02:00:00+01	\N
1041	\N	\N	0	2026-11-03 02:00:00+01	2026-11-03 02:00:00+01	\N	2026-11-03 02:00:00+01	\N
1042	\N	\N	0	2026-11-03 02:00:00+01	2026-11-03 02:00:00+01	\N	2026-11-03 02:00:00+01	\N
1043	\N	\N	0	2026-11-03 02:00:00+01	2026-11-03 02:00:00+01	\N	2026-11-03 02:00:00+01	\N
1044	\N	\N	0	2026-11-03 02:00:00+01	2026-11-03 02:00:00+01	\N	2026-11-03 02:00:00+01	\N
1045	\N	\N	0	2026-11-03 02:00:00+01	2026-11-03 02:00:00+01	\N	2026-11-03 02:00:00+01	\N
1046	\N	\N	0	2026-11-03 02:00:00+01	2026-11-03 02:00:00+01	\N	2026-11-03 02:00:00+01	\N
1047	\N	\N	\N	2026-11-03 02:00:00+01	2026-11-03 02:00:00+01	\N	\N	\N
1048	\N	\N	\N	2026-11-03 02:00:00+01	2026-11-03 02:00:00+01	\N	\N	\N
1049	\N	\N	\N	2026-11-03 02:00:00+01	2026-11-03 02:00:00+01	\N	\N	\N
1050	\N	\N	\N	2026-11-03 02:00:00+01	2026-11-03 02:00:00+01	\N	\N	\N
1051	\N	\N	\N	2026-11-03 02:00:00+01	2026-11-03 02:00:00+01	\N	\N	\N
1052	\N	\N	\N	2026-11-03 02:00:00+01	2026-11-03 02:00:00+01	\N	\N	\N
1053	\N	\N	0	2026-11-03 01:55:00+01	2026-11-03 01:55:00+01	\N	2026-11-03 01:55:00+01	\N
1054	\N	\N	0	2026-11-03 01:55:00+01	2026-11-03 01:55:00+01	\N	2026-11-03 01:55:00+01	\N
1055	\N	\N	55	2026-11-03 01:55:00+01	2026-11-03 01:55:00+01	\N	2026-11-03 02:50:00+01	\N
1056	\N	\N	55	2026-11-03 01:55:00+01	2026-11-03 01:55:00+01	\N	2026-11-03 02:50:00+01	\N
1057	\N	\N	55	2026-11-03 01:55:00+01	2026-11-03 01:55:00+01	\N	2026-11-03 02:50:00+01	\N
1058	\N	\N	55	2026-11-03 01:55:00+01	2026-11-03 01:55:00+01	\N	2026-11-03 02:50:00+01	\N
1059	\N	\N	55	2026-11-03 01:55:00+01	2026-11-03 01:55:00+01	\N	2026-11-03 02:50:00+01	\N
1060	\N	\N	55	2026-11-03 01:55:00+01	2026-11-03 01:55:00+01	\N	2026-11-03 02:50:00+01	\N
1061	\N	\N	0	2026-11-03 01:50:00+01	2026-11-03 01:50:00+01	\N	2026-11-03 01:50:00+01	\N
1062	\N	\N	0	2026-11-03 01:50:00+01	2026-11-03 01:50:00+01	\N	2026-11-03 01:50:00+01	\N
1063	\N	\N	0	2026-11-03 01:50:00+01	2026-11-03 01:50:00+01	\N	2026-11-03 01:50:00+01	\N
1064	\N	\N	0	2026-11-03 01:50:00+01	2026-11-03 01:50:00+01	\N	2026-11-03 01:50:00+01	\N
1065	3	\N	0	2026-11-03 07:40:00+01	2026-11-03 07:40:00+01	\N	2026-11-03 07:40:00+01	\N
1066	3	9	0	2026-11-03 07:35:00+01	2026-11-03 07:35:00+01	\N	2026-11-03 07:35:00+01	\N
1067	3	9	0	2026-11-03 07:35:00+01	2026-11-03 07:35:00+01	\N	2026-11-03 07:35:00+01	\N
1068	3	9	0	2026-11-03 07:35:00+01	2026-11-03 07:35:00+01	\N	2026-11-03 07:35:00+01	\N
1106	T3	\N	\N	2026-11-05 07:45:00+01	2026-11-05 07:45:00+01	\N	\N	\N
1107	T3	\N	\N	2026-11-05 07:45:00+01	2026-11-05 07:45:00+01	\N	\N	\N
1108	T3	\N	\N	2026-11-05 07:45:00+01	2026-11-05 07:45:00+01	\N	\N	\N
1074	3	\N	\N	2026-11-05 07:55:00+01	2026-11-05 07:55:00+01	\N	\N	\N
1075	3	\N	\N	2026-11-05 07:55:00+01	2026-11-05 07:55:00+01	\N	\N	\N
1076	3	\N	\N	2026-11-05 07:55:00+01	2026-11-05 07:55:00+01	\N	\N	\N
1077	3	\N	\N	2026-11-05 07:55:00+01	2026-11-05 07:55:00+01	\N	\N	\N
1078	\N	\N	0	2026-11-05 05:00:00+01	2026-11-05 05:00:00+01	\N	2026-11-05 02:22:00+01	\N
1079	\N	\N	10	2026-11-05 01:05:00+01	2026-11-05 01:05:00+01	\N	2026-11-05 01:15:00+01	\N
1080	2	\N	\N	2026-11-05 07:15:00+01	2026-11-05 07:15:00+01	\N	\N	\N
1081	2	\N	\N	2026-11-05 07:15:00+01	2026-11-05 07:15:00+01	\N	\N	\N
1082	2	\N	\N	2026-11-05 07:15:00+01	2026-11-05 07:15:00+01	\N	\N	\N
1083	2	\N	\N	2026-11-05 07:15:00+01	2026-11-05 07:15:00+01	\N	\N	\N
1084	2	\N	\N	2026-11-05 07:15:00+01	2026-11-05 07:15:00+01	\N	\N	\N
1085	2	\N	\N	2026-11-05 07:15:00+01	2026-11-05 07:15:00+01	\N	\N	\N
1087	2	\N	\N	2026-11-05 07:10:00+01	2026-11-05 07:10:00+01	\N	\N	\N
1088	2	\N	\N	2026-11-05 07:10:00+01	2026-11-05 07:10:00+01	\N	\N	\N
1089	2	\N	\N	2026-11-05 07:10:00+01	2026-11-05 07:10:00+01	\N	\N	\N
1090	2	\N	\N	2026-11-05 07:10:00+01	2026-11-05 07:10:00+01	\N	\N	\N
1091	2	\N	\N	2026-11-05 07:10:00+01	2026-11-05 07:10:00+01	\N	\N	\N
1092	2	\N	0	2026-11-05 06:05:00+01	2026-11-05 06:05:00+01	\N	2026-11-05 06:05:00+01	\N
1093	2	\N	0	2026-11-05 06:05:00+01	2026-11-05 06:05:00+01	\N	2026-11-05 06:05:00+01	\N
1094	\N	G1	15	2026-11-05 03:25:00+01	2026-11-05 03:25:00+01	\N	2026-11-05 03:40:00+01	\N
1095	\N	G1	15	2026-11-05 03:25:00+01	2026-11-05 03:25:00+01	\N	2026-11-05 03:40:00+01	\N
1096	\N	G1	15	2026-11-05 03:25:00+01	2026-11-05 03:25:00+01	\N	2026-11-05 03:40:00+01	\N
1097	\N	G1	15	2026-11-05 03:25:00+01	2026-11-05 03:25:00+01	\N	2026-11-05 03:40:00+01	\N
1098	\N	G1	15	2026-11-05 03:25:00+01	2026-11-05 03:25:00+01	\N	2026-11-05 03:40:00+01	\N
1099	\N	G1	15	2026-11-05 03:25:00+01	2026-11-05 03:25:00+01	\N	2026-11-05 03:40:00+01	\N
1100	\N	\N	45	2026-11-05 03:20:00+01	2026-11-05 03:20:00+01	\N	2026-11-05 04:05:00+01	\N
1102	\N	\N	\N	2026-11-05 09:40:00+01	2026-11-05 09:40:00+01	\N	\N	\N
1103	T3	\N	\N	2026-11-05 07:45:00+01	2026-11-05 07:45:00+01	\N	\N	\N
1104	T3	\N	\N	2026-11-05 07:45:00+01	2026-11-05 07:45:00+01	\N	\N	\N
1105	T3	\N	0	2026-11-05 07:45:00+01	2026-11-05 07:45:00+01	\N	2026-11-05 07:45:00+01	\N
1071	3	A24	0	2026-11-05 03:25:00+01	2026-11-05 03:25:00+01	\N	2026-11-05 03:25:00+01	\N
1072	3	26	0	2026-11-05 05:35:00+01	2026-11-05 05:35:00+01	\N	2026-11-05 05:35:00+01	\N
1073	3	\N	\N	2026-11-05 07:55:00+01	2026-11-05 07:55:00+01	\N	\N	\N
1086	2	\N	\N	2026-11-05 07:15:00+01	2026-11-05 07:15:00+01	\N	\N	\N
1101	\N	\N	45	2026-11-05 03:20:00+01	2026-11-05 03:20:00+01	\N	2026-11-05 04:05:00+01	\N
1184	3	A4	0	2026-11-05 03:25:00+01	2026-11-05 03:25:00+01	\N	2026-11-05 03:25:00+01	\N
1185	3	A4	0	2026-11-05 03:25:00+01	2026-11-05 03:25:00+01	\N	2026-11-05 03:25:00+01	\N
1186	1	C18	0	2026-11-05 03:20:00+01	2026-11-05 03:20:00+01	\N	2026-11-05 03:20:00+01	\N
1187	1	C18	0	2026-11-05 03:20:00+01	2026-11-05 03:20:00+01	\N	2026-11-05 03:20:00+01	\N
1188	1	C18	0	2026-11-05 03:20:00+01	2026-11-05 03:20:00+01	\N	2026-11-05 03:20:00+01	\N
1189	1	C18	0	2026-11-05 03:20:00+01	2026-11-05 03:20:00+01	\N	2026-11-05 03:20:00+01	\N
1190	1	C18	0	2026-11-05 03:20:00+01	2026-11-05 03:20:00+01	\N	2026-11-05 03:20:00+01	\N
1191	1	C18	0	2026-11-05 03:20:00+01	2026-11-05 03:20:00+01	\N	2026-11-05 03:20:00+01	\N
1192	3	B8	0	2026-11-05 03:15:00+01	2026-11-05 03:15:00+01	\N	2026-11-05 03:15:00+01	\N
1193	3	B8	0	2026-11-05 03:15:00+01	2026-11-05 03:15:00+01	\N	2026-11-05 03:15:00+01	\N
1194	3	B9	0	2026-11-05 03:10:00+01	2026-11-05 03:10:00+01	\N	2026-11-05 03:10:00+01	\N
1195	\N	\N	\N	2026-11-05 02:00:00+01	2026-11-05 02:00:00+01	\N	\N	\N
1196	\N	\N	\N	2026-11-05 01:55:00+01	2026-11-05 01:55:00+01	\N	\N	\N
1197	\N	\N	15	2026-11-05 03:00:00+01	2026-11-05 03:00:00+01	\N	2026-11-05 03:15:00+01	\N
1198	3	D32	0	2026-11-05 08:30:00+01	2026-11-05 08:30:00+01	\N	2026-11-05 08:30:00+01	\N
1199	3	D32	0	2026-11-05 08:30:00+01	2026-11-05 08:30:00+01	\N	2026-11-05 08:30:00+01	\N
1200	\N	\N	\N	2026-11-05 10:40:00+01	2026-11-05 10:40:00+01	\N	\N	\N
1201	\N	\N	\N	2026-11-05 10:40:00+01	2026-11-05 10:40:00+01	\N	\N	\N
1202	\N	\N	\N	2026-11-05 10:40:00+01	2026-11-05 10:40:00+01	\N	\N	\N
1203	1	A19B	0	2026-11-05 03:30:00+01	2026-11-05 03:30:00+01	\N	2026-11-05 03:30:00+01	\N
1204	1	A21A	0	2026-11-05 03:25:00+01	2026-11-05 03:25:00+01	\N	2026-11-05 03:25:00+01	\N
1205	1	A46	0	2026-11-05 03:25:00+01	2026-11-05 03:25:00+01	\N	2026-11-05 03:25:00+01	\N
1206	1	A7B	0	2026-11-05 03:20:00+01	2026-11-05 03:20:00+01	\N	2026-11-05 03:20:00+01	\N
1207	1	A7B	0	2026-11-05 03:20:00+01	2026-11-05 03:20:00+01	\N	2026-11-05 03:20:00+01	\N
1208	1	A7B	0	2026-11-05 03:20:00+01	2026-11-05 03:20:00+01	\N	2026-11-05 03:20:00+01	\N
1209	1	A42A	0	2026-11-05 03:20:00+01	2026-11-05 03:20:00+01	\N	2026-11-05 03:20:00+01	\N
1210	1	A42A	0	2026-11-05 03:20:00+01	2026-11-05 03:20:00+01	\N	2026-11-05 03:20:00+01	\N
1211	1	A40A	0	2026-11-05 03:10:00+01	2026-11-05 03:10:00+01	\N	2026-11-05 03:10:00+01	\N
1399	\N	\N	\N	2026-11-05 02:35:00+01	2026-11-05 02:35:00+01	\N	\N	\N
1212	1	21	0	2026-11-05 08:35:00+01	2026-11-05 08:35:00+01	\N	2026-11-05 08:35:00+01	\N
1213	1	21	0	2026-11-05 08:35:00+01	2026-11-05 08:35:00+01	\N	2026-11-05 08:35:00+01	\N
1214	1	21	0	2026-11-05 08:35:00+01	2026-11-05 08:35:00+01	\N	2026-11-05 08:35:00+01	\N
1215	\N	\N	\N	2026-11-05 10:45:00+01	2026-11-05 10:45:00+01	\N	\N	\N
1216	\N	\N	10	2026-11-05 01:55:00+01	2026-11-05 01:55:00+01	\N	2026-11-05 02:05:00+01	\N
1217	5	\N	15	2026-11-05 01:35:00+01	2026-11-05 01:35:00+01	\N	2026-11-05 01:50:00+01	\N
1070	3	A24	0	2026-11-05 03:25:00+01	2026-11-05 03:25:00+01	\N	2026-11-05 03:25:00+01	\N
\.


--
-- Data for Name: flight; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flight (flight_id, flight_date, flight_status, airline_id, flight_number, departure_airport_id, arrival_airport_id, aircraft_id, updated_at) FROM stdin;
1	2026-10-26	scheduled	1	80	1	2	1	2026-10-25 16:09:24.567507+01
2	2026-10-26	scheduled	2	4666	3	4	2	2026-10-25 16:09:24.623085+01
3	2026-10-26	scheduled	3	4803	3	4	2	2026-10-25 16:09:24.630092+01
4	2026-10-26	scheduled	4	1709	3	4	2	2026-10-25 16:09:24.635474+01
5	2026-10-26	scheduled	5	5509	3	4	2	2026-10-25 16:09:24.64067+01
6	2026-10-26	scheduled	6	6407	3	4	6	2026-10-25 16:09:24.646763+01
7	2026-10-26	scheduled	4	7030	3	14	7	2026-10-25 16:09:24.651969+01
8	2026-10-26	scheduled	8	1758	15	16	8	2026-10-25 16:09:24.656997+01
9	2026-10-26	scheduled	\N	0	17	18	9	2026-10-25 16:09:24.662555+01
10	2026-10-26	scheduled	9	8773	19	20	10	2026-10-25 16:09:24.667314+01
11	2026-10-26	scheduled	10	5256	19	22	11	2026-10-25 16:09:24.673102+01
12	2026-10-26	scheduled	11	4036	19	22	11	2026-10-25 16:09:24.678251+01
13	2026-10-26	scheduled	12	8653	19	26	\N	2026-10-25 16:09:24.681763+01
14	2026-10-26	scheduled	13	5755	19	28	\N	2026-10-25 16:09:24.685426+01
15	2026-10-26	scheduled	14	5268	19	28	\N	2026-10-25 16:09:24.688394+01
16	2026-10-26	scheduled	3	8744	19	32	13	2026-10-25 16:09:24.693182+01
17	2026-10-26	scheduled	10	4410	19	4	14	2026-10-25 16:09:24.69804+01
18	2026-10-26	scheduled	11	4048	19	4	14	2026-10-25 16:09:24.70288+01
19	2026-10-26	scheduled	14	6227	19	38	16	2026-10-25 16:09:24.706165+01
20	2026-10-26	scheduled	19	4905	19	38	16	2026-10-25 16:09:24.710888+01
21	2026-10-26	scheduled	12	8591	19	42	\N	2026-10-25 16:09:24.71377+01
22	2026-10-26	scheduled	21	5401	22	3	18	2026-10-25 16:09:24.716666+01
23	2026-10-26	scheduled	4	7130	22	3	18	2026-10-25 16:09:24.719717+01
24	2026-10-26	scheduled	23	9015	22	3	18	2026-10-25 16:09:24.722331+01
25	2026-10-26	scheduled	2	4820	22	3	18	2026-10-25 16:09:24.725312+01
26	2026-10-26	scheduled	5	5604	22	3	18	2026-10-25 16:09:24.727284+01
27	2026-10-26	scheduled	26	5145	22	4	23	2026-10-25 16:09:24.730343+01
28	2026-10-26	scheduled	3	4881	22	4	23	2026-10-25 16:09:24.733442+01
29	2026-10-26	scheduled	4	1810	22	4	23	2026-10-25 16:09:24.73677+01
30	2026-10-26	scheduled	29	4587	22	4	23	2026-10-25 16:09:24.744926+01
31	2026-10-26	scheduled	5	5410	22	4	23	2026-10-25 16:09:24.748204+01
32	2026-10-26	scheduled	11	5425	22	64	\N	2026-10-25 16:09:24.750791+01
33	2026-10-26	scheduled	32	3834	22	64	\N	2026-10-25 16:09:24.756221+01
34	2026-10-26	scheduled	2	4530	22	64	\N	2026-10-25 16:09:24.760382+01
35	2026-10-26	scheduled	12	8899	22	64	\N	2026-10-25 16:09:24.763324+01
36	2026-10-26	scheduled	32	4053	22	64	\N	2026-10-25 16:09:24.765157+01
37	2026-10-26	scheduled	36	9665	22	64	\N	2026-10-25 16:09:24.766926+01
38	2026-10-26	scheduled	26	5144	22	4	28	2026-10-25 16:09:24.76898+01
39	2026-10-26	scheduled	2	4621	22	4	28	2026-10-25 16:09:24.771213+01
40	2026-10-26	scheduled	23	9093	22	4	28	2026-10-25 16:09:24.775267+01
41	2026-10-26	scheduled	4	1808	22	4	28	2026-10-25 16:09:24.777181+01
42	2026-10-26	scheduled	5	5408	22	4	28	2026-10-25 16:09:24.779378+01
43	2026-10-26	scheduled	29	4583	22	4	28	2026-10-25 16:09:24.781268+01
44	2026-10-26	scheduled	43	7440	22	4	28	2026-10-25 16:09:24.78467+01
45	2026-10-26	scheduled	44	5010	89	90	\N	2026-10-25 16:09:24.788643+01
46	2026-10-26	scheduled	45	4196	91	92	\N	2026-10-25 16:09:24.791053+01
47	2026-10-26	scheduled	46	4862	91	92	\N	2026-10-25 16:09:24.793183+01
48	2026-10-26	scheduled	47	2862	91	92	\N	2026-10-25 16:09:24.794738+01
49	2026-10-26	scheduled	1	36	19	2	35	2026-10-25 16:09:24.796972+01
50	2026-10-26	scheduled	36	8267	22	32	36	2026-10-25 16:09:24.799922+01
51	2026-10-26	scheduled	2	4918	22	32	36	2026-10-25 16:09:24.803056+01
52	2026-10-26	scheduled	6	5056	28	104	\N	2026-10-25 16:09:24.805347+01
53	2026-10-26	scheduled	\N	0	105	106	38	2026-10-25 16:09:24.807984+01
54	2026-10-26	scheduled	3	5631	107	108	\N	2026-10-25 16:09:24.811581+01
55	2026-10-26	scheduled	53	5844	107	108	\N	2026-10-25 16:09:24.813333+01
56	2026-10-26	scheduled	54	9210	107	108	\N	2026-10-25 16:09:24.814629+01
57	2026-10-26	scheduled	55	9771	107	64	39	2026-10-25 16:09:24.81589+01
58	2026-10-26	scheduled	56	9204	107	116	40	2026-10-25 16:09:24.817571+01
59	2026-10-26	scheduled	57	5838	107	118	41	2026-10-25 16:09:24.82174+01
60	2026-10-26	scheduled	58	7050	107	118	41	2026-10-25 16:09:24.824445+01
61	2026-10-26	scheduled	57	3459	107	28	\N	2026-10-25 16:09:24.825829+01
62	2026-10-26	scheduled	53	5613	107	28	\N	2026-10-25 16:09:24.827533+01
63	2026-10-26	scheduled	21	5472	107	28	\N	2026-10-25 16:09:24.82919+01
64	2026-10-26	scheduled	62	5133	107	28	\N	2026-10-25 16:09:24.831009+01
65	2026-10-26	scheduled	21	5478	107	116	\N	2026-10-25 16:09:24.83279+01
66	2026-10-26	scheduled	57	5844	107	116	\N	2026-10-25 16:09:24.835047+01
67	2026-10-26	scheduled	58	7040	107	116	\N	2026-10-25 16:09:24.837983+01
68	2026-10-26	scheduled	66	8884	107	116	\N	2026-10-25 16:09:24.839817+01
69	2026-10-26	scheduled	54	3380	107	138	\N	2026-10-25 16:09:24.8417+01
70	2026-10-26	scheduled	14	6558	107	140	\N	2026-10-25 16:09:24.843792+01
71	2026-10-26	scheduled	46	4960	141	92	\N	2026-10-25 16:09:24.845886+01
72	2026-10-26	scheduled	47	2960	141	92	\N	2026-10-25 16:09:24.847785+01
73	2026-10-26	scheduled	58	5018	141	118	\N	2026-10-25 16:09:24.849925+01
74	2026-10-26	scheduled	72	29	147	148	43	2026-10-25 16:09:24.85192+01
75	2026-10-26	scheduled	73	27	149	148	44	2026-10-25 16:09:24.854477+01
76	2026-10-26	active	74	29	148	147	43	2026-10-25 16:09:24.856579+01
77	2026-10-26	scheduled	75	956	153	154	\N	2026-10-25 16:09:24.858888+01
78	2026-10-26	scheduled	76	8050	153	2	\N	2026-10-25 16:09:24.861502+01
79	2026-10-26	scheduled	75	1050	153	2	\N	2026-10-25 16:09:24.866338+01
80	2026-10-26	scheduled	78	3050	153	2	\N	2026-10-25 16:09:24.87766+01
81	2026-10-26	scheduled	79	6014	153	140	\N	2026-10-25 16:09:24.883856+01
82	2026-10-26	scheduled	75	1014	153	140	\N	2026-10-25 16:09:24.887089+01
83	2026-10-26	scheduled	78	759	153	166	\N	2026-10-25 16:09:24.890259+01
84	2026-10-26	scheduled	82	9086	167	168	\N	2026-10-25 16:09:24.893632+01
85	2026-10-26	scheduled	83	275	169	170	\N	2026-10-25 16:09:24.897019+01
86	2026-10-26	scheduled	83	275	170	172	\N	2026-10-25 16:09:24.899912+01
87	2026-10-26	scheduled	11	5819	32	174	\N	2026-10-25 16:09:24.902038+01
88	2026-10-26	scheduled	5	7565	32	174	\N	2026-10-25 16:09:24.903711+01
89	2026-10-26	scheduled	87	6997	177	178	\N	2026-10-25 16:09:24.905197+01
90	2026-10-26	scheduled	87	239	177	16	46	2026-10-25 16:09:24.906473+01
91	2026-10-26	scheduled	89	8374	181	168	\N	2026-10-25 16:09:24.907628+01
92	2026-10-26	scheduled	90	6241	183	167	\N	2026-10-25 16:09:24.909787+01
93	2026-10-26	scheduled	6	4293	32	186	47	2026-10-25 16:09:24.911273+01
94	2026-10-26	scheduled	11	8529	32	186	47	2026-10-25 16:09:24.912749+01
95	2026-10-26	scheduled	93	4611	32	186	47	2026-10-25 16:09:24.915717+01
96	2026-10-26	scheduled	14	5989	32	186	47	2026-10-25 16:09:24.917109+01
97	2026-10-26	scheduled	95	3363	32	186	47	2026-10-25 16:09:24.918914+01
98	2026-10-26	scheduled	96	6742	32	186	52	2026-10-25 16:09:24.920589+01
99	2026-10-26	scheduled	56	8745	32	186	52	2026-10-25 16:09:24.922201+01
100	2026-10-26	scheduled	6	4443	32	186	52	2026-10-25 16:09:24.925115+01
159	2026-11-03	scheduled	14	5938	32	716	\N	2026-11-02 18:58:57.582577+01
160	2026-11-03	scheduled	193	5223	214	720	\N	2026-11-02 18:58:57.586045+01
161	2026-11-03	scheduled	12	3886	214	720	\N	2026-11-02 18:58:57.588612+01
162	2026-11-03	scheduled	360	5723	214	720	\N	2026-11-02 18:58:57.590727+01
163	2026-11-03	scheduled	118	9035	214	726	\N	2026-11-02 18:58:57.593673+01
164	2026-11-03	scheduled	14	3355	214	726	\N	2026-11-02 18:58:57.597748+01
165	2026-11-03	scheduled	363	7302	214	730	\N	2026-11-02 18:58:57.601659+01
166	2026-11-03	scheduled	364	6258	214	730	\N	2026-11-02 18:58:57.605297+01
167	2026-11-03	scheduled	79	9002	214	730	\N	2026-11-02 18:58:57.607779+01
168	2026-11-03	scheduled	360	4940	214	730	\N	2026-11-02 18:58:57.609863+01
169	2026-11-03	scheduled	12	8988	91	294	\N	2026-11-02 18:58:57.612336+01
170	2026-11-03	scheduled	368	3240	91	141	\N	2026-11-02 18:58:57.613977+01
171	2026-11-03	scheduled	36	8800	91	141	\N	2026-11-02 18:58:57.61581+01
172	2026-11-03	scheduled	45	4121	91	744	\N	2026-11-02 18:58:57.617746+01
173	2026-11-03	scheduled	46	4272	91	744	\N	2026-11-02 18:58:57.6192+01
174	2026-11-03	scheduled	47	2272	91	744	\N	2026-11-02 18:58:57.621318+01
175	2026-11-03	scheduled	134	62	91	4	\N	2026-11-02 18:58:57.62294+01
176	2026-11-03	active	13	5537	28	22	\N	2026-11-02 18:58:57.624692+01
177	2026-11-03	active	56	9324	28	22	\N	2026-11-02 18:58:57.626663+01
178	2026-11-03	active	376	8063	28	22	\N	2026-11-02 18:58:57.628191+01
179	2026-11-03	active	377	9074	28	22	\N	2026-11-02 18:58:57.629972+01
180	2026-11-03	active	378	7204	28	22	\N	2026-11-02 18:58:57.631442+01
181	2026-11-03	scheduled	193	4457	730	224	\N	2026-11-02 18:58:57.633391+01
182	2026-11-03	cancelled	347	5030	224	602	\N	2026-11-02 18:58:57.635624+01
183	2026-11-03	scheduled	336	9531	765	766	\N	2026-11-02 18:58:57.63746+01
103	2026-11-03	scheduled	55	9634	601	604	\N	2026-11-02 19:04:31.734803+01
104	2026-11-03	scheduled	302	6421	601	604	\N	2026-11-02 19:04:31.736629+01
105	2026-11-03	scheduled	303	3058	601	308	\N	2026-11-02 19:04:31.739864+01
106	2026-11-03	scheduled	55	9656	601	308	\N	2026-11-02 19:04:31.742758+01
107	2026-11-03	scheduled	305	6565	601	614	\N	2026-11-02 19:04:31.744712+01
108	2026-11-03	scheduled	299	5695	601	616	\N	2026-11-02 19:04:31.746855+01
109	2026-11-03	scheduled	55	9444	601	618	\N	2026-11-02 19:04:31.749669+01
110	2026-11-03	scheduled	308	5719	601	620	\N	2026-11-02 19:04:31.752082+01
111	2026-11-03	scheduled	305	6269	601	614	\N	2026-11-02 19:04:31.754021+01
112	2026-11-03	cancelled	12	4914	601	224	\N	2026-11-02 19:04:31.757111+01
113	2026-11-03	scheduled	14	8898	92	626	\N	2026-11-02 19:04:31.761629+01
114	2026-11-03	scheduled	12	8962	92	400	\N	2026-11-02 19:04:31.764429+01
115	2026-11-03	scheduled	192	9819	92	400	\N	2026-11-02 19:04:31.771943+01
116	2026-11-03	scheduled	314	7878	92	632	\N	2026-11-02 19:04:31.774891+01
117	2026-11-03	scheduled	57	6053	633	634	\N	2026-11-02 19:04:31.778383+01
118	2026-11-03	scheduled	26	7913	633	634	\N	2026-11-02 19:04:31.782402+01
119	2026-11-03	scheduled	317	232	107	22	\N	2026-11-02 19:04:31.784609+01
121	2026-11-03	scheduled	45	4081	141	91	\N	2026-11-02 19:04:31.788156+01
122	2026-11-03	scheduled	47	4139	141	91	\N	2026-11-02 19:04:31.78956+01
123	2026-11-03	scheduled	46	3139	141	91	\N	2026-11-02 19:04:31.791601+01
124	2026-11-03	scheduled	178	9745	141	648	\N	2026-11-02 19:04:31.793191+01
125	2026-11-03	scheduled	323	1512	310	650	\N	2026-11-02 19:04:31.794872+01
126	2026-11-03	scheduled	11	8371	26	652	\N	2026-11-02 19:04:31.796261+01
127	2026-11-03	scheduled	325	5914	26	652	\N	2026-11-02 19:04:31.797865+01
128	2026-11-03	scheduled	326	6386	26	206	\N	2026-11-02 19:04:31.799532+01
129	2026-11-03	scheduled	303	3293	26	658	\N	2026-11-02 19:04:31.800825+01
130	2026-11-03	scheduled	328	2723	26	658	\N	2026-11-02 19:04:31.802367+01
131	2026-11-03	scheduled	29	4012	26	658	\N	2026-11-02 19:04:31.803856+01
132	2026-11-03	active	330	820	26	118	\N	2026-11-02 19:04:31.806389+01
133	2026-11-03	scheduled	331	3304	665	666	\N	2026-11-02 19:04:31.807875+01
134	2026-11-03	scheduled	9	6890	658	668	\N	2026-11-02 19:04:31.809621+01
135	2026-11-03	scheduled	302	6506	658	670	\N	2026-11-02 19:04:31.810768+01
136	2026-11-03	scheduled	302	6504	658	15	\N	2026-11-02 19:04:31.812034+01
137	2026-11-03	scheduled	19	5645	652	674	\N	2026-11-02 19:04:31.813592+01
138	2026-11-03	scheduled	336	7565	652	674	\N	2026-11-02 19:04:31.814661+01
139	2026-11-03	scheduled	325	5908	652	678	\N	2026-11-02 19:04:31.81602+01
140	2026-11-03	scheduled	338	911	652	680	\N	2026-11-02 19:04:31.817691+01
141	2026-11-03	scheduled	336	7596	652	680	\N	2026-11-02 19:04:31.818992+01
142	2026-11-03	scheduled	11	8021	652	684	\N	2026-11-02 19:04:31.820862+01
143	2026-11-03	scheduled	341	161	685	42	\N	2026-11-02 19:04:31.822233+01
144	2026-11-03	scheduled	342	112	687	688	\N	2026-11-02 19:04:31.824022+01
146	2026-11-03	scheduled	344	314	691	692	\N	2026-11-02 19:04:31.826661+01
147	2026-11-03	scheduled	90	5250	691	694	\N	2026-11-02 19:04:31.828231+01
148	2026-11-03	scheduled	346	565	19	696	\N	2026-11-02 19:04:31.829225+01
149	2026-11-03	scheduled	347	5174	19	602	\N	2026-11-02 19:04:31.830711+01
150	2026-11-03	scheduled	11	5573	699	700	\N	2026-11-02 19:04:31.832396+01
151	2026-11-03	scheduled	62	6455	699	700	\N	2026-11-02 19:04:31.833955+01
152	2026-11-03	scheduled	2	4412	699	700	\N	2026-11-02 19:04:31.835661+01
153	2026-11-03	scheduled	11	8657	699	706	\N	2026-11-02 19:04:31.837805+01
154	2026-11-03	scheduled	4	7198	699	708	\N	2026-11-02 19:04:31.839863+01
155	2026-11-03	scheduled	6	6963	699	22	\N	2026-11-02 19:04:31.841761+01
156	2026-11-03	scheduled	343	261	318	712	\N	2026-11-02 19:04:31.843586+01
157	2026-11-03	scheduled	343	251	318	712	\N	2026-11-02 19:04:31.845401+01
158	2026-11-03	scheduled	6	4430	32	716	\N	2026-11-02 19:04:31.84714+01
102	2026-11-03	scheduled	54	4808	601	604	\N	2026-11-02 19:04:31.73256+01
184	2026-11-03	scheduled	305	4068	765	768	\N	2026-11-02 18:58:57.63951+01
185	2026-11-03	scheduled	336	2899	765	770	\N	2026-11-02 18:58:57.641368+01
186	2026-11-03	scheduled	54	4157	765	772	\N	2026-11-02 18:58:57.643904+01
187	2026-11-03	scheduled	3	7432	765	772	\N	2026-11-02 18:58:57.646009+01
188	2026-11-03	scheduled	58	7992	765	772	\N	2026-11-02 18:58:57.648331+01
189	2026-11-03	scheduled	23	9286	765	772	\N	2026-11-02 18:58:57.649829+01
190	2026-11-03	scheduled	388	6581	765	772	\N	2026-11-02 18:58:57.653494+01
191	2026-11-03	scheduled	389	3640	670	782	\N	2026-11-02 18:58:57.655643+01
192	2026-11-03	scheduled	390	9569	670	782	\N	2026-11-02 18:58:57.657699+01
193	2026-11-03	scheduled	377	9874	670	782	\N	2026-11-02 18:58:57.659709+01
194	2026-11-03	scheduled	378	5312	670	782	\N	2026-11-02 18:58:57.661101+01
195	2026-11-03	scheduled	32	2465	670	790	\N	2026-11-02 18:58:57.662777+01
196	2026-11-03	scheduled	314	8423	670	790	\N	2026-11-02 18:58:57.664455+01
197	2026-11-03	scheduled	338	8060	670	794	\N	2026-11-02 18:58:57.670161+01
198	2026-11-03	scheduled	377	9870	670	794	\N	2026-11-02 18:58:57.674608+01
199	2026-11-03	scheduled	9	7039	670	798	\N	2026-11-02 18:58:57.676538+01
200	2026-11-03	scheduled	336	6425	670	798	\N	2026-11-02 18:58:57.678563+01
201	2026-11-03	scheduled	79	9291	201	802	\N	2026-11-02 19:04:31.62967+01
202	2026-11-03	scheduled	102	7939	201	802	\N	2026-11-02 19:04:31.64667+01
203	2026-11-03	scheduled	79	194	214	181	\N	2026-11-02 19:04:31.649229+01
204	2026-11-03	scheduled	12	3857	214	181	\N	2026-11-02 19:04:31.651036+01
205	2026-11-03	scheduled	14	3286	214	181	\N	2026-11-02 19:04:31.652878+01
206	2026-11-03	scheduled	360	5704	214	181	\N	2026-11-02 19:04:31.65459+01
207	2026-11-03	scheduled	118	9093	214	814	\N	2026-11-02 19:04:31.656616+01
208	2026-11-03	scheduled	406	5078	214	814	\N	2026-11-02 19:04:31.659069+01
209	2026-11-03	scheduled	14	3479	214	814	\N	2026-11-02 19:04:31.6614+01
210	2026-11-03	scheduled	408	6339	819	820	\N	2026-11-02 19:04:31.663581+01
211	2026-11-03	scheduled	3	5274	28	772	\N	2026-11-02 19:04:31.665311+01
212	2026-11-03	scheduled	410	8340	28	772	\N	2026-11-02 19:04:31.666983+01
213	2026-11-03	scheduled	6	8644	28	118	\N	2026-11-02 19:04:31.668624+01
214	2026-11-03	active	6	8356	28	400	\N	2026-11-02 19:04:31.670455+01
215	2026-11-03	active	413	5801	28	766	\N	2026-11-02 19:04:31.672383+01
216	2026-11-03	active	4	3230	28	766	\N	2026-11-02 19:04:31.67435+01
217	2026-11-03	active	378	9789	28	766	\N	2026-11-02 19:04:31.676032+01
218	2026-11-03	active	4	3314	28	836	\N	2026-11-02 19:04:31.677937+01
219	2026-11-03	active	13	5682	28	92	\N	2026-11-02 19:04:31.680222+01
220	2026-11-03	active	192	6726	28	92	\N	2026-11-02 19:04:31.682586+01
221	2026-11-03	active	302	8174	28	92	\N	2026-11-02 19:04:31.684096+01
222	2026-11-03	active	9	6367	28	652	\N	2026-11-02 19:04:31.68595+01
223	2026-11-03	active	11	8381	28	652	\N	2026-11-02 19:04:31.687921+01
224	2026-11-03	active	325	5932	28	652	\N	2026-11-02 19:04:31.69009+01
225	2026-11-03	active	336	7611	28	652	\N	2026-11-02 19:04:31.692412+01
226	2026-11-03	active	13	5602	28	16	\N	2026-11-02 19:04:31.694424+01
227	2026-11-03	active	4	3382	28	16	\N	2026-11-02 19:04:31.696616+01
228	2026-11-03	active	178	6278	28	16	\N	2026-11-02 19:04:31.698649+01
229	2026-11-03	active	302	8302	28	16	\N	2026-11-02 19:04:31.700982+01
230	2026-11-03	active	336	5897	28	16	\N	2026-11-02 19:04:31.703201+01
231	2026-11-03	active	2	3814	28	633	\N	2026-11-02 19:04:31.705467+01
232	2026-11-03	active	26	7348	28	633	\N	2026-11-02 19:04:31.707377+01
233	2026-11-03	active	66	8488	28	633	\N	2026-11-02 19:04:31.70929+01
234	2026-11-03	active	389	3338	28	633	\N	2026-11-02 19:04:31.711153+01
235	2026-11-03	active	11	4017	28	633	\N	2026-11-02 19:04:31.713004+01
236	2026-11-03	cancelled	303	3291	28	601	\N	2026-11-02 19:04:31.715043+01
237	2026-11-03	cancelled	55	9919	28	601	\N	2026-11-02 19:04:31.717364+01
238	2026-11-03	active	4	3302	28	684	\N	2026-11-02 19:04:31.719223+01
239	2026-11-03	scheduled	437	6053	91	878	\N	2026-11-02 19:04:31.72144+01
240	2026-11-03	scheduled	150	798	318	314	\N	2026-11-02 19:04:31.725557+01
241	2026-11-03	scheduled	440	9104	883	884	\N	2026-11-02 19:04:31.72802+01
101	2026-11-03	scheduled	299	7015	601	602	\N	2026-11-02 19:04:31.729979+01
120	2026-11-03	scheduled	36	8807	141	91	\N	2026-11-02 19:04:31.786235+01
145	2026-11-03	scheduled	343	286	689	314	\N	2026-11-02 19:04:31.825367+01
399	2026-11-03	scheduled	599	431	1201	665	\N	2026-11-02 19:33:20.679934+01
400	2026-11-03	scheduled	14	8296	201	247	\N	2026-11-02 19:33:20.731744+01
401	2026-11-03	scheduled	102	3973	201	92	\N	2026-11-02 19:33:20.740889+01
402	2026-11-03	scheduled	193	9446	201	224	\N	2026-11-02 19:33:20.748184+01
403	2026-11-03	scheduled	102	6943	201	1210	\N	2026-11-02 19:33:20.756245+01
404	2026-11-03	scheduled	102	6713	201	1212	\N	2026-11-02 19:33:20.764259+01
405	2026-11-03	scheduled	102	6693	201	1214	\N	2026-11-02 19:33:20.77086+01
406	2026-11-03	scheduled	102	3901	201	1216	\N	2026-11-02 19:33:20.778034+01
407	2026-11-03	scheduled	12	9188	201	1218	\N	2026-11-02 19:33:20.782841+01
408	2026-11-03	scheduled	608	5160	201	167	\N	2026-11-02 19:33:20.789463+01
409	2026-11-03	scheduled	101	7148	201	1222	\N	2026-11-02 19:33:20.796056+01
410	2026-11-03	scheduled	363	2719	201	177	\N	2026-11-02 19:33:20.807607+01
411	2026-11-03	scheduled	363	2715	201	1226	\N	2026-11-02 19:33:20.814133+01
412	2026-11-03	scheduled	14	2685	201	1228	\N	2026-11-02 19:33:20.819406+01
413	2026-11-03	scheduled	12	9861	201	357	\N	2026-11-02 19:33:20.824145+01
414	2026-11-03	scheduled	406	1955	201	1232	\N	2026-11-02 19:33:20.829187+01
415	2026-11-03	scheduled	363	1801	201	1228	\N	2026-11-02 19:33:20.834987+01
416	2026-11-03	scheduled	79	3788	201	177	\N	2026-11-02 19:33:20.840366+01
417	2026-11-03	scheduled	617	9657	201	1212	\N	2026-11-02 19:33:20.84702+01
418	2026-11-03	scheduled	363	1855	201	626	\N	2026-11-02 19:33:20.85262+01
419	2026-11-03	scheduled	193	9416	201	214	\N	2026-11-02 19:33:20.858701+01
420	2026-11-03	scheduled	102	6717	201	1244	\N	2026-11-02 19:33:20.865785+01
421	2026-11-03	scheduled	14	8520	201	249	\N	2026-11-02 19:33:20.870387+01
422	2026-11-03	scheduled	14	4319	201	224	\N	2026-11-02 19:33:20.875038+01
423	2026-11-03	scheduled	14	4195	201	1222	\N	2026-11-02 19:33:20.880667+01
424	2026-11-03	scheduled	14	2741	201	400	\N	2026-11-02 19:33:20.887718+01
425	2026-11-03	scheduled	14	2717	201	1254	\N	2026-11-02 19:33:20.894398+01
426	2026-11-03	scheduled	14	2713	201	1256	\N	2026-11-02 19:33:20.898946+01
427	2026-11-03	scheduled	14	2539	201	1258	\N	2026-11-02 19:33:20.90355+01
428	2026-11-03	scheduled	14	401	201	92	\N	2026-11-02 19:33:20.908193+01
429	2026-11-03	scheduled	102	6627	201	1262	\N	2026-11-02 19:33:20.912684+01
430	2026-11-03	scheduled	12	6242	201	1264	\N	2026-11-02 19:33:20.917618+01
431	2026-11-03	scheduled	631	7369	201	1266	\N	2026-11-02 19:33:20.921593+01
432	2026-11-03	scheduled	102	6741	201	1228	\N	2026-11-02 19:33:20.926046+01
433	2026-11-03	scheduled	193	8419	201	1270	\N	2026-11-02 19:33:20.929044+01
434	2026-11-03	scheduled	193	8433	201	720	\N	2026-11-02 19:33:20.932073+01
435	2026-11-03	scheduled	12	9805	201	239	\N	2026-11-02 19:33:20.934716+01
436	2026-11-03	scheduled	12	6115	201	168	\N	2026-11-02 19:33:20.939827+01
437	2026-11-03	scheduled	14	2613	201	1278	\N	2026-11-02 19:33:20.946094+01
438	2026-11-03	scheduled	14	2593	201	1280	\N	2026-11-02 19:33:20.951065+01
439	2026-11-03	cancelled	363	1112	201	1282	\N	2026-11-02 19:33:20.957454+01
440	2026-11-03	scheduled	102	6931	201	168	\N	2026-11-02 19:33:20.961402+01
441	2026-11-03	scheduled	363	1871	201	1282	\N	2026-11-02 19:33:20.965071+01
442	2026-11-03	scheduled	642	901	212	116	\N	2026-11-02 19:33:20.971132+01
443	2026-11-03	scheduled	53	501	212	116	\N	2026-11-02 19:33:20.976363+01
690	2026-11-03	scheduled	377	9066	28	26	\N	2026-11-02 19:49:02.47373+01
445	2026-11-03	scheduled	104	861	212	1294	\N	2026-11-02 19:33:21.004172+01
446	2026-11-03	scheduled	646	220	1295	1296	\N	2026-11-02 19:33:21.008064+01
447	2026-11-03	scheduled	647	332	1297	1298	\N	2026-11-02 19:33:21.012074+01
448	2026-11-03	scheduled	341	6369	1299	308	\N	2026-11-02 19:33:21.014685+01
449	2026-11-03	scheduled	649	951	1299	1302	\N	2026-11-02 19:33:21.018055+01
450	2026-11-03	scheduled	649	694	1303	1304	\N	2026-11-02 19:33:21.020721+01
451	2026-11-03	scheduled	649	607	1303	308	\N	2026-11-02 19:33:21.024061+01
452	2026-11-03	scheduled	323	1478	1303	1308	\N	2026-11-02 19:33:21.027132+01
453	2026-11-03	scheduled	157	435	1303	1310	\N	2026-11-02 19:33:21.030631+01
691	2026-11-03	scheduled	336	5887	28	26	\N	2026-11-02 19:49:02.487634+01
455	2026-11-03	scheduled	655	201	1313	1314	\N	2026-11-02 19:33:21.039289+01
692	2026-11-03	scheduled	13	5654	28	1798	\N	2026-11-02 19:49:02.492608+01
693	2026-11-03	scheduled	4	3216	28	1798	\N	2026-11-02 19:49:02.497192+01
458	2026-11-03	scheduled	12	6661	167	214	\N	2026-11-02 19:33:21.051773+01
459	2026-11-03	scheduled	90	6242	167	183	\N	2026-11-02 19:33:21.057547+01
460	2026-11-03	scheduled	660	8059	167	1324	\N	2026-11-02 19:33:21.061476+01
461	2026-11-03	scheduled	12	6643	167	368	\N	2026-11-02 19:33:21.064817+01
462	2026-11-03	scheduled	12	5716	167	1328	\N	2026-11-02 19:33:21.068027+01
463	2026-11-03	scheduled	608	5937	167	1278	\N	2026-11-02 19:33:21.075358+01
464	2026-11-03	scheduled	608	5161	167	201	\N	2026-11-02 19:33:21.077556+01
465	2026-11-03	scheduled	79	8879	167	1218	\N	2026-11-02 19:33:21.080012+01
466	2026-11-03	scheduled	79	8847	167	368	\N	2026-11-02 19:33:21.083126+01
467	2026-11-03	scheduled	79	6904	167	140	\N	2026-11-02 19:33:21.085782+01
468	2026-11-03	scheduled	79	3156	167	214	\N	2026-11-02 19:33:21.08809+01
469	2026-11-03	scheduled	12	2842	167	181	\N	2026-11-02 19:33:21.090288+01
470	2026-11-03	scheduled	12	2104	167	1344	\N	2026-11-02 19:33:21.093254+01
471	2026-11-03	scheduled	360	8211	167	1346	\N	2026-11-02 19:33:21.095999+01
472	2026-11-03	scheduled	79	6606	167	247	\N	2026-11-02 19:33:21.098794+01
473	2026-11-03	scheduled	673	5639	167	1280	\N	2026-11-02 19:33:21.101676+01
474	2026-11-03	scheduled	674	6210	167	1352	\N	2026-11-02 19:33:21.105886+01
475	2026-11-03	cancelled	360	8483	167	1354	\N	2026-11-02 19:33:21.10886+01
476	2026-11-03	scheduled	660	8061	167	1228	\N	2026-11-02 19:33:21.11181+01
477	2026-11-03	scheduled	360	8589	167	1358	\N	2026-11-02 19:33:21.115723+01
478	2026-11-03	scheduled	79	8877	167	239	\N	2026-11-02 19:33:21.123633+01
479	2026-11-03	scheduled	79	8855	167	168	\N	2026-11-02 19:33:21.12695+01
480	2026-11-03	scheduled	79	8829	167	1344	\N	2026-11-02 19:33:21.129507+01
481	2026-11-03	scheduled	79	6180	167	1256	\N	2026-11-02 19:33:21.132483+01
482	2026-11-03	scheduled	79	3901	167	1354	\N	2026-11-02 19:33:21.134397+01
483	2026-11-03	scheduled	79	3288	167	1370	\N	2026-11-02 19:33:21.136585+01
484	2026-11-03	scheduled	79	3108	167	224	\N	2026-11-02 19:33:21.13904+01
485	2026-11-03	scheduled	685	2002	167	730	\N	2026-11-02 19:33:21.141114+01
486	2026-11-03	scheduled	660	8025	167	1376	\N	2026-11-02 19:33:21.143268+01
487	2026-11-03	scheduled	608	5357	167	1378	\N	2026-11-02 19:33:21.1449+01
488	2026-11-03	scheduled	660	8051	167	1380	\N	2026-11-02 19:33:21.149863+01
489	2026-11-03	scheduled	660	8039	167	1382	\N	2026-11-02 19:33:21.153034+01
490	2026-11-03	scheduled	12	6303	167	224	\N	2026-11-02 19:33:21.15559+01
491	2026-11-03	scheduled	12	6073	167	107	\N	2026-11-02 19:33:21.157868+01
492	2026-11-03	scheduled	12	2460	167	1388	\N	2026-11-02 19:33:21.160597+01
493	2026-11-03	scheduled	608	5985	167	168	\N	2026-11-02 19:33:21.162426+01
494	2026-11-03	scheduled	608	5907	167	1392	\N	2026-11-02 19:33:21.164671+01
495	2026-11-03	scheduled	608	5525	167	1394	\N	2026-11-02 19:33:21.166769+01
496	2026-11-03	scheduled	79	3897	167	1396	\N	2026-11-02 19:33:21.168938+01
694	2026-11-03	scheduled	302	8282	28	1798	\N	2026-11-02 19:49:02.502512+01
498	2026-11-03	scheduled	109	1957	153	1400	\N	2026-11-02 19:33:21.174218+01
695	2026-11-03	scheduled	192	6724	28	64	\N	2026-11-02 19:49:02.505828+01
696	2026-11-03	scheduled	55	9740	28	64	\N	2026-11-02 19:49:02.509268+01
697	2026-11-03	scheduled	302	8142	28	64	\N	2026-11-02 19:49:02.512759+01
698	2026-11-03	scheduled	6	8614	28	26	\N	2026-11-02 19:49:02.516129+01
699	2026-11-03	scheduled	96	7934	28	116	\N	2026-11-02 19:49:02.519633+01
700	2026-11-03	scheduled	336	6247	28	116	\N	2026-11-02 19:49:02.522866+01
701	2026-11-03	scheduled	6	5904	28	116	\N	2026-11-02 19:49:02.526241+01
702	2026-11-03	scheduled	6	8312	28	1244	\N	2026-11-02 19:49:02.52908+01
703	2026-11-03	scheduled	47	2612	91	294	\N	2026-11-02 19:49:02.53231+01
510	2026-11-03	scheduled	344	313	692	691	\N	2026-11-02 19:50:39.033177+01
515	2026-11-03	active	21	6	1431	1432	\N	2026-11-02 19:39:59.170149+01
512	2026-11-03	scheduled	709	8431	1222	766	\N	2026-11-02 19:50:39.036682+01
513	2026-11-03	scheduled	58	3434	1429	1430	\N	2026-11-02 19:50:39.03826+01
514	2026-11-03	scheduled	21	8	1431	1432	\N	2026-11-02 19:50:39.040106+01
516	2026-11-03	scheduled	716	21	1435	1436	\N	2026-11-02 19:50:39.043594+01
509	2026-11-03	scheduled	709	8403	19	766	\N	2026-11-02 19:50:39.030739+01
704	2026-11-03	scheduled	12	432	19	1822	\N	2026-11-02 19:49:02.535693+01
705	2026-11-03	scheduled	93	5983	19	720	\N	2026-11-02 19:49:02.539099+01
524	2026-11-03	scheduled	724	532	42	118	\N	2026-11-02 19:39:59.24253+01
525	2026-11-03	scheduled	58	728	26	118	\N	2026-11-02 19:39:59.247974+01
706	2026-11-03	scheduled	360	7448	19	720	\N	2026-11-02 19:49:02.542594+01
707	2026-11-03	scheduled	406	5597	19	720	\N	2026-11-02 19:49:02.54534+01
708	2026-11-03	scheduled	4	7026	699	22	\N	2026-11-02 19:49:02.548997+01
709	2026-11-03	scheduled	58	4818	699	22	\N	2026-11-02 19:49:02.551294+01
710	2026-11-03	scheduled	2	4764	699	22	\N	2026-11-02 19:49:02.556962+01
711	2026-11-03	scheduled	5	5207	699	22	\N	2026-11-02 19:49:02.562555+01
712	2026-11-03	scheduled	4	7421	699	1838	\N	2026-11-02 19:49:02.566275+01
713	2026-11-03	scheduled	918	2954	699	4	\N	2026-11-02 19:49:02.56943+01
714	2026-11-03	scheduled	26	5095	699	4	\N	2026-11-02 19:49:02.573973+01
715	2026-11-03	scheduled	4	7301	699	4	\N	2026-11-02 19:49:02.577976+01
716	2026-11-03	scheduled	5	5574	699	4	\N	2026-11-02 19:49:02.581577+01
720	2026-11-03	scheduled	26	7328	91	116	\N	2026-11-02 19:49:02.60168+01
721	2026-11-03	scheduled	927	5919	91	116	\N	2026-11-02 19:49:02.605885+01
722	2026-11-03	scheduled	53	5506	91	116	\N	2026-11-02 19:49:02.610306+01
723	2026-11-03	scheduled	66	8419	91	116	\N	2026-11-02 19:49:02.613931+01
724	2026-11-03	scheduled	437	6193	91	1864	\N	2026-11-02 19:49:02.61546+01
725	2026-11-03	scheduled	45	4463	91	1866	\N	2026-11-02 19:49:02.617647+01
726	2026-11-03	scheduled	46	4886	91	1866	\N	2026-11-02 19:49:02.621471+01
727	2026-11-03	scheduled	47	2886	91	1866	\N	2026-11-02 19:49:02.623679+01
730	2026-11-03	scheduled	2	4853	699	4	\N	2026-11-02 19:49:02.628092+01
735	2026-11-03	scheduled	4	7096	4	1888	\N	2026-11-02 19:49:02.636209+01
520	2026-11-03	scheduled	150	788	310	1440	\N	2026-11-02 19:50:39.052271+01
742	2026-11-03	scheduled	951	2036	601	614	\N	2026-11-02 19:49:02.648662+01
555	2026-11-03	scheduled	755	933	92	141	\N	2026-11-02 19:39:59.410751+01
743	2026-11-03	scheduled	952	5874	601	614	\N	2026-11-02 19:49:02.651233+01
744	2026-11-03	scheduled	10	3973	601	614	\N	2026-11-02 19:49:02.655303+01
745	2026-11-03	scheduled	954	3322	601	104	\N	2026-11-02 19:49:02.657791+01
746	2026-11-03	scheduled	305	6569	601	614	\N	2026-11-02 19:49:02.659642+01
747	2026-11-03	scheduled	308	5730	601	300	\N	2026-11-02 19:49:02.661445+01
748	2026-11-03	scheduled	305	6577	601	614	\N	2026-11-02 19:49:02.662763+01
749	2026-11-03	scheduled	308	5725	601	1920	\N	2026-11-02 19:49:02.664457+01
750	2026-11-03	scheduled	302	8171	92	28	\N	2026-11-02 19:49:02.666022+01
752	2026-11-03	scheduled	6	6575	1473	22	\N	2026-11-02 19:49:02.668544+01
753	2026-11-03	scheduled	57	7122	1473	22	\N	2026-11-02 19:49:02.670075+01
754	2026-11-03	scheduled	302	7180	1473	22	\N	2026-11-02 19:49:02.671246+01
755	2026-11-03	scheduled	66	8906	107	26	\N	2026-11-02 19:49:02.672392+01
756	2026-11-03	scheduled	58	7054	107	325	\N	2026-11-02 19:49:02.674319+01
757	2026-11-03	scheduled	23	6118	107	1222	\N	2026-11-02 19:49:02.677678+01
758	2026-11-03	scheduled	62	5851	107	700	\N	2026-11-02 19:49:02.679356+01
759	2026-11-03	scheduled	336	9799	107	700	\N	2026-11-02 19:49:02.68076+01
760	2026-11-03	scheduled	954	3201	107	242	\N	2026-11-02 19:49:02.68249+01
575	2026-11-03	scheduled	722	408	1435	687	\N	2026-11-02 19:39:59.510956+01
761	2026-11-03	scheduled	377	9525	107	242	\N	2026-11-02 19:49:02.683615+01
762	2026-11-03	scheduled	378	7007	107	242	\N	2026-11-02 19:49:02.685218+01
763	2026-11-03	scheduled	62	5113	107	242	\N	2026-11-02 19:49:02.686645+01
764	2026-11-03	scheduled	336	9767	107	242	\N	2026-11-02 19:49:02.688521+01
765	2026-11-03	scheduled	57	5826	107	118	\N	2026-11-02 19:49:02.689901+01
766	2026-11-03	scheduled	58	7028	107	118	\N	2026-11-02 19:49:02.691493+01
767	2026-11-03	scheduled	93	6821	107	1956	\N	2026-11-02 19:49:02.692593+01
768	2026-11-03	scheduled	57	5840	107	116	\N	2026-11-02 19:49:02.694021+01
769	2026-11-03	scheduled	58	7026	107	116	\N	2026-11-02 19:49:02.696557+01
770	2026-11-03	scheduled	66	8956	107	116	\N	2026-11-02 19:49:02.698495+01
771	2026-11-03	scheduled	437	6001	141	294	\N	2026-11-02 19:49:02.701361+01
772	2026-11-03	scheduled	437	6127	141	91	\N	2026-11-02 19:49:02.702424+01
773	2026-11-03	scheduled	368	3207	141	91	\N	2026-11-02 19:49:02.703428+01
559	2026-11-03	scheduled	759	162	1521	1522	\N	2026-11-02 19:49:02.704757+01
775	2026-11-03	scheduled	96	6579	652	1974	\N	2026-11-02 19:49:02.705704+01
776	2026-11-03	scheduled	11	8705	652	1974	\N	2026-11-02 19:49:02.706796+01
777	2026-11-03	scheduled	325	5960	652	1974	\N	2026-11-02 19:49:02.707921+01
778	2026-11-03	scheduled	79	7878	652	1974	\N	2026-11-02 19:49:02.709045+01
779	2026-11-03	scheduled	336	7618	652	1974	\N	2026-11-02 19:49:02.71049+01
780	2026-11-03	scheduled	990	6338	652	242	\N	2026-11-02 19:49:02.711694+01
596	2026-11-03	active	796	2841	104	242	\N	2026-11-02 19:39:59.586502+01
521	2026-11-03	scheduled	150	940	310	1440	\N	2026-11-02 19:50:39.055269+01
522	2026-11-03	scheduled	722	136	1447	1435	\N	2026-11-02 19:50:39.057135+01
523	2026-11-03	scheduled	100	164	42	1450	\N	2026-11-02 19:50:39.05866+01
500	2026-11-03	scheduled	700	7627	1403	766	\N	2026-11-02 19:50:39.009755+01
535	2026-11-03	scheduled	13	1752	1473	22	\N	2026-11-02 19:50:39.08003+01
519	2026-11-03	scheduled	323	1557	1401	1440	\N	2026-11-02 19:50:39.050675+01
887	2026-11-03	scheduled	1102	318	2207	2208	\N	2026-11-02 19:56:03.030853+01
888	2026-11-03	scheduled	1102	354	2207	2210	\N	2026-11-02 19:56:03.033849+01
889	2026-11-03	scheduled	1102	322	2207	2212	\N	2026-11-02 19:56:03.03685+01
781	2026-11-03	scheduled	722	5534	1985	696	\N	2026-11-02 19:50:38.835563+01
782	2026-11-03	scheduled	326	5672	26	1988	\N	2026-11-02 19:50:38.874119+01
783	2026-11-03	scheduled	58	5979	26	1988	\N	2026-11-02 19:50:38.88029+01
784	2026-11-03	scheduled	93	7664	26	1988	\N	2026-11-02 19:50:38.884039+01
785	2026-11-03	scheduled	5	4474	26	1988	\N	2026-11-02 19:50:38.887619+01
786	2026-11-03	scheduled	36	9611	26	1988	\N	2026-11-02 19:50:38.891498+01
689	2026-11-03	scheduled	90	5358	1791	694	\N	2026-11-02 19:50:38.894436+01
624	2026-11-03	scheduled	83	7087	1432	172	\N	2026-11-02 19:50:38.984346+01
499	2026-11-03	scheduled	323	1601	1401	322	\N	2026-11-02 19:50:39.006917+01
518	2026-11-03	scheduled	341	7797	310	1440	\N	2026-11-02 19:50:39.048309+01
971	2026-11-03	scheduled	1186	5577	42	4	\N	2026-11-02 19:56:02.912071+01
972	2026-11-03	scheduled	389	2907	42	4	\N	2026-11-02 19:56:02.976136+01
973	2026-11-03	scheduled	56	7963	42	4	\N	2026-11-02 19:56:02.982218+01
974	2026-11-03	scheduled	305	6333	42	4	\N	2026-11-02 19:56:02.986886+01
975	2026-11-03	scheduled	57	4977	42	4	\N	2026-11-02 19:56:02.991605+01
976	2026-11-03	scheduled	11	5134	42	4	\N	2026-11-02 19:56:02.996283+01
977	2026-11-03	scheduled	32	4119	42	4	\N	2026-11-02 19:56:02.999555+01
978	2026-11-03	scheduled	1193	7143	42	4	\N	2026-11-02 19:56:03.003333+01
979	2026-11-03	scheduled	99	9629	42	4	\N	2026-11-02 19:56:03.006437+01
980	2026-11-03	scheduled	1195	6231	42	674	\N	2026-11-02 19:56:03.010022+01
981	2026-11-03	scheduled	54	9011	42	674	\N	2026-11-02 19:56:03.015273+01
883	2026-11-03	scheduled	58	6749	330	92	\N	2026-11-02 19:56:03.02+01
983	2026-11-03	scheduled	13	5677	92	28	\N	2026-11-02 19:56:03.022479+01
984	2026-11-03	scheduled	192	6781	92	28	\N	2026-11-02 19:56:03.025024+01
985	2026-11-03	scheduled	53	6703	92	118	\N	2026-11-02 19:56:03.028014+01
989	2026-11-03	scheduled	58	5750	141	91	\N	2026-11-02 19:56:03.039403+01
990	2026-11-03	scheduled	45	2160	141	325	\N	2026-11-02 19:56:03.042888+01
991	2026-11-03	scheduled	46	4940	141	325	\N	2026-11-02 19:56:03.046226+01
992	2026-11-03	scheduled	47	2940	141	325	\N	2026-11-02 19:56:03.049168+01
993	2026-11-03	scheduled	93	7320	141	1866	\N	2026-11-02 19:56:03.053573+01
994	2026-11-03	scheduled	36	9584	141	1866	\N	2026-11-02 19:56:03.05877+01
896	2026-11-03	scheduled	90	5220	2225	694	\N	2026-11-02 19:56:03.061611+01
996	2026-11-03	scheduled	58	5090	652	118	\N	2026-11-02 19:56:03.063814+01
997	2026-11-03	scheduled	45	4996	652	1216	\N	2026-11-02 19:56:03.067981+01
998	2026-11-03	scheduled	326	4504	652	700	\N	2026-11-02 19:56:03.070827+01
999	2026-11-03	scheduled	325	5917	652	700	\N	2026-11-02 19:56:03.074044+01
1000	2026-11-03	scheduled	336	7606	652	700	\N	2026-11-02 19:56:03.077629+01
1001	2026-11-03	scheduled	11	8408	652	22	\N	2026-11-02 19:56:03.079512+01
1002	2026-11-03	scheduled	58	5096	652	116	\N	2026-11-02 19:56:03.081951+01
1003	2026-11-03	scheduled	1218	8081	652	602	\N	2026-11-02 19:56:03.08394+01
1004	2026-11-03	scheduled	1219	3602	652	602	\N	2026-11-02 19:56:03.087391+01
1005	2026-11-03	scheduled	1220	4453	652	602	\N	2026-11-02 19:56:03.090728+01
1006	2026-11-03	scheduled	11	8430	652	3	\N	2026-11-02 19:56:03.09385+01
1007	2026-11-03	scheduled	325	5933	652	3	\N	2026-11-02 19:56:03.096039+01
1008	2026-11-03	scheduled	19	5634	652	3	\N	2026-11-02 19:56:03.098333+01
1009	2026-11-03	scheduled	11	8011	652	836	\N	2026-11-02 19:56:03.103398+01
1010	2026-11-03	scheduled	1225	6029	652	836	\N	2026-11-02 19:56:03.105834+01
1011	2026-11-03	scheduled	11	8420	652	699	\N	2026-11-02 19:56:03.10815+01
1012	2026-11-03	scheduled	325	5939	652	699	\N	2026-11-02 19:56:03.109734+01
1013	2026-11-03	scheduled	19	5641	652	699	\N	2026-11-02 19:56:03.111726+01
1014	2026-11-03	scheduled	9	6370	652	1974	\N	2026-11-02 19:56:03.114662+01
1015	2026-11-03	scheduled	360	4051	730	1282	\N	2026-11-02 19:56:03.117215+01
1016	2026-11-03	scheduled	12	3994	730	1282	\N	2026-11-02 19:56:03.11929+01
1017	2026-11-03	scheduled	89	5625	730	1282	\N	2026-11-02 19:56:03.120915+01
1018	2026-11-03	scheduled	3	5297	772	883	\N	2026-11-02 19:56:03.1237+01
1019	2026-11-03	scheduled	26	5740	772	883	\N	2026-11-02 19:56:03.126501+01
1020	2026-11-03	scheduled	389	3087	772	883	\N	2026-11-02 19:56:03.128756+01
1021	2026-11-03	scheduled	62	6005	772	883	\N	2026-11-02 19:56:03.130888+01
1022	2026-11-03	scheduled	43	6194	772	883	\N	2026-11-02 19:56:03.132976+01
1023	2026-11-03	scheduled	1238	3828	772	883	\N	2026-11-02 19:56:03.135745+01
1024	2026-11-03	scheduled	23	9224	772	883	\N	2026-11-02 19:56:03.137989+01
1025	2026-11-03	scheduled	66	8252	772	678	\N	2026-11-02 19:56:03.140578+01
1026	2026-11-03	scheduled	3	5311	772	678	\N	2026-11-02 19:56:03.142899+01
1027	2026-11-03	scheduled	410	8310	772	678	\N	2026-11-02 19:56:03.145888+01
1028	2026-11-03	scheduled	1186	6249	772	678	\N	2026-11-02 19:56:03.148624+01
1029	2026-11-03	scheduled	62	6035	772	678	\N	2026-11-02 19:56:03.150523+01
1030	2026-11-03	scheduled	43	2356	772	678	\N	2026-11-02 19:56:03.15297+01
1031	2026-11-03	scheduled	26	5762	772	678	\N	2026-11-02 19:56:03.154816+01
1032	2026-11-03	scheduled	1247	1159	772	678	\N	2026-11-02 19:56:03.157212+01
1033	2026-11-03	scheduled	1248	6171	772	678	\N	2026-11-02 19:56:03.15925+01
1034	2026-11-03	scheduled	388	6508	772	678	\N	2026-11-02 19:56:03.161648+01
1035	2026-11-03	scheduled	952	6220	772	678	\N	2026-11-02 19:56:03.163989+01
1036	2026-11-03	scheduled	57	4567	772	2506	\N	2026-11-02 19:56:03.166354+01
1037	2026-11-03	scheduled	54	5885	772	2506	\N	2026-11-02 19:56:03.169247+01
1038	2026-11-03	scheduled	389	3108	772	601	\N	2026-11-02 19:56:03.17172+01
1039	2026-11-03	scheduled	1247	1690	772	601	\N	2026-11-02 19:56:03.173072+01
1040	2026-11-03	scheduled	1248	6125	772	601	\N	2026-11-02 19:56:03.174689+01
1041	2026-11-03	scheduled	66	8188	772	601	\N	2026-11-02 19:56:03.175772+01
1042	2026-11-03	scheduled	3	5629	772	601	\N	2026-11-02 19:56:03.177146+01
1043	2026-11-03	scheduled	23	9306	772	601	\N	2026-11-02 19:56:03.178855+01
1044	2026-11-03	scheduled	13	6143	772	601	\N	2026-11-02 19:56:03.180414+01
1045	2026-11-03	scheduled	43	4486	772	601	\N	2026-11-02 19:56:03.182045+01
1046	2026-11-03	scheduled	54	4144	772	601	\N	2026-11-02 19:56:03.184355+01
1047	2026-11-03	scheduled	1247	1457	772	696	\N	2026-11-02 19:56:03.186022+01
1048	2026-11-03	scheduled	1186	6317	772	696	\N	2026-11-02 19:56:03.187572+01
1049	2026-11-03	scheduled	389	3102	772	696	\N	2026-11-02 19:56:03.189223+01
1050	2026-11-03	scheduled	54	9277	772	696	\N	2026-11-02 19:56:03.190948+01
1051	2026-11-03	scheduled	13	6186	772	696	\N	2026-11-02 19:56:03.192979+01
1052	2026-11-03	scheduled	1248	8421	772	696	\N	2026-11-02 19:56:03.194637+01
1053	2026-11-03	scheduled	3	5288	772	118	\N	2026-11-02 19:56:03.196219+01
1054	2026-11-03	scheduled	58	7996	772	118	\N	2026-11-02 19:56:03.197798+01
1055	2026-11-03	scheduled	1247	1575	772	668	\N	2026-11-02 19:56:03.199015+01
1056	2026-11-03	scheduled	389	3061	772	668	\N	2026-11-02 19:56:03.20121+01
1057	2026-11-03	scheduled	3	7425	772	668	\N	2026-11-02 19:56:03.202389+01
1058	2026-11-03	scheduled	1248	6336	772	668	\N	2026-11-02 19:56:03.203716+01
1059	2026-11-03	scheduled	54	9293	772	668	\N	2026-11-02 19:56:03.204905+01
1060	2026-11-03	scheduled	58	4572	772	668	\N	2026-11-02 19:56:03.205937+01
1061	2026-11-03	scheduled	13	6155	772	2556	\N	2026-11-02 19:56:03.20729+01
1062	2026-11-03	scheduled	389	3598	772	2556	\N	2026-11-02 19:56:03.20841+01
1063	2026-11-03	scheduled	54	9247	772	2556	\N	2026-11-02 19:56:03.209798+01
1064	2026-11-03	scheduled	1248	6191	772	2556	\N	2026-11-02 19:56:03.210956+01
1065	2026-11-03	scheduled	93	7087	308	2564	\N	2026-11-02 19:56:03.213933+01
1066	2026-11-03	scheduled	55	9150	308	116	\N	2026-11-02 19:56:03.216038+01
1067	2026-11-03	scheduled	26	7346	308	116	\N	2026-11-02 19:56:03.217714+01
1068	2026-11-03	scheduled	66	8497	308	116	\N	2026-11-02 19:56:03.21921+01
970	2026-11-03	scheduled	1185	151	240	4	\N	2026-11-02 19:56:03.220251+01
1106	2026-11-05	scheduled	363	7302	214	730	\N	2026-11-04 18:56:08.397199+01
1107	2026-11-05	scheduled	364	6258	214	730	\N	2026-11-04 18:56:08.400672+01
1108	2026-11-05	scheduled	79	9002	214	730	\N	2026-11-04 18:56:08.405247+01
1109	2026-11-05	scheduled	360	4940	214	730	\N	2026-11-04 18:56:08.407907+01
1113	2026-11-05	scheduled	11	5573	699	700	\N	2026-11-04 18:56:08.439688+01
1114	2026-11-05	scheduled	62	6455	699	700	\N	2026-11-04 18:56:08.442039+01
1115	2026-11-05	scheduled	2	4412	699	700	\N	2026-11-04 18:56:08.444174+01
1116	2026-11-05	scheduled	5	5432	699	2666	\N	2026-11-04 18:56:08.446216+01
1117	2026-11-05	scheduled	4	7515	699	2666	\N	2026-11-04 18:56:08.448861+01
1118	2026-11-05	scheduled	378	7084	1222	19	\N	2026-11-04 18:56:08.451656+01
1119	2026-11-05	scheduled	14	6507	1222	107	\N	2026-11-04 18:56:08.453817+01
1120	2026-11-05	scheduled	118	5596	1222	168	\N	2026-11-04 18:56:08.456421+01
1121	2026-11-05	scheduled	118	5394	1222	1218	\N	2026-11-04 18:56:08.459034+01
1122	2026-11-05	scheduled	11	5360	2677	16	\N	2026-11-04 18:56:08.461231+01
1123	2026-11-05	scheduled	11	5260	2677	15	\N	2026-11-04 18:56:08.463659+01
1124	2026-11-05	scheduled	343	261	318	712	\N	2026-11-04 18:56:08.465938+01
1125	2026-11-05	scheduled	343	251	318	712	\N	2026-11-04 18:56:08.468371+01
1126	2026-11-05	scheduled	124	4028	1	2688	\N	2026-11-04 18:56:08.474241+01
1127	2026-11-05	scheduled	150	1949	314	303	\N	2026-11-04 18:56:08.476439+01
1128	2026-11-05	scheduled	150	949	314	303	\N	2026-11-04 18:56:08.477912+01
1129	2026-11-05	scheduled	150	797	314	318	\N	2026-11-04 18:56:08.479574+01
1130	2026-11-05	scheduled	1346	7596	28	42	\N	2026-11-04 18:56:08.481801+01
1131	2026-11-05	scheduled	1186	5690	28	42	\N	2026-11-04 18:56:08.483155+01
1132	2026-11-05	scheduled	6	5602	28	42	\N	2026-11-04 18:56:08.484793+01
1133	2026-11-05	scheduled	57	5392	28	42	\N	2026-11-04 18:56:08.486666+01
1134	2026-11-05	scheduled	169	5869	92	357	\N	2026-11-04 18:56:08.490769+01
1135	2026-11-05	scheduled	1353	3076	92	357	\N	2026-11-04 18:56:08.493347+01
1136	2026-11-05	scheduled	192	9875	92	2712	\N	2026-11-04 18:56:08.494825+01
1074	2026-11-05	scheduled	12	4470	730	820	\N	2026-11-04 19:07:12.008994+01
1075	2026-11-05	scheduled	360	4287	730	820	\N	2026-11-04 19:07:12.010098+01
1076	2026-11-05	scheduled	89	5861	730	820	\N	2026-11-04 19:07:12.011283+01
1077	2026-11-05	scheduled	14	9111	730	820	\N	2026-11-04 19:07:12.012423+01
1078	2026-11-05	scheduled	1293	3863	730	224	\N	2026-11-04 19:07:12.013427+01
1079	2026-11-05	scheduled	1294	4545	2591	2592	\N	2026-11-04 19:07:12.014442+01
1080	2026-11-05	scheduled	360	5312	224	1328	\N	2026-11-04 19:07:12.015654+01
1081	2026-11-05	scheduled	79	7172	224	1328	\N	2026-11-04 19:07:12.016641+01
1082	2026-11-05	scheduled	364	6413	224	1328	\N	2026-11-04 19:07:12.01809+01
1083	2026-11-05	scheduled	101	2109	224	1328	\N	2026-11-04 19:07:12.01903+01
1084	2026-11-05	scheduled	1299	2431	224	1328	\N	2026-11-04 19:07:12.020178+01
1085	2026-11-05	scheduled	363	9133	224	1328	\N	2026-11-04 19:07:12.021311+01
1086	2026-11-05	scheduled	12	4306	224	1328	\N	2026-11-04 19:07:12.022832+01
1087	2026-11-05	scheduled	360	5212	224	820	\N	2026-11-04 19:07:12.023943+01
1088	2026-11-05	scheduled	364	6307	224	820	\N	2026-11-04 19:07:12.024949+01
1089	2026-11-05	scheduled	101	2031	224	820	\N	2026-11-04 19:07:12.025953+01
1090	2026-11-05	scheduled	1299	2333	224	820	\N	2026-11-04 19:07:12.026883+01
1091	2026-11-05	scheduled	363	9033	224	820	\N	2026-11-04 19:07:12.027824+01
1092	2026-11-05	scheduled	9	7039	670	798	\N	2026-11-04 19:07:12.028692+01
1093	2026-11-05	scheduled	336	6425	670	798	\N	2026-11-04 19:07:12.029955+01
1094	2026-11-05	scheduled	328	2723	26	658	\N	2026-11-04 19:07:12.030971+01
1095	2026-11-05	scheduled	29	4012	26	658	\N	2026-11-04 19:07:12.032184+01
1096	2026-11-05	scheduled	390	8137	26	658	\N	2026-11-04 19:07:12.033144+01
1097	2026-11-05	scheduled	368	5401	26	658	\N	2026-11-04 19:07:12.034373+01
1098	2026-11-05	scheduled	55	9092	26	658	\N	2026-11-04 19:07:12.035647+01
1099	2026-11-05	scheduled	325	5461	26	658	\N	2026-11-04 19:07:12.03712+01
1100	2026-11-05	scheduled	326	6456	26	214	\N	2026-11-04 19:07:12.038109+01
1101	2026-11-05	scheduled	14	7980	26	214	\N	2026-11-04 19:07:12.03947+01
1102	2026-11-05	scheduled	343	286	689	314	\N	2026-11-04 19:07:12.040483+01
1103	2026-11-05	scheduled	118	9035	214	726	\N	2026-11-04 19:07:12.041342+01
1104	2026-11-05	scheduled	14	3355	214	726	\N	2026-11-04 19:07:12.042555+01
1105	2026-11-05	scheduled	102	1471	214	2644	\N	2026-11-04 19:07:12.043618+01
1071	2026-11-05	scheduled	336	7596	652	680	\N	2026-11-04 19:07:12.003959+01
1072	2026-11-05	scheduled	58	740	16	116	\N	2026-11-04 19:07:12.005459+01
1073	2026-11-05	scheduled	118	3743	730	820	\N	2026-11-04 19:07:12.006918+01
1137	2026-11-05	scheduled	58	5274	92	2712	\N	2026-11-04 18:56:08.497003+01
1138	2026-11-05	scheduled	308	5513	92	2712	\N	2026-11-04 18:56:08.498486+01
1139	2026-11-05	scheduled	169	5061	92	2718	\N	2026-11-04 18:56:08.500347+01
1140	2026-11-05	scheduled	305	6956	883	884	\N	2026-11-04 18:56:08.502619+01
1141	2026-11-05	scheduled	1359	7120	883	884	\N	2026-11-04 18:56:08.504614+01
1142	2026-11-05	scheduled	440	9104	883	884	\N	2026-11-04 18:56:08.50592+01
1143	2026-11-05	scheduled	299	5695	601	616	\N	2026-11-04 18:56:08.507523+01
1144	2026-11-05	cancelled	328	3893	601	614	\N	2026-11-04 18:56:08.509278+01
1145	2026-11-05	cancelled	951	2064	601	614	\N	2026-11-04 18:56:08.51125+01
1146	2026-11-05	cancelled	54	4760	601	614	\N	2026-11-04 18:56:08.512732+01
1147	2026-11-05	cancelled	302	6455	601	614	\N	2026-11-04 18:56:08.514475+01
1148	2026-11-05	scheduled	55	9444	601	618	\N	2026-11-04 18:56:08.516041+01
1149	2026-11-05	scheduled	308	5719	601	620	\N	2026-11-04 18:56:08.518613+01
1150	2026-11-05	scheduled	1299	2481	168	214	\N	2026-11-04 18:56:08.521347+01
1151	2026-11-05	scheduled	1102	357	2745	2210	\N	2026-11-04 18:56:08.524795+01
1152	2026-11-05	scheduled	178	9745	141	648	\N	2026-11-04 18:56:08.526292+01
1153	2026-11-05	scheduled	437	6167	141	1864	\N	2026-11-04 18:56:08.528028+01
1154	2026-11-05	scheduled	45	4238	141	2752	\N	2026-11-04 18:56:08.530027+01
1155	2026-11-05	scheduled	46	4463	141	2752	\N	2026-11-04 18:56:08.532284+01
1156	2026-11-05	scheduled	47	2463	141	2752	\N	2026-11-04 18:56:08.5337+01
1157	2026-11-05	scheduled	46	4952	141	2758	\N	2026-11-04 18:56:08.534866+01
1158	2026-11-05	scheduled	47	2952	141	2758	\N	2026-11-04 18:56:08.536106+01
1159	2026-11-05	scheduled	45	4227	141	2758	\N	2026-11-04 18:56:08.537603+01
1160	2026-11-05	scheduled	46	4495	141	2764	\N	2026-11-04 18:56:08.53878+01
1163	2026-11-05	scheduled	406	5078	214	814	\N	2026-11-04 19:07:11.925905+01
1164	2026-11-05	scheduled	14	3479	214	814	\N	2026-11-04 19:07:11.927627+01
1165	2026-11-05	scheduled	193	5223	214	720	\N	2026-11-04 19:07:11.929188+01
1166	2026-11-05	scheduled	12	3886	214	720	\N	2026-11-04 19:07:11.930644+01
1167	2026-11-05	scheduled	360	5723	214	720	\N	2026-11-04 19:07:11.932231+01
1168	2026-11-05	scheduled	14	7972	28	214	\N	2026-11-04 19:07:11.933675+01
1169	2026-11-05	active	6	8638	28	206	\N	2026-11-04 19:07:11.934992+01
1170	2026-11-05	active	413	5801	28	766	\N	2026-11-04 19:07:11.937049+01
1171	2026-11-05	active	4	3230	28	766	\N	2026-11-04 19:07:11.938487+01
1172	2026-11-05	active	378	9789	28	766	\N	2026-11-04 19:07:11.939809+01
1173	2026-11-05	active	4	3314	28	836	\N	2026-11-04 19:07:11.942043+01
1174	2026-11-05	active	13	5682	28	92	\N	2026-11-04 19:07:11.944047+01
1175	2026-11-05	active	192	6726	28	92	\N	2026-11-04 19:07:11.945458+01
1176	2026-11-05	active	302	8174	28	92	\N	2026-11-04 19:07:11.946742+01
1177	2026-11-05	active	9	6367	28	652	\N	2026-11-04 19:07:11.947997+01
1178	2026-11-05	active	11	8381	28	652	\N	2026-11-04 19:07:11.949228+01
1179	2026-11-05	active	325	5932	28	652	\N	2026-11-04 19:07:11.95035+01
1180	2026-11-05	active	336	7611	28	652	\N	2026-11-04 19:07:11.951864+01
1181	2026-11-05	active	13	5602	28	16	\N	2026-11-04 19:07:11.953267+01
1182	2026-11-05	active	4	3382	28	16	\N	2026-11-04 19:07:11.954828+01
1183	2026-11-05	active	178	6278	28	16	\N	2026-11-04 19:07:11.956422+01
1184	2026-11-05	active	302	8302	28	16	\N	2026-11-04 19:07:11.957803+01
1185	2026-11-05	active	336	5897	28	16	\N	2026-11-04 19:07:11.959146+01
1186	2026-11-05	active	58	38	28	633	\N	2026-11-04 19:07:11.96023+01
1187	2026-11-05	active	2	3814	28	633	\N	2026-11-04 19:07:11.96121+01
1188	2026-11-05	active	26	7348	28	633	\N	2026-11-04 19:07:11.963042+01
1189	2026-11-05	active	66	8488	28	633	\N	2026-11-04 19:07:11.965422+01
1190	2026-11-05	active	389	3338	28	633	\N	2026-11-04 19:07:11.966629+01
1191	2026-11-05	active	11	4017	28	633	\N	2026-11-04 19:07:11.96803+01
1192	2026-11-05	active	303	3291	28	601	\N	2026-11-04 19:07:11.968982+01
1193	2026-11-05	active	55	9919	28	601	\N	2026-11-04 19:07:11.969883+01
1194	2026-11-05	active	4	3302	28	684	\N	2026-11-04 19:07:11.971549+01
1195	2026-11-05	scheduled	1225	1349	616	2834	\N	2026-11-04 19:07:11.975543+01
1196	2026-11-05	scheduled	1416	6355	616	2834	\N	2026-11-04 19:07:11.976917+01
1197	2026-11-05	active	1417	8411	19	366	\N	2026-11-04 19:07:11.977842+01
1198	2026-11-05	scheduled	193	4927	1222	19	\N	2026-11-04 19:07:11.979028+01
1199	2026-11-05	scheduled	4	3912	1222	19	\N	2026-11-04 19:07:11.980015+01
1200	2026-11-05	scheduled	1420	12	2843	4	\N	2026-11-04 19:07:11.981956+01
1201	2026-11-05	scheduled	11	4989	2843	4	\N	2026-11-04 19:07:11.982976+01
1202	2026-11-05	scheduled	46	502	2843	4	\N	2026-11-04 19:07:11.984096+01
1203	2026-11-05	scheduled	305	4940	601	604	\N	2026-11-04 19:07:11.985183+01
1204	2026-11-05	scheduled	8	1161	601	2852	\N	2026-11-04 19:07:11.986197+01
1205	2026-11-05	scheduled	299	7015	601	602	\N	2026-11-04 19:07:11.987119+01
1206	2026-11-05	scheduled	54	4808	601	604	\N	2026-11-04 19:07:11.988038+01
1207	2026-11-05	scheduled	55	9634	601	604	\N	2026-11-04 19:07:11.988883+01
1208	2026-11-05	scheduled	302	6421	601	604	\N	2026-11-04 19:07:11.989755+01
1209	2026-11-05	scheduled	303	3058	601	308	\N	2026-11-04 19:07:11.990912+01
1210	2026-11-05	scheduled	55	9656	601	308	\N	2026-11-04 19:07:11.992107+01
1211	2026-11-05	scheduled	302	6406	601	670	\N	2026-11-04 19:07:11.993479+01
1399	2026-11-05	active	1620	9633	214	3244	56	2026-11-04 19:07:11.994487+01
1213	2026-11-05	scheduled	36	8421	633	2870	\N	2026-11-04 19:07:11.997307+01
1214	2026-11-05	scheduled	26	7373	633	2870	\N	2026-11-04 19:07:11.998676+01
1215	2026-11-05	scheduled	1436	2641	2875	172	\N	2026-11-04 19:07:11.999666+01
1216	2026-11-05	scheduled	1	218	2	688	\N	2026-11-04 19:07:12.000576+01
1217	2026-11-05	scheduled	1438	3100	2592	665	\N	2026-11-04 19:07:12.001427+01
1070	2026-11-05	scheduled	338	911	652	680	\N	2026-11-04 19:07:12.002694+01
1161	2026-11-05	scheduled	700	673	1403	688	\N	2026-11-04 19:07:11.920065+01
1162	2026-11-05	scheduled	118	9093	214	814	\N	2026-11-04 19:07:11.923532+01
1212	2026-11-05	scheduled	57	6059	633	2870	\N	2026-11-04 19:07:11.995923+01
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	<< Flyway Baseline >>	BASELINE	<< Flyway Baseline >>	\N	postgres	2026-11-01 19:46:45.802915	0	t
\.


--
-- Data for Name: live; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.live (flight_id, updated, latitude, longitude, altitude, direction, speed_horizontal, speed_vertical, is_ground) FROM stdin;
1399	2026-11-04 18:49:07+01	22.6257	113.815	0	331	22.224	0	t
\.


--
-- Name: aircraft_aircraft_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.aircraft_aircraft_id_seq', 57, true);


--
-- Name: aircraft_type_aircraft_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.aircraft_type_aircraft_type_id_seq', 21, true);


--
-- Name: airline_airline_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.airline_airline_id_seq', 1756, true);


--
-- Name: airport_airport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.airport_airport_id_seq', 3516, true);


--
-- Name: flight_flight_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.flight_flight_id_seq', 1535, true);


--
-- Name: aircraft aircraft_icao24_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aircraft
    ADD CONSTRAINT aircraft_icao24_key UNIQUE (icao24);


--
-- Name: aircraft aircraft_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aircraft
    ADD CONSTRAINT aircraft_pkey PRIMARY KEY (aircraft_id);


--
-- Name: aircraft aircraft_registration_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aircraft
    ADD CONSTRAINT aircraft_registration_key UNIQUE (registration);


--
-- Name: aircraft_type aircraft_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aircraft_type
    ADD CONSTRAINT aircraft_type_pkey PRIMARY KEY (aircraft_type_id);


--
-- Name: aircraft_type aircraft_type_uq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aircraft_type
    ADD CONSTRAINT aircraft_type_uq UNIQUE (iata_code, icao_code);


--
-- Name: airline airline_iata_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airline
    ADD CONSTRAINT airline_iata_key UNIQUE (iata);


--
-- Name: airline airline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airline
    ADD CONSTRAINT airline_pkey PRIMARY KEY (airline_id);


--
-- Name: airport airport_iata_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airport
    ADD CONSTRAINT airport_iata_key UNIQUE (iata);


--
-- Name: airport airport_icao_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airport
    ADD CONSTRAINT airport_icao_key UNIQUE (icao);


--
-- Name: airport airport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airport
    ADD CONSTRAINT airport_pkey PRIMARY KEY (airport_id);


--
-- Name: arrival arrival_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arrival
    ADD CONSTRAINT arrival_pkey PRIMARY KEY (flight_id);


--
-- Name: codeshare codeshare_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.codeshare
    ADD CONSTRAINT codeshare_pkey PRIMARY KEY (flight_id);


--
-- Name: departure departure_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departure
    ADD CONSTRAINT departure_pkey PRIMARY KEY (flight_id);


--
-- Name: flight flight_natural_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight
    ADD CONSTRAINT flight_natural_key UNIQUE (flight_date, airline_id, flight_number, departure_airport_id);


--
-- Name: flight flight_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight
    ADD CONSTRAINT flight_pkey PRIMARY KEY (flight_id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: live live_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.live
    ADD CONSTRAINT live_pkey PRIMARY KEY (flight_id, updated);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: aircraft fk_aircraft_aircraft_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aircraft
    ADD CONSTRAINT fk_aircraft_aircraft_type FOREIGN KEY (aircraft_type_id) REFERENCES public.aircraft_type(aircraft_type_id);


--
-- Name: flight fk_aircraft_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight
    ADD CONSTRAINT fk_aircraft_id FOREIGN KEY (aircraft_id) REFERENCES public.aircraft(aircraft_id);


--
-- Name: flight fk_airline_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight
    ADD CONSTRAINT fk_airline_id FOREIGN KEY (airline_id) REFERENCES public.airline(airline_id);


--
-- Name: flight fk_arrival_airport_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight
    ADD CONSTRAINT fk_arrival_airport_id FOREIGN KEY (arrival_airport_id) REFERENCES public.airport(airport_id);


--
-- Name: flight fk_departure_airport_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight
    ADD CONSTRAINT fk_departure_airport_id FOREIGN KEY (departure_airport_id) REFERENCES public.airport(airport_id);


--
-- Name: arrival fk_flight_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arrival
    ADD CONSTRAINT fk_flight_id FOREIGN KEY (flight_id) REFERENCES public.flight(flight_id) ON DELETE CASCADE;


--
-- Name: codeshare fk_flight_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.codeshare
    ADD CONSTRAINT fk_flight_id FOREIGN KEY (flight_id) REFERENCES public.flight(flight_id) ON DELETE CASCADE;


--
-- Name: departure fk_flight_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departure
    ADD CONSTRAINT fk_flight_id FOREIGN KEY (flight_id) REFERENCES public.flight(flight_id) ON DELETE CASCADE;


--
-- Name: live fk_flight_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.live
    ADD CONSTRAINT fk_flight_id FOREIGN KEY (flight_id) REFERENCES public.flight(flight_id) ON DELETE CASCADE;


--
-- Name: codeshare fk_operating_airline_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.codeshare
    ADD CONSTRAINT fk_operating_airline_id FOREIGN KEY (operating_airline_id) REFERENCES public.airline(airline_id);


--
-- PostgreSQL database dump complete
--

\unrestrict mL8zNFIdBf7Kd5Rwsu8rwaScqgqlnfILZSTajyxekzr7tX21NnJiyijHzqF1MyM

