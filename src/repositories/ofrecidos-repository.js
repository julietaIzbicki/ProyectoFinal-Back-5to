import DBConfig from "../configs/db-config.js";
import pkg from "pg";
const { Client, Pool } = pkg;

export default class OfrecidosRepository {
  getByFilter = async (filters) => {
    let returnEntity = null;
    const client = new Client(DBConfig);
    const values = [];
    let i = 1;
    await client.connect();
    let miQuery = `SELECT 
        public."Ofrecidos"."id",
        public."Ofrecidos"."idusuario",
        public."Ofrecidos"."titulo",
        public."Ofrecidos"."descripcion",
        public."Ofrecidos"."precio",
        public."FotosOfrecidos"."foto",
        COALESCE(AVG(public."Historial"."calificacionProveedor"), 0) AS promedio_calificacion
            FROM public."Ofrecidos"
            LEFT JOIN public."FotosOfrecidos" ON public."FotosOfrecidos"."idOfrecido" = public."Ofrecidos"."id"
            LEFT JOIN public."Historial" ON public."Historial"."idProveedor" = public."Ofrecidos"."idusuario"
            LEFT JOIN public."ZonaOfrecidos" ON public."ZonaOfrecidos"."idUsuario" = public."Ofrecidos"."idusuario"
            LEFT JOIN public."Zonas" ON public."Zonas"."id" = public."ZonaOfrecidos"."idZona"
            LEFT JOIN public."Categorias" ON public."Categorias"."id" = public."Ofrecidos"."idcategoria"
        WHERE 1=1 `;
    if (filters.ubicacion != null) {
      miQuery += `AND lower("Zonas"."nombre") like lower($${i}) `;
      values.push("%" + filters.ubicacion + "%");
      i++;
    }
    if (filters.precio != null) {
      miQuery += `AND "Ofrecidos"."precio" <= ($${i}) `;
      values.push(filters.precio);
      i++;
    }
    if (filters.categoria != null) {
      miQuery += `AND lower("Categorias"."nombre") like lower($${i}) `;
      values.push("%" + filters.categoria + "%");
      i++;
    }
    miQuery += `
    GROUP BY 
    public."Ofrecidos"."id",
            public."Ofrecidos"."descripcion",
            public."Ofrecidos"."precio",
            public."FotosOfrecidos"."foto",
            public."Zonas"."nombre",
            public."Historial"."id"
    ORDER BY 1=1
    `;
    if (filters.mayorPromedio != null) {
      miQuery += `, promedio_calificacion DESC`;
    }
    if (filters.MayorPrecio != null) {
      miQuery += `, public."Ofrecidos"."precio" DESC`;
    }
    if (filters.MenorPrecio != null) {
      miQuery += `, public."Ofrecidos"."precio" ASC`;
    }
    try {
      const sql = miQuery;
      const result = await client.query(sql, values);
      await client.end();
      returnEntity = result.rows;
    } catch (error) {
      console.log(error);
      returnEntity = false;
    }
    return returnEntity;
  };

  createOfrecido = async (ofrecido) => {
    const client = new Client(DBConfig);
    const values = [
      ofrecido.descripcion,
      ofrecido.precio,
      ofrecido.idusuario,
      ofrecido.idcategoria,
      ofrecido.tags,
    ];
    const sql = `
            INSERT INTO public."Ofrecidos" (
                "descripcion", "precio", "idusuario", "idcategoria", "tags"
            ) VALUES ($1, $2, $3, $4, $5) RETURNING id
        `;
    try {
      await client.connect();
      const result = await client.query(sql, values);
      await client.end();
      return result.rows[0].id;
    } catch (error) {
      console.log("Error al insertar el ofrecido:", error);
      return false;
    }
  };
}