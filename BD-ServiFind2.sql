--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.0

-- Started on 2024-11-01 12:14:33

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--



ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 4902 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 251 (class 1255 OID 16525)
-- Name: ActualizarResena(integer, text, text); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public."ActualizarResena"(IN p_id integer, IN p_comentario text, IN p_tipo_resena text, OUT resultado integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF p_tipo_resena = 'proveedor' THEN
        UPDATE public."Historial"
        SET "resenaProveedor" = p_comentario
        WHERE "id" = p_id;
    ELSIF p_tipo_resena = 'contratador' THEN
        UPDATE public."Historial"
        SET "resenaContratador" = p_comentario
        WHERE "id" = p_id;
    ELSE
        resultado := -1; 
    END IF;
    IF NOT FOUND THEN
        resultado := -2; 
    ELSE
        resultado := 1;
    END IF;
END;
$$;


ALTER PROCEDURE public."ActualizarResena"(IN p_id integer, IN p_comentario text, IN p_tipo_resena text, OUT resultado integer) OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 16523)
-- Name: likear(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.likear(IN idusuario integer, IN idofrecido integer, OUT resultado integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM public."Favoritos" 
        WHERE "idUsuario" = idUsuario AND "idOfrecido" = idOfrecido
    ) THEN
        DELETE FROM public."Favoritos" 
        WHERE "idUsuario" = idUsuario AND "idOfrecido" = idOfrecido;
        
        resultado := -1; -- Indicar que se eliminó el registro existente

    ELSE
        INSERT INTO public."Favoritos"("idUsuario", "idOfrecido")
        VALUES (idUsuario, idOfrecido);

        resultado := 1; -- Indicar que se insertó un nuevo registro
    END IF;
END;
$$;


ALTER PROCEDURE public.likear(IN idusuario integer, IN idofrecido integer, OUT resultado integer) OWNER TO postgres;

--
-- TOC entry 250 (class 1255 OID 16524)
-- Name: registrarse(character varying, character varying, character varying, character varying, character varying, integer, character varying, date); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.registrarse(IN p_email character varying, IN p_nombre character varying, IN p_apellido character varying, IN p_direccion character varying, IN p_contrasena character varying, IN p_idgenero integer, IN p_foto character varying, IN p_fechanacimiento date, OUT p_resultado integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM public."Usuarios" 
        WHERE "email" = p_email
    ) THEN
        p_resultado := -1; -- Indicar que ya existe
    ELSE
        INSERT INTO public."Usuarios"(
            email, 
            nombre, 
            apellido, 
            direccion, 
            contrasena, 
            "idGenero", 
            foto, 
            "FechaNacimiento"
        ) VALUES (
            p_email,
            p_nombre,
            p_apellido,
            p_direccion,
            p_contrasena,
            p_idGenero,
            p_foto,
            p_fechaNacimiento
        );

        p_resultado := 1; -- Indicar que se insertó un nuevo registro
    END IF;
END;
$$;


ALTER PROCEDURE public.registrarse(IN p_email character varying, IN p_nombre character varying, IN p_apellido character varying, IN p_direccion character varying, IN p_contrasena character varying, IN p_idgenero integer, IN p_foto character varying, IN p_fechanacimiento date, OUT p_resultado integer) OWNER TO postgres;

--
-- TOC entry 252 (class 1255 OID 16528)
-- Name: reserva(integer, integer, integer, date, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.reserva(IN idpublicacion integer, IN idoffer integer, IN idcontratador integer, IN fechareservada date, IN idestado integer, OUT resultado integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Variable para verificar si ya existe una reserva
    existing_reservation integer;
BEGIN
    -- Verificar si ya existe una reserva con los mismos parámetros
    SELECT id INTO existing_reservation
    FROM reservas
    WHERE idpublicacion = idpublicacion
      AND idoffer = idoffer
      AND idcontratador = idcontratador
      AND fechareservada = fechareservada;

    IF existing_reservation IS NOT NULL THEN
        -- Si existe, actualizar el estado de la reserva
        UPDATE reservas
        SET idestado = idestado
        WHERE id = existing_reservation;

        -- Devolver 1 para indicar que se actualizó una reserva existente
        resultado := 1;
    ELSE
        -- Si no existe, crear una nueva reserva
        INSERT INTO reservas (idpublicacion, idoffer, idcontratador, fechareservada, idestado)
        VALUES (idpublicacion, idoffer, idcontratador, fechareservada, idestado);

        -- Devolver 2 para indicar que se creó una nueva reserva
        resultado := 2;
    END IF;
    
    -- Manejo de errores y finalización
    EXCEPTION
        WHEN others THEN
            -- Si ocurre un error, devolver -1 y realizar un rollback de la transacción
            resultado := -1;
            RAISE EXCEPTION 'Error al ejecutar el procedimiento Reserva: %', SQLERRM;
END;
$$;


ALTER PROCEDURE public.reserva(IN idpublicacion integer, IN idoffer integer, IN idcontratador integer, IN fechareservada date, IN idestado integer, OUT resultado integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 16399)
-- Name: Categorias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Categorias" (
    id integer NOT NULL,
    nombre character varying(150),
    "imageURL" character varying(1000)
);


ALTER TABLE public."Categorias" OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16404)
-- Name: Categorias_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Categorias_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Categorias_id_seq" OWNER TO postgres;

--
-- TOC entry 4903 (class 0 OID 0)
-- Dependencies: 216
-- Name: Categorias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Categorias_id_seq" OWNED BY public."Categorias".id;


--
-- TOC entry 217 (class 1259 OID 16405)
-- Name: Estados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Estados" (
    id integer NOT NULL,
    nombre character varying(100)
);


ALTER TABLE public."Estados" OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16408)
-- Name: Estados_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Estados_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Estados_id_seq" OWNER TO postgres;

--
-- TOC entry 4904 (class 0 OID 0)
-- Dependencies: 218
-- Name: Estados_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Estados_id_seq" OWNED BY public."Estados".id;


--
-- TOC entry 219 (class 1259 OID 16409)
-- Name: Favoritos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Favoritos" (
    id integer NOT NULL,
    "idUsuario" integer NOT NULL,
    "idOfrecido" integer NOT NULL
);


ALTER TABLE public."Favoritos" OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16412)
-- Name: Favoritos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Favoritos_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Favoritos_id_seq" OWNER TO postgres;

--
-- TOC entry 4905 (class 0 OID 0)
-- Dependencies: 220
-- Name: Favoritos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Favoritos_id_seq" OWNED BY public."Favoritos".id;


--
-- TOC entry 221 (class 1259 OID 16413)
-- Name: FotosOfrecidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."FotosOfrecidos" (
    id integer NOT NULL,
    "idOfrecido" integer NOT NULL,
    foto character varying(250)
);


ALTER TABLE public."FotosOfrecidos" OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16416)
-- Name: FotosOfrecidos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."FotosOfrecidos_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."FotosOfrecidos_id_seq" OWNER TO postgres;

--
-- TOC entry 4906 (class 0 OID 0)
-- Dependencies: 222
-- Name: FotosOfrecidos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."FotosOfrecidos_id_seq" OWNED BY public."FotosOfrecidos".id;


--
-- TOC entry 223 (class 1259 OID 16417)
-- Name: Generos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Generos" (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL
);


