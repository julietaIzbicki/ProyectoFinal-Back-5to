PGDMP  9    &    
            |            BDServiFind    16.2    16.0 8    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16442    BDServiFind    DATABASE     �   CREATE DATABASE "BDServiFind" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Argentina.1252';
    DROP DATABASE "BDServiFind";
                postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                pg_database_owner    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                   pg_database_owner    false    4            �            1255    16511    SP_Calificacion() 	   PROCEDURE     �  CREATE PROCEDURE public."SP_Calificacion"()
    LANGUAGE sql
    AS $$SELECT 
	"Usuarios"."nombre", 
	"Usuarios"."apellido", 
	"Historial"."idContratador", 
	"Usuarios"."id", 
	avg("Historial"."calificacion") 
FROM public."Historial" 
INNER JOIN  public."Usuarios" ON public."Usuarios"."id" = public."Historial"."idContratador"
GROUP BY 
	"Historial"."idContratador",
	"Usuarios"."id", 
	"Usuarios"."nombre", 
	"Usuarios"."apellido"
ORDER BY 
	"Historial"."idContratador" ASC 
$$;
 +   DROP PROCEDURE public."SP_Calificacion"();
       public          postgres    false    4            �            1259    16495 
   Categorias    TABLE     a   CREATE TABLE public."Categorias" (
    id integer NOT NULL,
    nombre character varying(150)
);
     DROP TABLE public."Categorias";
       public         heap    postgres    false    4            �            1259    16494    Categorias_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Categorias_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public."Categorias_id_seq";
       public          postgres    false    226    4            �           0    0    Categorias_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public."Categorias_id_seq" OWNED BY public."Categorias".id;
          public          postgres    false    225            �            1259    16505 	   Historial    TABLE     �   CREATE TABLE public."Historial" (
    id integer NOT NULL,
    "idProveedor" integer NOT NULL,
    "idContratador" integer,
    fecha date,
    realizado boolean,
    calificacion integer,
    resena character varying(150)
);
    DROP TABLE public."Historial";
       public         heap    postgres    false    4            �            1259    16504    Historial_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Historial_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public."Historial_id_seq";
       public          postgres    false    228    4            �           0    0    Historial_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public."Historial_id_seq" OWNED BY public."Historial".id;
          public          postgres    false    227            �            1259    16488 	   Ofrecidos    TABLE     �   CREATE TABLE public."Ofrecidos" (
    id integer NOT NULL,
    idusuario integer,
    descripcion character varying(1000),
    idcategoria integer
);
    DROP TABLE public."Ofrecidos";
       public         heap    postgres    false    4            �            1259    16487    Ofrecidos_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Ofrecidos_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public."Ofrecidos_id_seq";
       public          postgres    false    224    4            �           0    0    Ofrecidos_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public."Ofrecidos_id_seq" OWNED BY public."Ofrecidos".id;
          public          postgres    false    223            �            1259    16449    Usuarios    TABLE       CREATE TABLE public."Usuarios" (
    id integer NOT NULL,
    email character varying(50) NOT NULL,
    nombre character varying(30) NOT NULL,
    apellido character varying(30) NOT NULL,
    direccion character varying(50),
    contrasena character varying(15) NOT NULL
);
    DROP TABLE public."Usuarios";
       public         heap    postgres    false    4            �            1259    16454    Usuarios_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Usuarios_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public."Usuarios_id_seq";
       public          postgres    false    215    4            �           0    0    Usuarios_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public."Usuarios_id_seq" OWNED BY public."Usuarios".id;
          public          postgres    false    216            �            1259    16455    ZonaOfrecidos     TABLE     �   CREATE TABLE public."ZonaOfrecidos " (
    id integer NOT NULL,
    "idUsuario" integer NOT NULL,
    "idZona" integer NOT NULL
);
 $   DROP TABLE public."ZonaOfrecidos ";
       public         heap    postgres    false    4            �            1259    16458    ZonaTrabajador_idTrabajador_seq    SEQUENCE     �   CREATE SEQUENCE public."ZonaTrabajador_idTrabajador_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public."ZonaTrabajador_idTrabajador_seq";
       public          postgres    false    4    217            �           0    0    ZonaTrabajador_idTrabajador_seq    SEQUENCE OWNED BY     f   ALTER SEQUENCE public."ZonaTrabajador_idTrabajador_seq" OWNED BY public."ZonaOfrecidos "."idUsuario";
          public          postgres    false    218            �            1259    16459    ZonaTrabajador_idZona_seq    SEQUENCE     �   CREATE SEQUENCE public."ZonaTrabajador_idZona_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public."ZonaTrabajador_idZona_seq";
       public          postgres    false    217    4            �           0    0    ZonaTrabajador_idZona_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."ZonaTrabajador_idZona_seq" OWNED BY public."ZonaOfrecidos "."idZona";
          public          postgres    false    219            �            1259    16460    ZonaTrabajador_id_seq    SEQUENCE     �   CREATE SEQUENCE public."ZonaTrabajador_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."ZonaTrabajador_id_seq";
       public          postgres    false    217    4            �           0    0    ZonaTrabajador_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."ZonaTrabajador_id_seq" OWNED BY public."ZonaOfrecidos ".id;
          public          postgres    false    220            �            1259    16461    Zonas    TABLE     d   CREATE TABLE public."Zonas" (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL
);
    DROP TABLE public."Zonas";
       public         heap    postgres    false    4            �            1259    16464    Zonas_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Zonas_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public."Zonas_id_seq";
       public          postgres    false    4    221            �           0    0    Zonas_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public."Zonas_id_seq" OWNED BY public."Zonas".id;
          public          postgres    false    222            <           2604    16498    Categorias id    DEFAULT     r   ALTER TABLE ONLY public."Categorias" ALTER COLUMN id SET DEFAULT nextval('public."Categorias_id_seq"'::regclass);
 >   ALTER TABLE public."Categorias" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    225    226    226            =           2604    16508    Historial id    DEFAULT     p   ALTER TABLE ONLY public."Historial" ALTER COLUMN id SET DEFAULT nextval('public."Historial_id_seq"'::regclass);
 =   ALTER TABLE public."Historial" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    228    228            ;           2604    16491    Ofrecidos id    DEFAULT     p   ALTER TABLE ONLY public."Ofrecidos" ALTER COLUMN id SET DEFAULT nextval('public."Ofrecidos_id_seq"'::regclass);
 =   ALTER TABLE public."Ofrecidos" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    223    224            6           2604    16466    Usuarios id    DEFAULT     n   ALTER TABLE ONLY public."Usuarios" ALTER COLUMN id SET DEFAULT nextval('public."Usuarios_id_seq"'::regclass);
 <   ALTER TABLE public."Usuarios" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215            7           2604    16467    ZonaOfrecidos  id    DEFAULT     z   ALTER TABLE ONLY public."ZonaOfrecidos " ALTER COLUMN id SET DEFAULT nextval('public."ZonaTrabajador_id_seq"'::regclass);
 B   ALTER TABLE public."ZonaOfrecidos " ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    217            8           2604    16468    ZonaOfrecidos  idUsuario    DEFAULT     �   ALTER TABLE ONLY public."ZonaOfrecidos " ALTER COLUMN "idUsuario" SET DEFAULT nextval('public."ZonaTrabajador_idTrabajador_seq"'::regclass);
 K   ALTER TABLE public."ZonaOfrecidos " ALTER COLUMN "idUsuario" DROP DEFAULT;
       public          postgres    false    218    217            9           2604    16469    ZonaOfrecidos  idZona    DEFAULT     �   ALTER TABLE ONLY public."ZonaOfrecidos " ALTER COLUMN "idZona" SET DEFAULT nextval('public."ZonaTrabajador_idZona_seq"'::regclass);
 H   ALTER TABLE public."ZonaOfrecidos " ALTER COLUMN "idZona" DROP DEFAULT;
       public          postgres    false    219    217            :           2604    16470    Zonas id    DEFAULT     h   ALTER TABLE ONLY public."Zonas" ALTER COLUMN id SET DEFAULT nextval('public."Zonas_id_seq"'::regclass);
 9   ALTER TABLE public."Zonas" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    221            �          0    16495 
   Categorias 
   TABLE DATA                 public          postgres    false    226   �<       �          0    16505 	   Historial 
   TABLE DATA                 public          postgres    false    228   {=       �          0    16488 	   Ofrecidos 
   TABLE DATA                 public          postgres    false    224   �?       �          0    16449    Usuarios 
   TABLE DATA                 public          postgres    false    215   �A       �          0    16455    ZonaOfrecidos  
   TABLE DATA                 public          postgres    false    217   D       �          0    16461    Zonas 
   TABLE DATA                 public          postgres    false    221   �D       �           0    0    Categorias_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public."Categorias_id_seq"', 4, true);
          public          postgres    false    225            �           0    0    Historial_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public."Historial_id_seq"', 15, true);
          public          postgres    false    227            �           0    0    Ofrecidos_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public."Ofrecidos_id_seq"', 11, true);
          public          postgres    false    223            �           0    0    Usuarios_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."Usuarios_id_seq"', 15, true);
          public          postgres    false    216            �           0    0    ZonaTrabajador_idTrabajador_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public."ZonaTrabajador_idTrabajador_seq"', 1, false);
          public          postgres    false    218            �           0    0    ZonaTrabajador_idZona_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."ZonaTrabajador_idZona_seq"', 1, false);
          public          postgres    false    219            �           0    0    ZonaTrabajador_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."ZonaTrabajador_id_seq"', 12, true);
          public          postgres    false    220            �           0    0    Zonas_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public."Zonas_id_seq"', 31, true);
          public          postgres    false    222            C           2606    16510    Historial Historial_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public."Historial"
    ADD CONSTRAINT "Historial_pkey" PRIMARY KEY ("idProveedor");
 F   ALTER TABLE ONLY public."Historial" DROP CONSTRAINT "Historial_pkey";
       public            postgres    false    228            ?           2606    16474    Usuarios Usuarios_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public."Usuarios"
    ADD CONSTRAINT "Usuarios_pkey" PRIMARY KEY (id);
 D   ALTER TABLE ONLY public."Usuarios" DROP CONSTRAINT "Usuarios_pkey";
       public            postgres    false    215            A           2606    16476    Zonas Zonas_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public."Zonas"
    ADD CONSTRAINT "Zonas_pkey" PRIMARY KEY (id);
 >   ALTER TABLE ONLY public."Zonas" DROP CONSTRAINT "Zonas_pkey";
       public            postgres    false    221            D           2606    16499 $   ZonaOfrecidos  idUsuarios_usuariosId    FK CONSTRAINT     �   ALTER TABLE ONLY public."ZonaOfrecidos "
    ADD CONSTRAINT "idUsuarios_usuariosId" FOREIGN KEY ("idUsuario") REFERENCES public."Usuarios"(id) NOT VALID;
 R   ALTER TABLE ONLY public."ZonaOfrecidos " DROP CONSTRAINT "idUsuarios_usuariosId";
       public          postgres    false    4671    217    215            E           2606    16482    ZonaOfrecidos  idZonas_zonasId    FK CONSTRAINT     �   ALTER TABLE ONLY public."ZonaOfrecidos "
    ADD CONSTRAINT "idZonas_zonasId" FOREIGN KEY ("idZona") REFERENCES public."Zonas"(id) NOT VALID;
 L   ALTER TABLE ONLY public."ZonaOfrecidos " DROP CONSTRAINT "idZonas_zonasId";
       public          postgres    false    4673    217    221            �   �   x���M
�0@�}N1tS�ٹ��E@Zh��i2H`hB�,��x{���tg�aݍ=�<�����=C�(<��{k`s�Am���&b�7�ۋ��c�ELh}�I��S�M�] G)I�qU��M0�@Y�63�߃R�O2      �   t  x��U�n�@��7J �0e��J 1�8@�_W�	�;���9)S�r��?���� .��ٝ�ݫ��ŗ;����L]Z��?���l���믋[zSW�gZ�dz2��̏��IE�'�h���^��Z�A�M?ɋ�#z<y����uX�t�k��5#qǞ��-5bh���я$M�H�����������=F��ĒJ����ZM�L(���s�>M��cPg%����)�AB��(m�+j��*�w������Q��U��|?���nCi�k\�� �(�ϝO�:�Op+<�#	�������'Ժ�:�[�t�2���f���;���^������vmЈ���b!=�P�GU|YP�J������fH��NL��=<Gٛ�1����&.
J��#V�E^���*�l�g�)�Y'�r�"������0`��B�;��/�J��+Vc	t�����&t-IF�λ����w@�%�	^j���:�g��-P���-RG4$�D�p�i�
ޓn�I]>	�2�&1���ʷb�X�;F�+Q��Vy���Yi���r[�	���Ѱ�SkX���OD�n�LK����3g{
��l8m�yqɀL�A����f�:�d�����I=8�ޕd�      �   �  x����n�0�w?�!�Z�(��MRd
�����g�$�A�ʑ��t�С�#��z��d�b�(�������au��������ql��<6B��O������
>��Wm�%H�܅59�IXoc]8�|=[�x6*~ǈ;!�;�CA@�FQy����U|~������OT�,�}�n���-F _ ���i�/(����v(��-��f��c��e𤔺��
9?����@F�%��6;��c�}�S�0��iP���.D���(\����\��|
�h��F��.ȓ%��1�i�\��X͸GA�Ӯ�TxmgZ�i�\PHu9&*��5R�mt$1x��lC��b��K<��o��;R�[��C�ߍ�Lka~j@ū�AGv�#�_2�n�{
�⟗�|���Dv�}e�� аK�B�����C`Z�      �   @  x��UMo�@��+�\�JՊ��hKESI���]g�IÿɱU~��XgS�8��۬ߎ޼�����b<��&7�?�(Y����]��U&��~�w��������7h"����a���\�lz ���3�wR� �v������؀��?�&�h[��Eb�*]��vpV�6=�#�a��*���?�Fo-�2����|m���0)�0�N������u!J����h�*��p�d`��A��"�A铻����d�N3,}�.Oܥ�ĂXK�AE�)�|����v�=>�?H�},Oۣk��dD���9?b��hgj��z�b[��O9�Y���r�¬2S��@��0�wv�F(1P24"�+xI>b��/ge[<M�v#�L�.�٨gN^�5��ɟ�&{j4K�d��D�TW�o�f�J���9�����ը��]���&*�YT���)cn�΋n:Na'+���;%���-���0���kl�_��
���$J^U�*p�q����}z?��z�
|nK���?�C���lI�O���p]������[�
7��;��3����0�"O��^g����.h      �   f   x���v
Q���W((M��L�S���K�O+JM�L�/VPRs�	uV�0�Q0�Q0Դ��$A�������RG��H�eh �fB�6C�6R}fh�m\\ ��]=      �   �  x����N�@��<ņ�c�w<�!�H�����N�&K�[��D�7�s����~�O��ۙ��x�&��ڗ�����͡���`�/�Up�`v��m\��&!s0H;)�d"��t DZ��d�4���r�D#������&�����K$gU)�[�17�����3��ƀ{)��,n;Ӽ�BJy�2!�W�Zꣴ��1"H@<�WbV~�}�Qʜ���$��S���xY�7��X�7�;�$n�h�Ul�D�ֿ�sp�m����#w�WU-)u���O�e&�a���ɽa���̥x�W����+���k��
;�����1��*�	s$0*Ҏ�%�*<F0R�rcbɶD#��^�5R�7M�|�k�ܱ�P��Vj�����     