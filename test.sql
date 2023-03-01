PGDMP                         {            dydx    12.11     15.1 (Ubuntu 15.1-1.pgdg22.04+1) o    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16401    dydx    DATABASE     p   CREATE DATABASE dydx WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';
    DROP DATABASE dydx;
                dydx    false                        2615    651125    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                dydx    false            �           0    0    SCHEMA public    COMMENT         COMMENT ON SCHEMA public IS '';
                   dydx    false    7            �           0    0    SCHEMA public    ACL     +   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
                   dydx    false    7            �            1259    651287    asset_positions    TABLE     �   CREATE TABLE public.asset_positions (
    id uuid NOT NULL,
    "assetId" character varying(255) NOT NULL,
    "subaccountId" uuid NOT NULL,
    size numeric NOT NULL,
    "isLong" boolean NOT NULL
);
 #   DROP TABLE public.asset_positions;
       public         heap    dydx    false    7            �            1259    651275    assets    TABLE     �   CREATE TABLE public.assets (
    id character varying(255) NOT NULL,
    denom character varying(255) NOT NULL,
    "atomicResolution" integer NOT NULL,
    "hasMarket" boolean NOT NULL,
    "marketId" integer
);
    DROP TABLE public.assets;
       public         heap    dydx    false    7            �            1259    651253    blocks    TABLE     p   CREATE TABLE public.blocks (
    "blockHeight" bigint NOT NULL,
    "time" timestamp with time zone NOT NULL
);
    DROP TABLE public.blocks;
       public         heap    dydx    false    7            �            1259    651200    fills    TABLE     �  CREATE TABLE public.fills (
    id uuid NOT NULL,
    "subaccountId" uuid NOT NULL,
    side text NOT NULL,
    liquidity text NOT NULL,
    type text NOT NULL,
    "clobPairId" bigint NOT NULL,
    "orderId" uuid,
    size numeric NOT NULL,
    price numeric NOT NULL,
    "quoteAmount" numeric NOT NULL,
    "eventId" uuid NOT NULL,
    "transactionHash" character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "createdAtHeight" bigint NOT NULL,
    CONSTRAINT fills_liquidity_check CHECK ((liquidity = ANY (ARRAY['TAKER'::text, 'MAKER'::text]))),
    CONSTRAINT fills_side_check CHECK ((side = ANY (ARRAY['BUY'::text, 'SELL'::text]))),
    CONSTRAINT fills_type_check CHECK ((type = ANY (ARRAY['LIMIT'::text, 'MARKET'::text, 'STOP_LIMIT'::text, 'STOP_MARKET'::text, 'TRAILING_STOP'::text, 'TAKE_PROFIT'::text, 'TAKE_PROFIT_MARKET'::text, 'LIQUIDATED'::text, 'LIQUIDATION'::text, 'HARD_TRADE'::text, 'FAILED_HARD_TRADE'::text, 'TRANSFER_PLACEHOLDER'::text])))
);
    DROP TABLE public.fills;
       public         heap    dydx    false    7            �            1259    651128    knex_migrations    TABLE     �   CREATE TABLE public.knex_migrations (
    id integer NOT NULL,
    name character varying(255),
    batch integer,
    migration_time timestamp with time zone
);
 #   DROP TABLE public.knex_migrations;
       public         heap    dydx    false    7            �            1259    651126    knex_migrations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.knex_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.knex_migrations_id_seq;
       public          dydx    false    7    203            �           0    0    knex_migrations_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.knex_migrations_id_seq OWNED BY public.knex_migrations.id;
          public          dydx    false    202            �            1259    651136    knex_migrations_lock    TABLE     `   CREATE TABLE public.knex_migrations_lock (
    index integer NOT NULL,
    is_locked integer
);
 (   DROP TABLE public.knex_migrations_lock;
       public         heap    dydx    false    7            �            1259    651134    knex_migrations_lock_index_seq    SEQUENCE     �   CREATE SEQUENCE public.knex_migrations_lock_index_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.knex_migrations_lock_index_seq;
       public          dydx    false    205    7            �           0    0    knex_migrations_lock_index_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.knex_migrations_lock_index_seq OWNED BY public.knex_migrations_lock.index;
          public          dydx    false    204            �            1259    651340    markets    TABLE     �   CREATE TABLE public.markets (
    id integer NOT NULL,
    pair character varying(255) NOT NULL,
    exponent integer NOT NULL,
    "minPriceChangePpm" integer NOT NULL,
    "oraclePrice" numeric
);
    DROP TABLE public.markets;
       public         heap    dydx    false    7            �            1259    651361    oracle_prices    TABLE     �   CREATE TABLE public.oracle_prices (
    id uuid NOT NULL,
    "marketId" integer NOT NULL,
    price numeric NOT NULL,
    "effectiveAt" timestamp with time zone NOT NULL,
    "effectiveAtHeight" bigint NOT NULL
);
 !   DROP TABLE public.oracle_prices;
       public         heap    dydx    false    7            �            1259    651157    orders    TABLE     )  CREATE TABLE public.orders (
    id uuid NOT NULL,
    "subaccountId" uuid NOT NULL,
    "clientId" bigint NOT NULL,
    "clobPairId" bigint NOT NULL,
    side text NOT NULL,
    size numeric NOT NULL,
    "totalFilled" numeric NOT NULL,
    price numeric NOT NULL,
    type text NOT NULL,
    status text NOT NULL,
    "timeInForce" text NOT NULL,
    "reduceOnly" boolean NOT NULL,
    "orderFlags" bigint NOT NULL,
    "goodTilBlock" bigint,
    "goodTilBlockTime" timestamp with time zone,
    CONSTRAINT good_til_block_or_good_til_block_time_non_null CHECK ((num_nonnulls("goodTilBlock", "goodTilBlockTime") = 1)),
    CONSTRAINT orders_side_check CHECK ((side = ANY (ARRAY['BUY'::text, 'SELL'::text]))),
    CONSTRAINT orders_status_check CHECK ((status = ANY (ARRAY['OPEN'::text, 'FILLED'::text, 'CANCELED'::text, 'BEST_EFFORT_CANCELED'::text]))),
    CONSTRAINT "orders_timeInForce_check" CHECK (("timeInForce" = ANY (ARRAY['GTT'::text, 'FOK'::text, 'IOC'::text, 'POST_ONLY'::text]))),
    CONSTRAINT orders_type_check CHECK ((type = ANY (ARRAY['LIMIT'::text, 'MARKET'::text, 'STOP_LIMIT'::text, 'STOP_MARKET'::text, 'TRAILING_STOP'::text, 'TAKE_PROFIT'::text, 'TAKE_PROFIT_MARKET'::text, 'LIQUIDATED'::text, 'LIQUIDATION'::text, 'HARD_TRADE'::text, 'FAILED_HARD_TRADE'::text, 'TRANSFER_PLACEHOLDER'::text])))
);
    DROP TABLE public.orders;
       public         heap    dydx    false    7            �            1259    651148    perpetual_markets    TABLE     �  CREATE TABLE public.perpetual_markets (
    id bigint NOT NULL,
    "clobPairId" bigint NOT NULL,
    ticker character varying(255) NOT NULL,
    "marketId" integer NOT NULL,
    status text NOT NULL,
    "baseAsset" character varying(255) NOT NULL,
    "quoteAsset" character varying(255) NOT NULL,
    "lastPrice" numeric NOT NULL,
    "priceChange24H" numeric NOT NULL,
    "volume24H" numeric NOT NULL,
    "trades24H" integer NOT NULL,
    "nextFundingRate" numeric NOT NULL,
    "nextFundingUpdate" integer NOT NULL,
    "initialMarginFraction" numeric NOT NULL,
    "incrementalInitialMarginFraction" numeric NOT NULL,
    "maintenanceMarginFraction" numeric NOT NULL,
    "basePositionSize" numeric NOT NULL,
    "incrementalPositionSize" numeric NOT NULL,
    "maxPositionSize" numeric NOT NULL,
    "openInterest" numeric NOT NULL,
    "quantumConversionExponent" integer NOT NULL,
    "atomicResolution" integer NOT NULL,
    "subticksPerTick" integer NOT NULL,
    "minOrderBaseQuantums" integer NOT NULL,
    "stepBaseQuantums" integer NOT NULL,
    CONSTRAINT perpetual_markets_status_check CHECK ((status = ANY (ARRAY['ACTIVE'::text, 'PAUSED'::text, 'CANCEL_ONLY'::text, 'POST_ONLY'::text])))
);
 %   DROP TABLE public.perpetual_markets;
       public         heap    dydx    false    7            �            1259    651176    perpetual_positions    TABLE     z  CREATE TABLE public.perpetual_positions (
    id uuid NOT NULL,
    "subaccountId" uuid NOT NULL,
    "perpetualId" bigint NOT NULL,
    side text NOT NULL,
    status text NOT NULL,
    size numeric NOT NULL,
    "maxSize" numeric NOT NULL,
    "entryPrice" numeric NOT NULL,
    "exitPrice" numeric,
    "sumOpen" numeric NOT NULL,
    "sumClose" numeric NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "closedAt" timestamp with time zone,
    "createdAtHeight" bigint NOT NULL,
    "closedAtHeight" bigint,
    "openEventId" uuid NOT NULL,
    "closeEventId" uuid,
    "lastEventId" uuid NOT NULL,
    "netFunding" numeric NOT NULL,
    CONSTRAINT perpetual_positions_side_check CHECK ((side = ANY (ARRAY['LONG'::text, 'SHORT'::text]))),
    CONSTRAINT perpetual_positions_status_check CHECK ((status = ANY (ARRAY['OPEN'::text, 'CLOSED'::text, 'LIQUIDATED'::text])))
);
 '   DROP TABLE public.perpetual_positions;
       public         heap    dydx    false    7            �            1259    651142    subaccounts    TABLE     �   CREATE TABLE public.subaccounts (
    id uuid NOT NULL,
    address character varying(255) NOT NULL,
    "subaccountNumber" integer NOT NULL
);
    DROP TABLE public.subaccounts;
       public         heap    dydx    false    7            �            1259    651226    tendermint_events    TABLE     �   CREATE TABLE public.tendermint_events (
    id uuid NOT NULL,
    "blockHeight" bigint NOT NULL,
    "transactionIndex" integer NOT NULL,
    "eventIndex" integer NOT NULL
);
 %   DROP TABLE public.tendermint_events;
       public         heap    dydx    false    7            �            1259    651268    transactions    TABLE     �   CREATE TABLE public.transactions (
    id uuid NOT NULL,
    "blockHeight" bigint NOT NULL,
    "transactionIndex" integer NOT NULL,
    "transactionHash" character varying(255) NOT NULL
);
     DROP TABLE public.transactions;
       public         heap    dydx    false    7            �            1259    651307 	   transfers    TABLE     �  CREATE TABLE public.transfers (
    id uuid NOT NULL,
    "senderSubaccountId" uuid NOT NULL,
    "recipientSubaccountId" uuid NOT NULL,
    "assetId" character varying(255) NOT NULL,
    size numeric NOT NULL,
    "eventId" uuid NOT NULL,
    "transactionHash" character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "createdAtHeight" bigint NOT NULL
);
    DROP TABLE public.transfers;
       public         heap    dydx    false    7            �           2604    651131    knex_migrations id    DEFAULT     x   ALTER TABLE ONLY public.knex_migrations ALTER COLUMN id SET DEFAULT nextval('public.knex_migrations_id_seq'::regclass);
 A   ALTER TABLE public.knex_migrations ALTER COLUMN id DROP DEFAULT;
       public          dydx    false    202    203    203            �           2604    651139    knex_migrations_lock index    DEFAULT     �   ALTER TABLE ONLY public.knex_migrations_lock ALTER COLUMN index SET DEFAULT nextval('public.knex_migrations_lock_index_seq'::regclass);
 I   ALTER TABLE public.knex_migrations_lock ALTER COLUMN index DROP DEFAULT;
       public          dydx    false    205    204    205            �          0    651287    asset_positions 
   TABLE DATA           X   COPY public.asset_positions (id, "assetId", "subaccountId", size, "isLong") FROM stdin;
    public          dydx    false    215   ?�       �          0    651275    assets 
   TABLE DATA           X   COPY public.assets (id, denom, "atomicResolution", "hasMarket", "marketId") FROM stdin;
    public          dydx    false    214   Ц       �          0    651253    blocks 
   TABLE DATA           7   COPY public.blocks ("blockHeight", "time") FROM stdin;
    public          dydx    false    212   ��       �          0    651200    fills 
   TABLE DATA           �   COPY public.fills (id, "subaccountId", side, liquidity, type, "clobPairId", "orderId", size, price, "quoteAmount", "eventId", "transactionHash", "createdAt", "createdAtHeight") FROM stdin;
    public          dydx    false    210   �       �          0    651128    knex_migrations 
   TABLE DATA           J   COPY public.knex_migrations (id, name, batch, migration_time) FROM stdin;
    public          dydx    false    203   5�       �          0    651136    knex_migrations_lock 
   TABLE DATA           @   COPY public.knex_migrations_lock (index, is_locked) FROM stdin;
    public          dydx    false    205   5�       �          0    651340    markets 
   TABLE DATA           Y   COPY public.markets (id, pair, exponent, "minPriceChangePpm", "oraclePrice") FROM stdin;
    public          dydx    false    217   V�       �          0    651361    oracle_prices 
   TABLE DATA           b   COPY public.oracle_prices (id, "marketId", price, "effectiveAt", "effectiveAtHeight") FROM stdin;
    public          dydx    false    218   ��       �          0    651157    orders 
   TABLE DATA           �   COPY public.orders (id, "subaccountId", "clientId", "clobPairId", side, size, "totalFilled", price, type, status, "timeInForce", "reduceOnly", "orderFlags", "goodTilBlock", "goodTilBlockTime") FROM stdin;
    public          dydx    false    208   ��       �          0    651148    perpetual_markets 
   TABLE DATA           �  COPY public.perpetual_markets (id, "clobPairId", ticker, "marketId", status, "baseAsset", "quoteAsset", "lastPrice", "priceChange24H", "volume24H", "trades24H", "nextFundingRate", "nextFundingUpdate", "initialMarginFraction", "incrementalInitialMarginFraction", "maintenanceMarginFraction", "basePositionSize", "incrementalPositionSize", "maxPositionSize", "openInterest", "quantumConversionExponent", "atomicResolution", "subticksPerTick", "minOrderBaseQuantums", "stepBaseQuantums") FROM stdin;
    public          dydx    false    207   ܩ       �          0    651176    perpetual_positions 
   TABLE DATA             COPY public.perpetual_positions (id, "subaccountId", "perpetualId", side, status, size, "maxSize", "entryPrice", "exitPrice", "sumOpen", "sumClose", "createdAt", "closedAt", "createdAtHeight", "closedAtHeight", "openEventId", "closeEventId", "lastEventId", "netFunding") FROM stdin;
    public          dydx    false    209   ?�       �          0    651142    subaccounts 
   TABLE DATA           F   COPY public.subaccounts (id, address, "subaccountNumber") FROM stdin;
    public          dydx    false    206   \�       �          0    651226    tendermint_events 
   TABLE DATA           `   COPY public.tendermint_events (id, "blockHeight", "transactionIndex", "eventIndex") FROM stdin;
    public          dydx    false    211   ̰       �          0    651268    transactions 
   TABLE DATA           `   COPY public.transactions (id, "blockHeight", "transactionIndex", "transactionHash") FROM stdin;
    public          dydx    false    213   �       �          0    651307 	   transfers 
   TABLE DATA           �   COPY public.transfers (id, "senderSubaccountId", "recipientSubaccountId", "assetId", size, "eventId", "transactionHash", "createdAt", "createdAtHeight") FROM stdin;
    public          dydx    false    216   �       �           0    0    knex_migrations_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.knex_migrations_id_seq', 20, true);
          public          dydx    false    202            �           0    0    knex_migrations_lock_index_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.knex_migrations_lock_index_seq', 1, true);
          public          dydx    false    204            �           2606    651294 $   asset_positions asset_positions_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.asset_positions
    ADD CONSTRAINT asset_positions_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.asset_positions DROP CONSTRAINT asset_positions_pkey;
       public            dydx    false    215            �           2606    651284    assets assets_denom_unique 
   CONSTRAINT     V   ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_denom_unique UNIQUE (denom);
 D   ALTER TABLE ONLY public.assets DROP CONSTRAINT assets_denom_unique;
       public            dydx    false    214            �           2606    651282    assets assets_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.assets DROP CONSTRAINT assets_pkey;
       public            dydx    false    214            �           2606    651257    blocks blocks_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY ("blockHeight");
 <   ALTER TABLE ONLY public.blocks DROP CONSTRAINT blocks_pkey;
       public            dydx    false    212            �           2606    651210    fills fills_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.fills
    ADD CONSTRAINT fills_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.fills DROP CONSTRAINT fills_pkey;
       public            dydx    false    210            �           2606    651141 .   knex_migrations_lock knex_migrations_lock_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.knex_migrations_lock
    ADD CONSTRAINT knex_migrations_lock_pkey PRIMARY KEY (index);
 X   ALTER TABLE ONLY public.knex_migrations_lock DROP CONSTRAINT knex_migrations_lock_pkey;
       public            dydx    false    205            �           2606    651133 $   knex_migrations knex_migrations_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.knex_migrations
    ADD CONSTRAINT knex_migrations_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.knex_migrations DROP CONSTRAINT knex_migrations_pkey;
       public            dydx    false    203            �           2606    651349    markets markets_pair_unique 
   CONSTRAINT     V   ALTER TABLE ONLY public.markets
    ADD CONSTRAINT markets_pair_unique UNIQUE (pair);
 E   ALTER TABLE ONLY public.markets DROP CONSTRAINT markets_pair_unique;
       public            dydx    false    217            �           2606    651347    markets markets_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.markets
    ADD CONSTRAINT markets_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.markets DROP CONSTRAINT markets_pkey;
       public            dydx    false    217            �           2606    651368     oracle_prices oracle_prices_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.oracle_prices
    ADD CONSTRAINT oracle_prices_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.oracle_prices DROP CONSTRAINT oracle_prices_pkey;
       public            dydx    false    218            �           2606    651168    orders orders_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            dydx    false    208            �           2606    651156 (   perpetual_markets perpetual_markets_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.perpetual_markets
    ADD CONSTRAINT perpetual_markets_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.perpetual_markets DROP CONSTRAINT perpetual_markets_pkey;
       public            dydx    false    207            �           2606    651185 ,   perpetual_positions perpetual_positions_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.perpetual_positions
    ADD CONSTRAINT perpetual_positions_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.perpetual_positions DROP CONSTRAINT perpetual_positions_pkey;
       public            dydx    false    209            �           2606    651146    subaccounts subaccounts_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.subaccounts
    ADD CONSTRAINT subaccounts_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.subaccounts DROP CONSTRAINT subaccounts_pkey;
       public            dydx    false    206            �           2606    651230 (   tendermint_events tendermint_events_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.tendermint_events
    ADD CONSTRAINT tendermint_events_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.tendermint_events DROP CONSTRAINT tendermint_events_pkey;
       public            dydx    false    211            �           2606    651272    transactions transactions_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.transactions DROP CONSTRAINT transactions_pkey;
       public            dydx    false    213            �           2606    651314    transfers transfers_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.transfers DROP CONSTRAINT transfers_pkey;
       public            dydx    false    216            �           1259    651306 *   asset_positions_subaccountid_assetid_index    INDEX     {   CREATE INDEX asset_positions_subaccountid_assetid_index ON public.asset_positions USING btree ("subaccountId", "assetId");
 >   DROP INDEX public.asset_positions_subaccountid_assetid_index;
       public            dydx    false    215    215            �           1259    651305 "   asset_positions_subaccountid_index    INDEX     h   CREATE INDEX asset_positions_subaccountid_index ON public.asset_positions USING btree ("subaccountId");
 6   DROP INDEX public.asset_positions_subaccountid_index;
       public            dydx    false    215            �           1259    651285    assets_denom_index    INDEX     F   CREATE INDEX assets_denom_index ON public.assets USING btree (denom);
 &   DROP INDEX public.assets_denom_index;
       public            dydx    false    214            �           1259    651286    assets_marketid_index    INDEX     N   CREATE INDEX assets_marketid_index ON public.assets USING btree ("marketId");
 )   DROP INDEX public.assets_marketid_index;
       public            dydx    false    214            �           1259    651224     fills_clobpairid_createdat_index    INDEX     g   CREATE INDEX fills_clobpairid_createdat_index ON public.fills USING btree ("clobPairId", "createdAt");
 4   DROP INDEX public.fills_clobpairid_createdat_index;
       public            dydx    false    210    210            �           1259    651225    fills_orderid_index    INDEX     J   CREATE INDEX fills_orderid_index ON public.fills USING btree ("orderId");
 '   DROP INDEX public.fills_orderid_index;
       public            dydx    false    210            �           1259    651223 #   fills_subaccountid_clobpairid_index    INDEX     m   CREATE INDEX fills_subaccountid_clobpairid_index ON public.fills USING btree ("subaccountId", "clobPairId");
 7   DROP INDEX public.fills_subaccountid_clobpairid_index;
       public            dydx    false    210    210            �           1259    651221 "   fills_subaccountid_createdat_index    INDEX     k   CREATE INDEX fills_subaccountid_createdat_index ON public.fills USING btree ("subaccountId", "createdAt");
 6   DROP INDEX public.fills_subaccountid_createdat_index;
       public            dydx    false    210    210            �           1259    651222 (   fills_subaccountid_createdatheight_index    INDEX     w   CREATE INDEX fills_subaccountid_createdatheight_index ON public.fills USING btree ("subaccountId", "createdAtHeight");
 <   DROP INDEX public.fills_subaccountid_createdatheight_index;
       public            dydx    false    210    210            �           1259    651350    markets_pair_index    INDEX     F   CREATE INDEX markets_pair_index ON public.markets USING btree (pair);
 &   DROP INDEX public.markets_pair_index;
       public            dydx    false    217            �           1259    651379 (   oracle_prices_marketid_effectiveat_index    INDEX     w   CREATE INDEX oracle_prices_marketid_effectiveat_index ON public.oracle_prices USING btree ("marketId", "effectiveAt");
 <   DROP INDEX public.oracle_prices_marketid_effectiveat_index;
       public            dydx    false    218    218            �           1259    651380    oracle_prices_marketid_index    INDEX     \   CREATE INDEX oracle_prices_marketid_index ON public.oracle_prices USING btree ("marketId");
 0   DROP INDEX public.oracle_prices_marketid_index;
       public            dydx    false    218            �           1259    651175 "   orders_clobpairid_side_price_index    INDEX     j   CREATE INDEX orders_clobpairid_side_price_index ON public.orders USING btree ("clobPairId", side, price);
 6   DROP INDEX public.orders_clobpairid_side_price_index;
       public            dydx    false    208    208    208            �           1259    651174    orders_subaccountid_index    INDEX     V   CREATE INDEX orders_subaccountid_index ON public.orders USING btree ("subaccountId");
 -   DROP INDEX public.orders_subaccountid_index;
       public            dydx    false    208            �           1259    651199 ,   perpetual_positions_perpetualid_status_index    INDEX     }   CREATE INDEX perpetual_positions_perpetualid_status_index ON public.perpetual_positions USING btree ("perpetualId", status);
 @   DROP INDEX public.perpetual_positions_perpetualid_status_index;
       public            dydx    false    209    209            �           1259    651197 0   perpetual_positions_subaccountid_createdat_index    INDEX     �   CREATE INDEX perpetual_positions_subaccountid_createdat_index ON public.perpetual_positions USING btree ("subaccountId", "createdAt");
 D   DROP INDEX public.perpetual_positions_subaccountid_createdat_index;
       public            dydx    false    209    209            �           1259    651198 6   perpetual_positions_subaccountid_createdatheight_index    INDEX     �   CREATE INDEX perpetual_positions_subaccountid_createdatheight_index ON public.perpetual_positions USING btree ("subaccountId", "createdAtHeight");
 J   DROP INDEX public.perpetual_positions_subaccountid_createdatheight_index;
       public            dydx    false    209    209            �           1259    651196 -   perpetual_positions_subaccountid_status_index    INDEX        CREATE INDEX perpetual_positions_subaccountid_status_index ON public.perpetual_positions USING btree ("subaccountId", status);
 A   DROP INDEX public.perpetual_positions_subaccountid_status_index;
       public            dydx    false    209    209            �           1259    651147    subaccounts_address_index    INDEX     T   CREATE INDEX subaccounts_address_index ON public.subaccounts USING btree (address);
 -   DROP INDEX public.subaccounts_address_index;
       public            dydx    false    206            �           1259    651231 #   tendermint_events_blockheight_index    INDEX     j   CREATE INDEX tendermint_events_blockheight_index ON public.tendermint_events USING btree ("blockHeight");
 7   DROP INDEX public.tendermint_events_blockheight_index;
       public            dydx    false    211            �           1259    651232 4   tendermint_events_blockheight_transactionindex_index    INDEX     �   CREATE INDEX tendermint_events_blockheight_transactionindex_index ON public.tendermint_events USING btree ("blockHeight", "transactionIndex");
 H   DROP INDEX public.tendermint_events_blockheight_transactionindex_index;
       public            dydx    false    211    211            �           1259    651273    transactions_blockheight_index    INDEX     `   CREATE INDEX transactions_blockheight_index ON public.transactions USING btree ("blockHeight");
 2   DROP INDEX public.transactions_blockheight_index;
       public            dydx    false    213            �           1259    651274 /   transactions_blockheight_transactionindex_index    INDEX     �   CREATE INDEX transactions_blockheight_transactionindex_index ON public.transactions USING btree ("blockHeight", "transactionIndex");
 C   DROP INDEX public.transactions_blockheight_transactionindex_index;
       public            dydx    false    213    213            �           1259    651339 !   transfers_assetid_createdat_index    INDEX     i   CREATE INDEX transfers_assetid_createdat_index ON public.transfers USING btree ("assetId", "createdAt");
 5   DROP INDEX public.transfers_assetid_createdat_index;
       public            dydx    false    216    216            �           1259    651337 /   transfers_recipientsubaccountid_createdat_index    INDEX     �   CREATE INDEX transfers_recipientsubaccountid_createdat_index ON public.transfers USING btree ("recipientSubaccountId", "createdAt");
 C   DROP INDEX public.transfers_recipientsubaccountid_createdat_index;
       public            dydx    false    216    216            �           1259    651338 5   transfers_recipientsubaccountid_createdatheight_index    INDEX     �   CREATE INDEX transfers_recipientsubaccountid_createdatheight_index ON public.transfers USING btree ("recipientSubaccountId", "createdAtHeight");
 I   DROP INDEX public.transfers_recipientsubaccountid_createdatheight_index;
       public            dydx    false    216    216            �           1259    651335 ,   transfers_sendersubaccountid_createdat_index    INDEX        CREATE INDEX transfers_sendersubaccountid_createdat_index ON public.transfers USING btree ("senderSubaccountId", "createdAt");
 @   DROP INDEX public.transfers_sendersubaccountid_createdat_index;
       public            dydx    false    216    216            �           1259    651336 2   transfers_sendersubaccountid_createdatheight_index    INDEX     �   CREATE INDEX transfers_sendersubaccountid_createdatheight_index ON public.transfers USING btree ("senderSubaccountId", "createdAtHeight");
 F   DROP INDEX public.transfers_sendersubaccountid_createdatheight_index;
       public            dydx    false    216    216            �           2606    651295 /   asset_positions asset_positions_assetid_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.asset_positions
    ADD CONSTRAINT asset_positions_assetid_foreign FOREIGN KEY ("assetId") REFERENCES public.assets(id);
 Y   ALTER TABLE ONLY public.asset_positions DROP CONSTRAINT asset_positions_assetid_foreign;
       public          dydx    false    215    214    3803            �           2606    651300 4   asset_positions asset_positions_subaccountid_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.asset_positions
    ADD CONSTRAINT asset_positions_subaccountid_foreign FOREIGN KEY ("subaccountId") REFERENCES public.subaccounts(id);
 ^   ALTER TABLE ONLY public.asset_positions DROP CONSTRAINT asset_positions_subaccountid_foreign;
       public          dydx    false    3768    215    206            �           2606    651356    assets assets_marketid_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_marketid_foreign FOREIGN KEY ("marketId") REFERENCES public.markets(id);
 H   ALTER TABLE ONLY public.assets DROP CONSTRAINT assets_marketid_foreign;
       public          dydx    false    214    217    3819            �           2606    651258 #   fills fills_createdatheight_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.fills
    ADD CONSTRAINT fills_createdatheight_foreign FOREIGN KEY ("createdAtHeight") REFERENCES public.blocks("blockHeight");
 M   ALTER TABLE ONLY public.fills DROP CONSTRAINT fills_createdatheight_foreign;
       public          dydx    false    212    210    3793            �           2606    651233    fills fills_eventid_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.fills
    ADD CONSTRAINT fills_eventid_foreign FOREIGN KEY ("eventId") REFERENCES public.tendermint_events(id);
 E   ALTER TABLE ONLY public.fills DROP CONSTRAINT fills_eventid_foreign;
       public          dydx    false    211    3791    210            �           2606    651216    fills fills_orderid_foreign    FK CONSTRAINT     }   ALTER TABLE ONLY public.fills
    ADD CONSTRAINT fills_orderid_foreign FOREIGN KEY ("orderId") REFERENCES public.orders(id);
 E   ALTER TABLE ONLY public.fills DROP CONSTRAINT fills_orderid_foreign;
       public          dydx    false    210    3773    208            �           2606    651211     fills fills_subaccountid_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.fills
    ADD CONSTRAINT fills_subaccountid_foreign FOREIGN KEY ("subaccountId") REFERENCES public.subaccounts(id);
 J   ALTER TABLE ONLY public.fills DROP CONSTRAINT fills_subaccountid_foreign;
       public          dydx    false    210    206    3768                       2606    651374 5   oracle_prices oracle_prices_effectiveatheight_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.oracle_prices
    ADD CONSTRAINT oracle_prices_effectiveatheight_foreign FOREIGN KEY ("effectiveAtHeight") REFERENCES public.blocks("blockHeight");
 _   ALTER TABLE ONLY public.oracle_prices DROP CONSTRAINT oracle_prices_effectiveatheight_foreign;
       public          dydx    false    3793    218    212                       2606    651369 ,   oracle_prices oracle_prices_marketid_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.oracle_prices
    ADD CONSTRAINT oracle_prices_marketid_foreign FOREIGN KEY ("marketId") REFERENCES public.markets(id);
 V   ALTER TABLE ONLY public.oracle_prices DROP CONSTRAINT oracle_prices_marketid_foreign;
       public          dydx    false    3819    217    218            �           2606    651169 "   orders orders_subaccountid_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_subaccountid_foreign FOREIGN KEY ("subaccountId") REFERENCES public.subaccounts(id);
 L   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_subaccountid_foreign;
       public          dydx    false    3768    208    206            �           2606    651351 4   perpetual_markets perpetual_markets_marketid_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.perpetual_markets
    ADD CONSTRAINT perpetual_markets_marketid_foreign FOREIGN KEY ("marketId") REFERENCES public.markets(id);
 ^   ALTER TABLE ONLY public.perpetual_markets DROP CONSTRAINT perpetual_markets_marketid_foreign;
       public          dydx    false    207    3819    217            �           2606    651243 <   perpetual_positions perpetual_positions_closeeventid_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.perpetual_positions
    ADD CONSTRAINT perpetual_positions_closeeventid_foreign FOREIGN KEY ("closeEventId") REFERENCES public.tendermint_events(id);
 f   ALTER TABLE ONLY public.perpetual_positions DROP CONSTRAINT perpetual_positions_closeeventid_foreign;
       public          dydx    false    211    3791    209            �           2606    651248 ;   perpetual_positions perpetual_positions_lasteventid_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.perpetual_positions
    ADD CONSTRAINT perpetual_positions_lasteventid_foreign FOREIGN KEY ("lastEventId") REFERENCES public.tendermint_events(id);
 e   ALTER TABLE ONLY public.perpetual_positions DROP CONSTRAINT perpetual_positions_lasteventid_foreign;
       public          dydx    false    211    209    3791            �           2606    651238 ;   perpetual_positions perpetual_positions_openeventid_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.perpetual_positions
    ADD CONSTRAINT perpetual_positions_openeventid_foreign FOREIGN KEY ("openEventId") REFERENCES public.tendermint_events(id);
 e   ALTER TABLE ONLY public.perpetual_positions DROP CONSTRAINT perpetual_positions_openeventid_foreign;
       public          dydx    false    211    3791    209            �           2606    651186 ;   perpetual_positions perpetual_positions_perpetualid_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.perpetual_positions
    ADD CONSTRAINT perpetual_positions_perpetualid_foreign FOREIGN KEY ("perpetualId") REFERENCES public.perpetual_markets(id);
 e   ALTER TABLE ONLY public.perpetual_positions DROP CONSTRAINT perpetual_positions_perpetualid_foreign;
       public          dydx    false    209    207    3770            �           2606    651191 <   perpetual_positions perpetual_positions_subaccountid_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.perpetual_positions
    ADD CONSTRAINT perpetual_positions_subaccountid_foreign FOREIGN KEY ("subaccountId") REFERENCES public.subaccounts(id);
 f   ALTER TABLE ONLY public.perpetual_positions DROP CONSTRAINT perpetual_positions_subaccountid_foreign;
       public          dydx    false    209    206    3768            �           2606    651263 7   tendermint_events tendermint_events_blockheight_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.tendermint_events
    ADD CONSTRAINT tendermint_events_blockheight_foreign FOREIGN KEY ("blockHeight") REFERENCES public.blocks("blockHeight");
 a   ALTER TABLE ONLY public.tendermint_events DROP CONSTRAINT tendermint_events_blockheight_foreign;
       public          dydx    false    211    3793    212            �           2606    651325 #   transfers transfers_assetid_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_assetid_foreign FOREIGN KEY ("assetId") REFERENCES public.assets(id);
 M   ALTER TABLE ONLY public.transfers DROP CONSTRAINT transfers_assetid_foreign;
       public          dydx    false    214    3803    216                        2606    651330 #   transfers transfers_eventid_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_eventid_foreign FOREIGN KEY ("eventId") REFERENCES public.tendermint_events(id);
 M   ALTER TABLE ONLY public.transfers DROP CONSTRAINT transfers_eventid_foreign;
       public          dydx    false    3791    216    211                       2606    651320 1   transfers transfers_recipientsubaccountid_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_recipientsubaccountid_foreign FOREIGN KEY ("recipientSubaccountId") REFERENCES public.subaccounts(id);
 [   ALTER TABLE ONLY public.transfers DROP CONSTRAINT transfers_recipientsubaccountid_foreign;
       public          dydx    false    206    216    3768                       2606    651315 .   transfers transfers_sendersubaccountid_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_sendersubaccountid_foreign FOREIGN KEY ("senderSubaccountId") REFERENCES public.subaccounts(id);
 X   ALTER TABLE ONLY public.transfers DROP CONSTRAINT transfers_sendersubaccountid_foreign;
       public          dydx    false    216    206    3768            �   �  x�eVI�k���~����%R�
���`ߑ/�S�*V#������6�N���s���������+�^�_�N��I�[���������wo6�;�.ɸ���hnۻ��v�w�nS�g���xI8�Y^{b�oh�c��M<3�Q��k9�Y��t�c6���F#Iq
������{����x��P�b<3�QSdkqz�%����ZU:&8_&o�M-zZK���o��K`��g�L�����k�T@�����S�M61'�}b�u��EN��C_�7��F�{���l,@[� �� ���ơe����r�@�b�/�\x�2�[�H����������Ew�|\��,�>$�����`3�#�e�o'S�v,�����@O�A�E��
��Y]�e����
�;;�)[.��������6�/o�J2!��~�M_��^?���l	����4�nتD���{\��YK�� om8��F�f?w�[���k�;!�7αM�{�gh��z���z�i'i�Q�x�H/��?��۬�^���+S�"0�h�>Bd�h���8�@7�tj�K��[�p=b]����gF\�<A}A|�C3:��n_�Jr�<�T7ht9̴���o��vC2a3��7�h�|���%���aIp�_ȃ�	k��M�ܿ��9�`e}^�I��.l���޶�.k!wP!��z�<+���}�Ь��L�HL��x�X��G����B5������4��f�y6����ri5j2���d����-O|���L$"C�r6�C
	��$���m��E�'ŪAb�Y��E���S�,���7�HFZ��@�k��z�u(D��2a�H�XH�b�@�Vn�<�"Z8\!���9�'��F��}���/w�)�/Ym^>@w�]�֋#�9�!>�K�/�J���7���3�GK�*���Xq��H@���q�F �D�x	$m�jw�O^s�}Ŋ�k$w*>��:�4c�yk�x�!lo�N^� �Hd��EW3�!d��Јq0�!!"p\�u��y؟e��ъ1-�k��b�5���5��׭A	���E��m�}2������ۨp48ދ���D~g��;�J���S����j�N�Շ�i88v�P&@�N��ڂf����:�+��{w��3��{��5J5�5���:������i�?k<�7и��#PB�ѹp}��qf���K��[�+�Q�ks��H�]_(~6��܎qr�].�8�����m,�:��		�~�)C;_� Z��R\�����ՄxB_ߖ��U��O������(A
P�({�Y��VXb=.n�������= �9����P[=K
�a�Y5�w���, ��H4(�Q�E3�L�����̌Ӱ�t�75���BԬ��Px������߿�ш�y      �      x�3�vq��5�L�4������ $'/      �      x������ � �      �      x������ � �      �   �  x����n�0������U��cc�gY�"�Tl�0T���`L�E�*WH���3�OD�P	`m���5~8e�Mo����������L����}.�� ;�A(%#&��v��3�;�M�q�p�$2�	�v��6���A�L ֒.����m�@1�!�#J&�BZ.�c���4f��,�ΑP0�ӽm�k�u0پ٦�x����c�e�K��YQͱ��kcN��YLJ���'�ڲ��&NF�k4�DΒ!ז�-8��p!��]��QS�%�IN@�J�\��'�HW�`Ijف�h|QFK?\@���cj%�XP��v{���6�L��=�ɐ���	ѐ!���aG�m
�Q��P  �pbm$J� mO �@�Y("Z�pB΍TW�e&�tA~w-!���)5Fu�2fR_�(]P�եݲRQ�b���ŨX�H
�����*ӄ}k�L�6>�j��׶�L_�y�����s��0:�>�}/���Gjb����v�O��ǀ      �      x�3�4������ V      �   <   x�3�t
q�v��5�45�42 .CN���H��(h������ �p��qqq ��k      �      x������ � �      �      x������ � �      �   S   x�3�4�t
q�v��C<�\99�L$�g`j �1�	������� D\�����!`��0����A	�=... Hq      �      x������ � �      �   `  x�MVɮ�[��7[��/�� Sgp���r��כ
�"$R$ͅN���↡傹���p�m�_��}�wo�-kg��~�B�D����]/���/�':.4(�R�C"�[ò��������[�g�=͗K6�wɦ�� �h���jT	\�`����C�,�Wﴀ(��N���UϢj5Ş��qٹ�p�V��?��u P��{�-K=�&7�p�Li+�掸�@Ow��;��'�Z�j�C�>e�ݤrޅ<��@�p��h�I%k8F�4��1� C�8Uj�.�0-m���%�v{�4_�t0��7�+KK���@�c6�Ă�9k���j��{��v&��=2L��Ǔ��D4_3��I�'}��,�^N%	�#�&G�����@���(�mU֭;�KI�1�ϱ���b^2���Iq���Y!�`P�_P��Eg�����Y�u��,�)FBk����7Zm�3n�b	��b#T6)���a˲ܘ��Xǭ�|��ql���%���S����W�8��0�g2;���^F�&5K_�6l�D!m�����iSݰ�-㘎��)��]#� ��>�&h�7�1�%�hĚ�E���.�4�r,�6*q��>��l$��2�E�T�P"	Ƴ@a��w������$�>�Q�p��쁛v�D��=�H�Zgx��O�2|O����l%���y�6{鳿�hni�Z�&]��[�ͷ+���FZ혤�z��Y�\�ȕ�����®Oa!(�OP�ƲI����躱njm�#ZȦ$��%�2Į��>��ߤ����Cez�׽ȹn!���ϏX�)ƗSob~��9N�Z�O\1A(H14��t��^W��<���5)٦��M�m�1Usͯ�	�F�l��H�VR���)�����;�%��n�$����Z��L���=<�"P.�j�������$�m�aAEO�� �Z�ف:�V�����u���0����N����>���"�)�=*���l��2�s��m*��m�7��M�C�Eכ�֤��(���SU��R�� ����-Ab���	�4=�zӵ�B��}�m�E֧����֠u6i&-�
*E'%	�,jyL��>��v�rգ;�d��1@i��ż�ڡ(s�B��#g�R�c�DM���0����g�	�YT��������0���<��P�P�*M�@�(�}&�<x�P~B���}�~��.��HJ»U|�daXr���
��DN��ړ:�����6�hS�ImD_��9\{����q�­��QC�ږ�Sд&9�Rt0��c^Q��C�>��}�����;���e_�޴�]-I���Se�R�8���(��l�YNu
�O��O�8{�B�g�D��T5�3]�تpm?u�+�>IlH�PFQG)�S2,�$���N7GjL'������5��՛5�/�Y��r
�CB
iA!Gŧ�N���d
����b�\�1���J\�հ��ȹ#���L�=�T2� ����T��i�>'#(o�I��݇�fJ���c5�[��Ez
T1{|뤡.6@7�_[a#�-�ɵZ{��M����m��`x�dbgU����q���sqz��t�?��I#g�}'�;p�Ӄ*DtB�����	K�����pZ��e��IP�ѥ\������ϟ�+�2w      �      x������ � �      �      x������ � �      �      x������ � �     