ALTER TABLE public."Generos" OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16420)
-- Name: Generos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Generos_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Generos_id_seq" OWNER TO postgres;

--
-- TOC entry 4907 (class 0 OID 0)
-- Dependencies: 224
-- Name: Generos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Generos_id_seq" OWNED BY public."Generos".id;


--
-- TOC entry 225 (class 1259 OID 16421)
-- Name: Historial; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Historial" (
    id integer NOT NULL,
    "idOffer" integer NOT NULL,
    "idContratador" integer,
    "fechaReservada" date,
    "calificacionProveedor" integer,
    "resenaProveedor" character varying(150),
    "calificacionContratador" integer,
    "resenaContratador" character varying(150),
    "idEstado" integer,
    "fechaCambioEstado" date
);


ALTER TABLE public."Historial" OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16424)
-- Name: Historial_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Historial_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Historial_id_seq" OWNER TO postgres;

--
-- TOC entry 4908 (class 0 OID 0)
-- Dependencies: 226
-- Name: Historial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Historial_id_seq" OWNED BY public."Historial".id;


--
-- TOC entry 227 (class 1259 OID 16425)
-- Name: Ofrecidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Ofrecidos" (
    id integer NOT NULL,
    "idProveedor" integer,
    descripcion character varying(1000),
    idcategoria integer,
    tags character varying(250),
    precio integer,
    titulo character varying(20)
);


ALTER TABLE public."Ofrecidos" OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16430)
-- Name: Ofrecidos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Ofrecidos_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Ofrecidos_id_seq" OWNER TO postgres;

--
-- TOC entry 4909 (class 0 OID 0)
-- Dependencies: 228
-- Name: Ofrecidos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Ofrecidos_id_seq" OWNED BY public."Ofrecidos".id;


--
-- TOC entry 229 (class 1259 OID 16431)
-- Name: Usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Usuarios" (
    id integer NOT NULL,
    email character varying(50) NOT NULL,
    nombre character varying(30) NOT NULL,
    apellido character varying(30) NOT NULL,
    direccion character varying(50),
    contrasena character varying(15) NOT NULL,
    "idGenero" integer,
    foto character varying(250),
    "FechaNacimiento" date
);


ALTER TABLE public."Usuarios" OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16434)
-- Name: Usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Usuarios_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Usuarios_id_seq" OWNER TO postgres;

--
-- TOC entry 4910 (class 0 OID 0)
-- Dependencies: 230
-- Name: Usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Usuarios_id_seq" OWNED BY public."Usuarios".id;


--
-- TOC entry 231 (class 1259 OID 16435)
-- Name: ZonaOfrecidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ZonaOfrecidos" (
    id integer NOT NULL,
    "idUsuario" integer NOT NULL,
    "idZona" integer NOT NULL
);


ALTER TABLE public."ZonaOfrecidos" OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16438)
-- Name: ZonaTrabajador_idTrabajador_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ZonaTrabajador_idTrabajador_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ZonaTrabajador_idTrabajador_seq" OWNER TO postgres;

--
-- TOC entry 4911 (class 0 OID 0)
-- Dependencies: 232
-- Name: ZonaTrabajador_idTrabajador_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ZonaTrabajador_idTrabajador_seq" OWNED BY public."ZonaOfrecidos"."idUsuario";


--
-- TOC entry 233 (class 1259 OID 16439)
-- Name: ZonaTrabajador_idZona_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ZonaTrabajador_idZona_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ZonaTrabajador_idZona_seq" OWNER TO postgres;

--
-- TOC entry 4912 (class 0 OID 0)
-- Dependencies: 233
-- Name: ZonaTrabajador_idZona_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ZonaTrabajador_idZona_seq" OWNED BY public."ZonaOfrecidos"."idZona";


--
-- TOC entry 234 (class 1259 OID 16440)
-- Name: ZonaTrabajador_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ZonaTrabajador_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ZonaTrabajador_id_seq" OWNER TO postgres;

--
-- TOC entry 4913 (class 0 OID 0)
-- Dependencies: 234
-- Name: ZonaTrabajador_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ZonaTrabajador_id_seq" OWNED BY public."ZonaOfrecidos".id;


--
-- TOC entry 235 (class 1259 OID 16441)
-- Name: Zonas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Zonas" (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL
);


ALTER TABLE public."Zonas" OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16444)
-- Name: Zonas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Zonas_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Zonas_id_seq" OWNER TO postgres;

--
-- TOC entry 4914 (class 0 OID 0)
-- Dependencies: 236
-- Name: Zonas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Zonas_id_seq" OWNED BY public."Zonas".id;


--
-- TOC entry 237 (class 1259 OID 16445)
-- Name: passwordresetcodes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.passwordresetcodes (
    email character varying(255) NOT NULL,
    code character varying(6) NOT NULL,
    expiration timestamp without time zone NOT NULL
);


ALTER TABLE public.passwordresetcodes OWNER TO postgres;

--
-- TOC entry 4689 (class 2604 OID 16448)
-- Name: Categorias id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Categorias" ALTER COLUMN id SET DEFAULT nextval('public."Categorias_id_seq"'::regclass);


--
-- TOC entry 4690 (class 2604 OID 16449)
-- Name: Estados id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estados" ALTER COLUMN id SET DEFAULT nextval('public."Estados_id_seq"'::regclass);


--
-- TOC entry 4691 (class 2604 OID 16450)
-- Name: Favoritos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Favoritos" ALTER COLUMN id SET DEFAULT nextval('public."Favoritos_id_seq"'::regclass);


--
-- TOC entry 4692 (class 2604 OID 16451)
-- Name: FotosOfrecidos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FotosOfrecidos" ALTER COLUMN id SET DEFAULT nextval('public."FotosOfrecidos_id_seq"'::regclass);


--
-- TOC entry 4693 (class 2604 OID 16452)
-- Name: Generos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Generos" ALTER COLUMN id SET DEFAULT nextval('public."Generos_id_seq"'::regclass);


--
-- TOC entry 4694 (class 2604 OID 16453)
-- Name: Historial id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Historial" ALTER COLUMN id SET DEFAULT nextval('public."Historial_id_seq"'::regclass);


--
-- TOC entry 4695 (class 2604 OID 16454)
-- Name: Ofrecidos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ofrecidos" ALTER COLUMN id SET DEFAULT nextval('public."Ofrecidos_id_seq"'::regclass);


--
-- TOC entry 4696 (class 2604 OID 16455)
-- Name: Usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuarios" ALTER COLUMN id SET DEFAULT nextval('public."Usuarios_id_seq"'::regclass);


--
-- TOC entry 4697 (class 2604 OID 16456)
-- Name: ZonaOfrecidos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ZonaOfrecidos" ALTER COLUMN id SET DEFAULT nextval('public."ZonaTrabajador_id_seq"'::regclass);


--
-- TOC entry 4698 (class 2604 OID 16457)
-- Name: ZonaOfrecidos idUsuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ZonaOfrecidos" ALTER COLUMN "idUsuario" SET DEFAULT nextval('public."ZonaTrabajador_idTrabajador_seq"'::regclass);


--
-- TOC entry 4699 (class 2604 OID 16458)
-- Name: ZonaOfrecidos idZona; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ZonaOfrecidos" ALTER COLUMN "idZona" SET DEFAULT nextval('public."ZonaTrabajador_idZona_seq"'::regclass);


--
-- TOC entry 4700 (class 2604 OID 16459)
-- Name: Zonas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Zonas" ALTER COLUMN id SET DEFAULT nextval('public."Zonas_id_seq"'::regclass);


--
-- TOC entry 4874 (class 0 OID 16399)
-- Dependencies: 215
-- Data for Name: Categorias; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Categorias" VALUES (1, 'Belleza', '/assets/belleza.png');
INSERT INTO public."Categorias" VALUES (45, 'Salud', '/assets/salud.png');
INSERT INTO public."Categorias" VALUES (46, 'Veterinaria', '/assets/animal.png');
INSERT INTO public."Categorias" VALUES (3, 'Cuidado', '/assets/persona.png');
INSERT INTO public."Categorias" VALUES (4, 'Clases
', '/assets/particular.png');
INSERT INTO public."Categorias" VALUES (5, 'Limpieza', '/assets/limpieza.png');
INSERT INTO public."Categorias" VALUES (6, 'Arte', '/assets/arte.png');
INSERT INTO public."Categorias" VALUES (9, 'Catering', '/assets/catering.png');
INSERT INTO public."Categorias" VALUES (12, 'Jardinería', '/assets/jardineria.png');
INSERT INTO public."Categorias" VALUES (13, 'Fotografía
', '/assets/foto.png');
INSERT INTO public."Categorias" VALUES (23, 'Transporte', '/assets/vehiculo.png');
INSERT INTO public."Categorias" VALUES (2, 'Arreglos', '/assets/arreglos.png');


--
-- TOC entry 4876 (class 0 OID 16405)
-- Dependencies: 217
-- Data for Name: Estados; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Estados" VALUES (1, 'Pendiente');
INSERT INTO public."Estados" VALUES (2, 'Aceptado');
INSERT INTO public."Estados" VALUES (3, 'Rechazado');
INSERT INTO public."Estados" VALUES (4, 'Cancelado');
INSERT INTO public."Estados" VALUES (5, 'realizado');


--
-- TOC entry 4878 (class 0 OID 16409)
-- Dependencies: 219
-- Data for Name: Favoritos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Favoritos" VALUES (18, 41, 6);
INSERT INTO public."Favoritos" VALUES (19, 5, 5);
INSERT INTO public."Favoritos" VALUES (20, 4, 4);
INSERT INTO public."Favoritos" VALUES (21, 3, 3);
INSERT INTO public."Favoritos" VALUES (22, 2, 2);
INSERT INTO public."Favoritos" VALUES (23, 1, 1);


--
-- TOC entry 4880 (class 0 OID 16413)
-- Dependencies: 221
-- Data for Name: FotosOfrecidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."FotosOfrecidos" VALUES (93, 25, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTId2MS7lL6F1n2s7xoGPAprM0Z_Qyp_y7Wbp3muu2HaPKMRikH2D840d3Ft3sgDIURnck&usqp=CAU');
INSERT INTO public."FotosOfrecidos" VALUES (94, 25, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQkN3UIuj9Q1fYG9DwMZhLwf5tEGiRsYt76A&s');
INSERT INTO public."FotosOfrecidos" VALUES (95, 30, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpMGRl_ENVAh4KxWalXqacW-UzXS5XJeInSw&s');
INSERT INTO public."FotosOfrecidos" VALUES (96, 30, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRieNisuymN5QgH2hwwUtptpxhKJ2wdNQZN9gk4PcLyGdLLkSJIpPWKQxAlVcXTz8f7ALw&usqp=CAU');
INSERT INTO public."FotosOfrecidos" VALUES (97, 30, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTFGo5pZHnFOLNm3ibYtFv36Tl5THtTIOmb9NVfUwitflfoK-HcBILVCetPGRSCEyGqQE&usqp=CAU');
INSERT INTO public."FotosOfrecidos" VALUES (98, 30, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQcVuuIz01npmEoL_KRTBaD6ad4ZZjl0B-4Q&s');
INSERT INTO public."FotosOfrecidos" VALUES (99, 30, 'https://www.onlinepersonaltrainer.es/wp-content/uploads/2020/02/entrenadores-personales-a-domicilio-2.jpg');
INSERT INTO public."FotosOfrecidos" VALUES (100, 31, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjXDlXqZzjKed4jwRc-Tfv6MTz3CCoAmAzUA&s');
INSERT INTO public."FotosOfrecidos" VALUES (101, 31, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHV7LI-kUJnxbGujV6iYSMbzG405RBMXZfNQKAGGu3kBR95xdyNQT1zkgqplGHEy65niU&usqp=CAU');
INSERT INTO public."FotosOfrecidos" VALUES (102, 31, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTr7wf_yrpwfHM2K23PkUMiWHkwAUXmfCIUd3asFhmG207wjJaDCfl06aWt6RNl65BD128&usqp=CAU');
INSERT INTO public."FotosOfrecidos" VALUES (103, 34, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfQMgyK7WnHl_mriHBHiza7LQBdOqML3UcpA&s');
INSERT INTO public."FotosOfrecidos" VALUES (104, 34, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJ_NsJGIgoGAvexbksN5QixG0jvfTt6RNcsA&s');
INSERT INTO public."FotosOfrecidos" VALUES (105, 36, 'https://aprende.com/wp-content/uploads/2023/06/sistemas-de-camaras-de-seguridad.webp');
INSERT INTO public."FotosOfrecidos" VALUES (106, 36, 'https://blog.zequer.com/wp-content/uploads/2018/01/Como-instalar-una-alarma-en-casa-sin-pagar-cuotas-MediaTrends-e1516825409899.jpg');
INSERT INTO public."FotosOfrecidos" VALUES (107, 36, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDS6Czk5uQPQ-xLoCiTxF1TEZkJctsRpLRNw&s');
INSERT INTO public."FotosOfrecidos" VALUES (108, 39, 'https://cdecora.com.pe/wp-content/uploads/2022/03/remodelacion-de-interiores.jpg');
INSERT INTO public."FotosOfrecidos" VALUES (109, 39, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtsWpqzyut7rwoZmY9HLfuDnmbIKtI-R62rg&s');
INSERT INTO public."FotosOfrecidos" VALUES (110, 39, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQdDWx6puQl7OL4aejT6hA6aU-r0pLiar1gg&s');
INSERT INTO public."FotosOfrecidos" VALUES (111, 41, 'https://xuanlanyoga.com/wp-content/uploads/2020/04/meditacion-en-casa-meditar-altar.jpeg');
INSERT INTO public."FotosOfrecidos" VALUES (112, 41, 'https://pymstatic.com/7775/conversions/ejercicios-meditacion-wide_webp.webp');
INSERT INTO public."FotosOfrecidos" VALUES (113, 41, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_c2clvT3GJ4S-7dnZKmpli6bj7BiU2ve1Dw&s');
INSERT INTO public."FotosOfrecidos" VALUES (63, 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4s_-KLXK_hpAbwSs2XXex2u8EFzeSMGWizg&s');
INSERT INTO public."FotosOfrecidos" VALUES (64, 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtjavkCDs4qeiNtGaDCemWzM4dQmCLB1wTkA&s');
INSERT INTO public."FotosOfrecidos" VALUES (65, 2, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRk5FHNYj7VyhnX1b66M_WjY0H2bb9Hvkd9pg&s');
INSERT INTO public."FotosOfrecidos" VALUES (66, 2, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXrV3D3izKTT0t_tZU2Pf6idZjT0M_6A9fFg&s');
INSERT INTO public."FotosOfrecidos" VALUES (67, 2, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYeFxL-Pae9LX4d7Q3zl7p9vqbwt-NYAhu9v-SNVDVDXvAOAdfYb1Bl2K34Q4hw1H1bSU&usqp=CAU');
INSERT INTO public."FotosOfrecidos" VALUES (68, 2, 'https://img.freepik.com/fotos-premium/masaje-fresas-espalda-mujer-aromaterapia-frutos-rojos_157823-1883.jpg');
INSERT INTO public."FotosOfrecidos" VALUES (69, 3, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQd-reb0nS775oEGaK2TvJOcA1ATBPsx0-fA&s');
INSERT INTO public."FotosOfrecidos" VALUES (70, 3, 'https://irp.cdn-website.com/a2654150/MOBILE/jpg/1885.jpg');
INSERT INTO public."FotosOfrecidos" VALUES (71, 3, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQo7KCURyxUTvV7iymbT7XIY6JC47t76_rHsw&s');
INSERT INTO public."FotosOfrecidos" VALUES (72, 4, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWXgqfiX8n-ORlb6aYjl_qw4S2Zhmt4Pr6gg&s');
INSERT INTO public."FotosOfrecidos" VALUES (73, 4, 'https://media.ambito.com/p/36e6226a5e41468611bef7e6dedc49af/adjuntos/239/imagenes/041/081/0041081792/375x211/smart/cuidador_de_personas_mayores-pamijpg.jpg');
INSERT INTO public."FotosOfrecidos" VALUES (74, 5, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiElwBO_xXbKu_0lm8EoGZ4gqjiosn3yCnYA&s');
INSERT INTO public."FotosOfrecidos" VALUES (75, 6, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRkX_j8pdJhN4lJ8N__NasY5-m74hrVprZ6CQ&s');
INSERT INTO public."FotosOfrecidos" VALUES (76, 6, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmbLpSCyByRwMz1yF2wqi5aR7dUhH9IKYxnsgKVvHESdd2Ic4BRh-uo29mWz2Orh8xC2k&usqp=CAU');
INSERT INTO public."FotosOfrecidos" VALUES (77, 7, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSS9F1Qx1lObzvdhgLgS3W23105YCq0-D4Lvw&s');
INSERT INTO public."FotosOfrecidos" VALUES (78, 7, 'https://www.65ymas.com/uploads/s1/31/37/19/comprabaciones-que-deberias-hacer-antes-de-llamar-al-servicio-tecnico_1_621x621.jpeg');
INSERT INTO public."FotosOfrecidos" VALUES (79, 8, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQj2z8vVlsIfppPazi7xcX3eHlhXigPrK3gwQ&s');
INSERT INTO public."FotosOfrecidos" VALUES (80, 8, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6PXtTS8t5wgb7n9qaTkdOrJM-0ZGUGn6eC_SKXEnrkGEtXsTWEHg9YwEfEYUb89dDZ7g&usqp=CAU');
INSERT INTO public."FotosOfrecidos" VALUES (81, 8, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSV4FagAYyY9gGxCzysbphwIQJ4M4Zli-w2GA&s');
INSERT INTO public."FotosOfrecidos" VALUES (82, 10, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2I44NgFn4ZtrNUQW5dlK1VkdaXIlH_7ZHfg&s');
INSERT INTO public."FotosOfrecidos" VALUES (83, 10, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDn-G5AVMfcJ7OKS_FvgqT6yv5tteqD6aiPHfJ-BusKJ8sAkAvZxYlT-rZzdiff3D9o0g&usqp=CAU');
INSERT INTO public."FotosOfrecidos" VALUES (84, 10, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGXu0NH6k7YvSYAJTT_pqIXu52XyJfIXEQvTKh_x6yhwKrSYi6QyZU6k4FCEt-jGgTQQ0&usqp=CAU');
INSERT INTO public."FotosOfrecidos" VALUES (85, 10, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRm06KvYNbA77hkO2vmJfsC-XWq5QTdA8j0yQ&s');
INSERT INTO public."FotosOfrecidos" VALUES (86, 10, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9RHRDxrj8PiKqaYFnAAmWcQ_tf0ss3C-d8vl04QUhqu_15zKAR8S9KXljY7cUqXG_k0M&usqp=CAU');
INSERT INTO public."FotosOfrecidos" VALUES (87, 11, 'https://i.ytimg.com/vi/wohCFLu4O04/hq720.jpg?sqp=-oaymwE7CK4FEIIDSFryq4qpAy0IARUAAAAAGAElAADIQj0AgKJD8AEB-AHUBoAC4AOKAgwIABABGGUgZShlMA8=&rs=AOn4CLDIYxDzbmLCuSFnxtsw0ayEmS4FZw');
INSERT INTO public."FotosOfrecidos" VALUES (88, 11, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZy1Ova7OjcCJWS1oBJMEe1VhMMsOx-iotmQ&s');
INSERT INTO public."FotosOfrecidos" VALUES (89, 23, 'https://facilitylatam.com/wp-content/uploads/2021/10/Servicio-de-Limpieza-%E2%80%93Empresa-de-Limpieza.-Buenos-Aires-%E2%80%93-Argentina.-Facility-Latam-4.jpg');
INSERT INTO public."FotosOfrecidos" VALUES (90, 23, 'https://lh3.googleusercontent.com/proxy/THpmaFAuyEuMtEt3PMGZh6Ogh7vdXUnCMsL1X9oMPwBl30xyEme-jEl1eGT6EyJD3Rh_NwH4Hv62hQT72yqDdyMCqrkYDRqP');
INSERT INTO public."FotosOfrecidos" VALUES (91, 24, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTsQeClXtEl3oA0wmpizfYBx-SXx2S8fSXd9Ahk6rUv5lrfORNpXf_pozThEg6BZMbvcMg&usqp=CAU');
INSERT INTO public."FotosOfrecidos" VALUES (92, 24, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9wp6QjF_XHrIeOuwul4DmgbRwaMjp76zs_MbYUT6qX4lLadBTyhgJNFYyXFH1JxyxXR0&usqp=CAU');


--
-- TOC entry 4882 (class 0 OID 16417)
-- Dependencies: 223
-- Data for Name: Generos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Generos" VALUES (1, 'Masculino');
INSERT INTO public."Generos" VALUES (2, 'Femenino');
INSERT INTO public."Generos" VALUES (3, 'No binario');
INSERT INTO public."Generos" VALUES (4, 'Prefiero no decir');
INSERT INTO public."Generos" VALUES (5, 'Otro');


--
-- TOC entry 4884 (class 0 OID 16421)
-- Dependencies: 225
-- Data for Name: Historial; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Historial" VALUES (4, 4, 5, '2023-01-04', 2, 'La reparación del electrodoméstico tardó un poco más de lo esperado.', 3, 'Cliente comprensivo', 3, NULL);
INSERT INTO public."Historial" VALUES (6, 3, 2, '2023-01-06', 3, 'Excelentes clases de inglés, aprendí mucho.', 2, 'Cliente insatisfecho', 3, NULL);
INSERT INTO public."Historial" VALUES (7, 2, 1, '2023-01-07', 5, 'Me encantó el servicio de peluquería en casa.', 4, 'Cliente cordial', 2, NULL);
INSERT INTO public."Historial" VALUES (10, 3, 5, '2023-01-10', 3, 'La reparación del grifo no fue del todo satisfactoria.', 2, 'Cliente insatisfecho', 3, NULL);
INSERT INTO public."Historial" VALUES (12, 2, 3, '2023-01-12', 4, 'Las clases de matemáticas fueron geniales, el profesor explicaba muy bien.', 5, 'Cliente satisfecho', 3, NULL);
INSERT INTO public."Historial" VALUES (5, 5, 3, '2023-01-05', 4, 'Muy buen servicio de asistencia domiciliaria.', 4, 'Cliente cordial', 4, NULL);
INSERT INTO public."Historial" VALUES (9, 4, 2, '2023-01-09', 4, 'El masaje fue increíble, definitivamente lo recomendaría.', 5, 'Cliente satisfecho', 4, NULL);
INSERT INTO public."Historial" VALUES (11, 5, 1, '2023-01-11', 5, 'El cuidado de mi abuela fue excelente, gracias por su atención.', 5, 'Cliente satisfecho', 4, NULL);
INSERT INTO public."Historial" VALUES (3, 3, 4, '2023-01-03', 5, 'El tratamiento facial me dejó la piel muy suave.', 5, 'Cliente satisfecho', 4, NULL);
INSERT INTO public."Historial" VALUES (8, 1, 4, '2023-01-08', 2, 'Nuevo comentario para el proveedor', 3, 'Nuevo comentario para el contratador', 3, NULL);
INSERT INTO public."Historial" VALUES (13, 1, 5, '2023-01-13', 3, 'Nuevo comentario para el proveedor', 4, 'Nuevo comentario para el contratador', 4, NULL);
INSERT INTO public."Historial" VALUES (2, 2, 3, '2023-01-02', 3, 'Las clases de matemáticas fueron muy útiles.', 4, 'Nuevo comentario para el contratador', 4, NULL);
INSERT INTO public."Historial" VALUES (1, 1, 2, '2023-01-01', 4, 'Comentario actualizado', 5, 'Nuevo comentario para el contratador', 4, NULL);
INSERT INTO public."Historial" VALUES (21, 10, 41, '2024-09-15', NULL, NULL, NULL, NULL, 1, NULL);
INSERT INTO public."Historial" VALUES (14, 3, 2, '2024-11-01', 2, 'La reparación del techo fue aceptable, pero podría mejorar en algunos detalles.', 3, 'Cliente comprensivo', 3, NULL);
INSERT INTO public."Historial" VALUES (15, 5, 1, '2024-11-04', 4, 'El cuidado de mi abuela fue excelente, gracias por su atención.', 4, 'Cliente cordial', 4, NULL);
INSERT INTO public."Historial" VALUES (19, 10, 41, '2024-11-05', NULL, NULL, NULL, NULL, 1, NULL);
INSERT INTO public."Historial" VALUES (20, 10, 41, '2024-11-07', NULL, NULL, NULL, NULL, 1, NULL);


--
-- TOC entry 4886 (class 0 OID 16425)
-- Dependencies: 227
-- Data for Name: Ofrecidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Ofrecidos" VALUES (2, 1, 'Masaje relajante para aliviar el estrés', 1, NULL, 1900, NULL);
INSERT INTO public."Ofrecidos" VALUES (4, 3, 'Cuidado de ancianos en domicilio durante el día', 3, NULL, 4000, NULL);
INSERT INTO public."Ofrecidos" VALUES (6, 5, 'Tratamiento facial para rejuvenecer la piel', 1, NULL, 6000, NULL);
INSERT INTO public."Ofrecidos" VALUES (7, 6, 'Reparación de electrodomésticos en el hogar', 2, NULL, 5000, NULL);
INSERT INTO public."Ofrecidos" VALUES (8, 7, 'Asistencia domiciliaria para personas con discapacidad', 3, NULL, 8200, NULL);
INSERT INTO public."Ofrecidos" VALUES (9, 8, 'Clases de inglés para principiantes', 4, NULL, 6500, NULL);
INSERT INTO public."Ofrecidos" VALUES (10, 9, 'Servicio de peluquería a domicilio', 1, NULL, 7800, NULL);
INSERT INTO public."Ofrecidos" VALUES (11, 10, 'Reparación de techo dañado por filtraciones', 2, NULL, 9000, NULL);
INSERT INTO public."Ofrecidos" VALUES (3, 2, 'Reparación de grifo con fugas en el baño', 2, 'agua fuga reparacion plomeria', 8000, NULL);
INSERT INTO public."Ofrecidos" VALUES (5, 4, 'Clases particulares de matemáticas para estudiantes de secundaria', 4, 'profesora profe aprender', 7000, NULL);
INSERT INTO public."Ofrecidos" VALUES (1, 1, 'hage trabajos de electricidad', 2, 'fuga de electricidad', 2500, NULL);
INSERT INTO public."Ofrecidos" VALUES (23, 1, 'Servicio de limpieza profunda para hogares y oficinas', 3, 'limpieza servicio hogar oficina', 3500, NULL);
INSERT INTO public."Ofrecidos" VALUES (24, 2, 'Clases de guitarra eléctrica para principiantes', 4, 'música clases guitarra aprender', 1500, NULL);
INSERT INTO public."Ofrecidos" VALUES (25, 3, 'Corte y peinado moderno para hombres y mujeres', 1, 'peluquería corte peinado moda', 2500, NULL);
INSERT INTO public."Ofrecidos" VALUES (26, 4, 'Diseño gráfico profesional para marcas y startups', 2, 'diseño gráfico branding startup', 5000, NULL);
INSERT INTO public."Ofrecidos" VALUES (27, 5, 'Masajes terapéuticos para aliviar dolores musculares', 1, 'masajes terapia salud bienestar', 2800, NULL);
INSERT INTO public."Ofrecidos" VALUES (28, 6, 'Asesoría contable y fiscal para pequeñas empresas', 2, 'asesoría contable fiscal empresa', 4000, NULL);
INSERT INTO public."Ofrecidos" VALUES (29, 7, 'Servicio de catering para eventos corporativos', 3, 'catering eventos corporativos comida', 7000, NULL);
INSERT INTO public."Ofrecidos" VALUES (30, 8, 'Entrenamiento personalizado en gimnasio o a domicilio', 4, 'entrenamiento fitness salud ejercicio', 3000, NULL);
INSERT INTO public."Ofrecidos" VALUES (31, 9, 'Reparación de sistemas de climatización residencial', 2, 'reparación climatización aire acondicionado', 6000, NULL);
INSERT INTO public."Ofrecidos" VALUES (32, 10, 'Consultoría en desarrollo web y optimización SEO', 2, 'desarrollo web consultoría SEO', 4500, NULL);
INSERT INTO public."Ofrecidos" VALUES (33, 11, 'Clases de idiomas (inglés, francés, italiano)', 4, 'clases idiomas aprender inglés francés italiano', 2000, NULL);
INSERT INTO public."Ofrecidos" VALUES (34, 12, 'Servicio de carpintería y muebles a medida', 3, 'carpintería muebles diseño madera', 5500, NULL);
INSERT INTO public."Ofrecidos" VALUES (35, 13, 'Terapia psicológica individual y de pareja', 1, 'terapia psicología individual pareja', 3200, NULL);
INSERT INTO public."Ofrecidos" VALUES (36, 14, 'Instalación de sistemas de seguridad para hogares', 2, 'seguridad instalación sistemas alarmas', 4800, NULL);
INSERT INTO public."Ofrecidos" VALUES (37, 15, 'Curso intensivo de fotografía profesional', 4, 'curso fotografía profesional aprendizaje', 3800, NULL);
INSERT INTO public."Ofrecidos" VALUES (38, 16, 'Reparación de electrodomésticos a domicilio', 3, 'reparación electrodomésticos servicio domicilio', 2700, NULL);
INSERT INTO public."Ofrecidos" VALUES (39, 17, 'Diseño de interiores y remodelación de espacios', 2, 'diseño interiores remodelación decoración', 6500, NULL);
INSERT INTO public."Ofrecidos" VALUES (40, 18, 'Servicio de consultoría en recursos humanos', 3, 'consultoría recursos humanos gestión personal', 4200, NULL);
INSERT INTO public."Ofrecidos" VALUES (41, 19, 'Clases de yoga y meditación para todos los niveles', 1, 'yoga clases meditación bienestar', 2300, NULL);
INSERT INTO public."Ofrecidos" VALUES (42, 20, 'Servicio de reparación de automóviles a domicilio', 2, 'reparación automóviles servicio domicilio', 5800, NULL);
INSERT INTO public."Ofrecidos" VALUES (43, 41, 'Servicio de limpieza a domicilio', 2, 'limpieza, hogar, mantenimiento', 50, NULL);


--
-- TOC entry 4888 (class 0 OID 16431)
-- Dependencies: 229
-- Data for Name: Usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Usuarios" VALUES (1, 'julieta@gmail.com', 'Juan', 'Gómez', 'Calle 123', 'clave123', 1, 'https://thispersondoesnotexist.com/', '1985-03-15');
INSERT INTO public."Usuarios" VALUES (2, 'maria.lopez@example.com', 'María', 'López', 'Avenida 456', 'password456', 2, 'https://thispersondoesnotexist.com/', '1988-07-22');
INSERT INTO public."Usuarios" VALUES (3, 'carlos.martinez@example.com', 'Carlos', 'Martínez', 'Plaza Principal', 'contraseña789', 3, 'https://thispersondoesnotexist.com/', '1990-11-10');
INSERT INTO public."Usuarios" VALUES (4, 'ana.rodriguez@example.com', 'Ana', 'Rodríguez', 'Calle 789', '123456', 4, 'https://thispersondoesnotexist.com/', '1983-09-05');
INSERT INTO public."Usuarios" VALUES (5, 'pedro.sanchez@example.com', 'Pedro', 'Sánchez', 'Avenida Central', 'abc123', 5, 'https://thispersondoesnotexist.com/', '1986-12-30');
INSERT INTO public."Usuarios" VALUES (6, 'laura.hernandez@example.com', 'Laura', 'Hernández', 'Calle 567', 'qwerty', 1, 'https://thispersondoesnotexist.com/', '1989-05-20');
INSERT INTO public."Usuarios" VALUES (7, 'roberto.diaz@example.com', 'Roberto', 'Díaz', 'Avenida 890', '123abc', 2, 'https://thispersondoesnotexist.com/', '1992-04-18');
INSERT INTO public."Usuarios" VALUES (8, 'sofia.martinez@example.com', 'Sofía', 'Martínez', 'Plaza del Sol', 'password123', 3, 'https://thispersondoesnotexist.com/', '1995-10-08');
INSERT INTO public."Usuarios" VALUES (9, 'diego.garcia@example.com', 'Diego', 'García', 'Calle Luna', 'abcd1234', 4, 'https://thispersondoesnotexist.com/', '1979-11-27');
INSERT INTO public."Usuarios" VALUES (10, 'ana.fernandez@example.com', 'Ana', 'Fernández', 'Avenida del Bosque', 'pass1234', 4, 'https://thispersondoesnotexist.com/', '1983-09-05');
INSERT INTO public."Usuarios" VALUES (11, 'daniel.gonzalez@example.com', 'Daniel', 'González', 'Calle 10', 'password', 5, 'https://thispersondoesnotexist.com/', '1987-02-14');
INSERT INTO public."Usuarios" VALUES (12, 'luisa.molina@example.com', 'Luisa', 'Molina', 'Avenida 20', 'clave', 1, 'https://thispersondoesnotexist.com/', '1993-08-03');
INSERT INTO public."Usuarios" VALUES (13, 'javier.perez@example.com', 'Javier', 'Pérez', 'Calle 30', 'contraseña', 2, 'https://thispersondoesnotexist.com/', '1984-06-25');
INSERT INTO public."Usuarios" VALUES (14, 'elena.ruiz@example.com', 'Elena', 'Ruiz', 'Avenida 40', '12345678', 3, 'https://thispersondoesnotexist.com/', '1998-09-12');
INSERT INTO public."Usuarios" VALUES (15, 'pablo.lopez@example.com', 'Pablo', 'López', 'Calle 50', 'abcdefgh', 4, 'https://thispersondoesnotexist.com/', '1991-03-08');
INSERT INTO public."Usuarios" VALUES (16, 'maiukuper@gmail.com', 'maia', 'kupersmid', 'Yatay 240', 'maiukuper123', 1, '', '2007-06-08');
INSERT INTO public."Usuarios" VALUES (20, 'ju@gmail.com', 'maia', 'kupersmid', 'Yatay 240', 'maiukuper123', 1, '', '2007-06-08');
INSERT INTO public."Usuarios" VALUES (21, 'carolina.gomez@gmail.com', 'Carolina', 'Gómez', 'Avenida Libertador 123', 'carolina123', 2, 'https://thispersondoesnotexist.com/', '1994-02-20');
INSERT INTO public."Usuarios" VALUES (22, 'martin.fernandez@gmail.com', 'Martín', 'Fernández', 'Calle Rosario 456', 'martin456', 1, 'https://thispersondoesnotexist.com/', '1997-09-15');
INSERT INTO public."Usuarios" VALUES (23, 'lucia.rodriguez@gmail.com', 'Lucía', 'Rodríguez', 'Plaza de Mayo 789', 'lucia789', 2, 'https://thispersondoesnotexist.com/', '1999-04-25');
INSERT INTO public."Usuarios" VALUES (24, 'felipe.gonzalez@gmail.com', 'Felipe', 'González', 'Avenida Corrientes 567', 'felipe567', 1, 'https://thispersondoesnotexist.com/', '1993-07-12');
INSERT INTO public."Usuarios" VALUES (25, 'valeria.diaz@gmail.com', 'Valeria', 'Díaz', 'Calle San Martín 890', 'valeria890', 2, 'https://thispersondoesnotexist.com/', '1996-11-28');
INSERT INTO public."Usuarios" VALUES (26, 'juan.perez@gmail.com', 'Juan', 'Pérez', 'Avenida Rivadavia 123', 'juan123', 1, 'https://thispersondoesnotexist.com/', '1990-03-08');
INSERT INTO public."Usuarios" VALUES (27, 'natalia.martinez@gmail.com', 'Natalia', 'Martínez', 'Calle Belgrano 456', 'natalia456', 2, 'https://thispersondoesnotexist.com/', '1987-06-17');
INSERT INTO public."Usuarios" VALUES (28, 'gabriel.sanchez@gmail.com', 'Gabriel', 'Sánchez', 'Avenida Independencia 789', 'gabriel789', 1, 'https://thispersondoesnotexist.com/', '1985-12-30');
INSERT INTO public."Usuarios" VALUES (29, 'mariana.lopez@gmail.com', 'Mariana', 'López', 'Plaza San Martín 567', 'mariana567', 2, 'https://thispersondoesnotexist.com/', '1982-09-05');
INSERT INTO public."Usuarios" VALUES (30, 'rodrigo.molina@gmail.com', 'Rodrigo', 'Molina', 'Calle Uruguay 123', 'rodrigo123', 1, 'https://thispersondoesnotexist.com/', '1991-11-15');
INSERT INTO public."Usuarios" VALUES (31, 'julieta.ruiz@gmail.com', 'Julieta', 'Ruiz', 'Avenida Entre Ríos 456', 'julieta456', 2, 'https://thispersondoesnotexist.com/', '1988-04-22');
INSERT INTO public."Usuarios" VALUES (32, 'lucas.gutierrez@gmail.com', 'Lucas', 'Gutiérrez', 'Calle Lavalle 789', 'lucas789', 1, 'https://thispersondoesnotexist.com/', '1995-07-18');
INSERT INTO public."Usuarios" VALUES (33, 'sofia.fernandez@gmail.com', 'Sofía', 'Fernández', 'Avenida Callao 567', 'sofia567', 2, 'https://thispersondoesnotexist.com/', '1993-12-10');
INSERT INTO public."Usuarios" VALUES (34, 'facundo.lopez@gmail.com', 'Facundo', 'López', 'Calle Paraguay 890', 'facundo890', 1, 'https://thispersondoesnotexist.com/', '1989-02-28');
INSERT INTO public."Usuarios" VALUES (35, 'camila.sosa@gmail.com', 'Camila', 'Sosa', 'Avenida Santa Fe 123', 'camila123', 2, 'https://thispersondoesnotexist.com/', '1997-05-05');
INSERT INTO public."Usuarios" VALUES (36, 'nicolas.gomez@gmail.com', 'Nicolás', 'Gómez', 'Calle Esmeralda 456', 'nicolas456', 1, 'https://thispersondoesnotexist.com/', '1986-08-14');
INSERT INTO public."Usuarios" VALUES (37, 'micaela.ortega@gmail.com', 'Micaela', 'Ortega', 'Plaza Congreso 789', 'micaela789', 2, 'https://thispersondoesnotexist.com/', '1990-10-25');
INSERT INTO public."Usuarios" VALUES (38, 'leonardo.suarez@gmail.com', 'Leonardo', 'Suárez', 'Avenida Belgrano 567', 'leonardo567', 1, 'https://thispersondoesnotexist.com/', '1984-03-03');
INSERT INTO public."Usuarios" VALUES (39, 'vale.rodriguez@gmail.com', 'Valentina', 'Rodríguez', 'Calle Florida 890', 'valentina890', 2, 'https://thispersondoesnotexist.com/', '1992-06-07');
INSERT INTO public."Usuarios" VALUES (40, 'juan.cabrera@gmail.com', 'Juan', 'Cabrera', 'Avenida Córdoba 123', 'juan123', 1, 'https://thispersondoesnotexist.com/', '1983-01-19');
INSERT INTO public."Usuarios" VALUES (41, 'maiakupersmid@gmail.com', 'maia', 'kupersmid', 'Yatay 240', 'maiukuper123', 1, '', '2007-06-08');
INSERT INTO public."Usuarios" VALUES (42, 'miledawi@gmail.com', 'Milena', 'Dawidowicz', 'Yatay 240', 'pipa', 1, 'si', '2007-03-07');
INSERT INTO public."Usuarios" VALUES (43, 'pipa@gmail.com', 'Milena', 'Dawidowicz', 'Yatay 240', 'pipa123', 1, 'si', '2007-03-07');
INSERT INTO public."Usuarios" VALUES (44, 'polshu@gmail.com', 'polshu', 'ppp', 'yatay240', 'polshu', 2, 'si', '2003-02-03');


--
-- TOC entry 4890 (class 0 OID 16435)
-- Dependencies: 231
-- Data for Name: ZonaOfrecidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."ZonaOfrecidos" VALUES (7, 4, 1);
INSERT INTO public."ZonaOfrecidos" VALUES (8, 2, 2);
INSERT INTO public."ZonaOfrecidos" VALUES (9, 3, 3);
INSERT INTO public."ZonaOfrecidos" VALUES (10, 3, 4);
INSERT INTO public."ZonaOfrecidos" VALUES (11, 3, 1);
INSERT INTO public."ZonaOfrecidos" VALUES (12, 4, 4);


--
-- TOC entry 4894 (class 0 OID 16441)
-- Dependencies: 235
-- Data for Name: Zonas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Zonas" VALUES (1, 'almagro');
INSERT INTO public."Zonas" VALUES (2, 'Palermo');
INSERT INTO public."Zonas" VALUES (3, 'Recoleta');
INSERT INTO public."Zonas" VALUES (4, 'Belgrano');
INSERT INTO public."Zonas" VALUES (5, 'San Telmo');
INSERT INTO public."Zonas" VALUES (6, 'La Boca');
INSERT INTO public."Zonas" VALUES (7, 'Puerto Madero');
INSERT INTO public."Zonas" VALUES (8, 'Caballito');
INSERT INTO public."Zonas" VALUES (9, 'Villa Crespo');
INSERT INTO public."Zonas" VALUES (10, 'Colegiales');
INSERT INTO public."Zonas" VALUES (11, 'Almagro');
INSERT INTO public."Zonas" VALUES (12, 'Villa Urquiza');
INSERT INTO public."Zonas" VALUES (13, 'Barracas');
INSERT INTO public."Zonas" VALUES (14, 'NuÃ±ez');
INSERT INTO public."Zonas" VALUES (15, 'Saavedra');
INSERT INTO public."Zonas" VALUES (16, 'Villa Devoto');
INSERT INTO public."Zonas" VALUES (17, 'Flores');
INSERT INTO public."Zonas" VALUES (18, 'Parque Chacabuco');
INSERT INTO public."Zonas" VALUES (19, 'Parque Patricios');
INSERT INTO public."Zonas" VALUES (20, 'Mataderos');
INSERT INTO public."Zonas" VALUES (21, 'Villa del Parque');
INSERT INTO public."Zonas" VALUES (22, 'Villa Lugano');
INSERT INTO public."Zonas" VALUES (23, 'Villa PueyrredÃ³n');
INSERT INTO public."Zonas" VALUES (24, 'Villa Luro');
INSERT INTO public."Zonas" VALUES (25, 'Villa Santa Rita');
INSERT INTO public."Zonas" VALUES (26, 'Parque Avellaneda');
INSERT INTO public."Zonas" VALUES (27, 'Villa General Mitre');
INSERT INTO public."Zonas" VALUES (28, 'Villa Real');
INSERT INTO public."Zonas" VALUES (29, 'Villa Riachuelo');
INSERT INTO public."Zonas" VALUES (30, 'Versalles');
INSERT INTO public."Zonas" VALUES (31, 'Monte Castro');


--
-- TOC entry 4896 (class 0 OID 16445)
-- Dependencies: 237
-- Data for Name: passwordresetcodes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4915 (class 0 OID 0)
-- Dependencies: 216
-- Name: Categorias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Categorias_id_seq"', 46, true);


--
-- TOC entry 4916 (class 0 OID 0)
-- Dependencies: 218
-- Name: Estados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Estados_id_seq"', 5, true);


--
-- TOC entry 4917 (class 0 OID 0)
-- Dependencies: 220
-- Name: Favoritos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Favoritos_id_seq"', 23, true);


--
-- TOC entry 4918 (class 0 OID 0)
-- Dependencies: 222
-- Name: FotosOfrecidos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."FotosOfrecidos_id_seq"', 113, true);


--
-- TOC entry 4919 (class 0 OID 0)
-- Dependencies: 224
-- Name: Generos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Generos_id_seq"', 5, true);


--
-- TOC entry 4920 (class 0 OID 0)
-- Dependencies: 226
-- Name: Historial_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Historial_id_seq"', 21, true);


--
-- TOC entry 4921 (class 0 OID 0)
-- Dependencies: 228
-- Name: Ofrecidos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Ofrecidos_id_seq"', 43, true);


--
-- TOC entry 4922 (class 0 OID 0)
-- Dependencies: 230
-- Name: Usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Usuarios_id_seq"', 44, true);


--
-- TOC entry 4923 (class 0 OID 0)
-- Dependencies: 232
-- Name: ZonaTrabajador_idTrabajador_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ZonaTrabajador_idTrabajador_seq"', 1, false);


--
-- TOC entry 4924 (class 0 OID 0)
-- Dependencies: 233
-- Name: ZonaTrabajador_idZona_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ZonaTrabajador_idZona_seq"', 1, false);


--
-- TOC entry 4925 (class 0 OID 0)
-- Dependencies: 234
-- Name: ZonaTrabajador_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ZonaTrabajador_id_seq"', 12, true);


--
-- TOC entry 4926 (class 0 OID 0)
-- Dependencies: 236
-- Name: Zonas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Zonas_id_seq"', 31, true);


--
-- TOC entry 4702 (class 2606 OID 16461)
-- Name: Categorias Categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Categorias"
    ADD CONSTRAINT "Categorias_pkey" PRIMARY KEY (id);


--
-- TOC entry 4704 (class 2606 OID 16463)
-- Name: Estados Estados_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estados"
    ADD CONSTRAINT "Estados_pkey" PRIMARY KEY (id);


--
-- TOC entry 4706 (class 2606 OID 16465)
-- Name: Favoritos Favoritos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Favoritos"
    ADD CONSTRAINT "Favoritos_pkey" PRIMARY KEY (id);


--
-- TOC entry 4708 (class 2606 OID 16467)
-- Name: FotosOfrecidos FotosOfrecidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FotosOfrecidos"
    ADD CONSTRAINT "FotosOfrecidos_pkey" PRIMARY KEY (id);


--
-- TOC entry 4710 (class 2606 OID 16469)
-- Name: Generos Generos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Generos"
    ADD CONSTRAINT "Generos_pkey" PRIMARY KEY (id);


--
-- TOC entry 4712 (class 2606 OID 16471)
-- Name: Historial Historial_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Historial"
    ADD CONSTRAINT "Historial_pkey" PRIMARY KEY (id);


--
-- TOC entry 4714 (class 2606 OID 16473)
-- Name: Ofrecidos Ofrecidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ofrecidos"
    ADD CONSTRAINT "Ofrecidos_pkey" PRIMARY KEY (id);


--
-- TOC entry 4716 (class 2606 OID 16475)
-- Name: Usuarios Usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuarios"
    ADD CONSTRAINT "Usuarios_pkey" PRIMARY KEY (id);


--
-- TOC entry 4718 (class 2606 OID 16477)
-- Name: ZonaOfrecidos ZonaOfrecidos _pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ZonaOfrecidos"
    ADD CONSTRAINT "ZonaOfrecidos _pkey" PRIMARY KEY (id);


--
-- TOC entry 4720 (class 2606 OID 16479)
-- Name: Zonas Zonas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Zonas"
    ADD CONSTRAINT "Zonas_pkey" PRIMARY KEY (id);


--
-- TOC entry 4722 (class 2606 OID 16481)
-- Name: passwordresetcodes passwordresetcodes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passwordresetcodes
    ADD CONSTRAINT passwordresetcodes_pkey PRIMARY KEY (email);


--
-- TOC entry 4725 (class 2606 OID 16482)
-- Name: FotosOfrecidos foto_idOfrecidos; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FotosOfrecidos"
    ADD CONSTRAINT "foto_idOfrecidos" FOREIGN KEY ("idOfrecido") REFERENCES public."Ofrecidos"(id) NOT VALID;


--
-- TOC entry 4726 (class 2606 OID 16487)
-- Name: Historial idCont_idUsario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Historial"
    ADD CONSTRAINT "idCont_idUsario" FOREIGN KEY ("idContratador") REFERENCES public."Usuarios"(id) NOT VALID;


--
-- TOC entry 4727 (class 2606 OID 16492)
-- Name: Historial idEst-idEstado; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Historial"
    ADD CONSTRAINT "idEst-idEstado" FOREIGN KEY ("idEstado") REFERENCES public."Estados"(id) NOT VALID;


--
-- TOC entry 4723 (class 2606 OID 16497)
-- Name: Favoritos idOfre_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Favoritos"
    ADD CONSTRAINT "idOfre_usuario" FOREIGN KEY ("idOfrecido") REFERENCES public."Usuarios"(id) NOT VALID;


--
-- TOC entry 4728 (class 2606 OID 16502)
-- Name: Historial idProv_idUsuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Historial"
    ADD CONSTRAINT "idProv_idUsuario" FOREIGN KEY ("idOffer") REFERENCES public."Usuarios"(id) NOT VALID;


--
-- TOC entry 4724 (class 2606 OID 16507)
-- Name: Favoritos idUs_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Favoritos"
    ADD CONSTRAINT "idUs_usuario" FOREIGN KEY ("idUsuario") REFERENCES public."Usuarios"(id) NOT VALID;


--
-- TOC entry 4729 (class 2606 OID 16512)
-- Name: ZonaOfrecidos idUsuarios_usuariosId; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ZonaOfrecidos"
    ADD CONSTRAINT "idUsuarios_usuariosId" FOREIGN KEY ("idUsuario") REFERENCES public."Usuarios"(id) NOT VALID;


--
-- TOC entry 4730 (class 2606 OID 16517)
-- Name: ZonaOfrecidos idZonas_zonasId; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ZonaOfrecidos"
    ADD CONSTRAINT "idZonas_zonasId" FOREIGN KEY ("idZona") REFERENCES public."Zonas"(id) NOT VALID;


-- Completed on 2024-11-01 12:14:33

--
-- PostgreSQL database dump complete
--

