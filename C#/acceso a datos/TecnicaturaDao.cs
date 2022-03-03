using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TecnicaturaBackend.Dominio;

namespace TecnicaturaBackend.Acceso_a_Datos
{
    class TecnicaturaDao : IDao
    {
        //-------------------------------------------------------------------------------------------
        public List<Consulta1> GetByNro(int nro)
        {
            List<Consulta1> lst = new List<Consulta1>();

            DataTable t = HelperDao.ObtenerInstancia().SelectByNro("consulta1", nro);

            foreach (DataRow row in t.Rows)
            {
                Consulta1 pConsulta = new Consulta1();
                pConsulta.valorInt1 = Convert.ToInt32(row["edad"].ToString());
                pConsulta.valorString1 = row["estado_alumno"].ToString();
                pConsulta.valorInt2 = Convert.ToInt32(row["cantidad_total_alumnos"].ToString());

                lst.Add(pConsulta);
            }
            return lst;
        }
        //-------------------------------------------------------------------------------------------
        public List<Consulta1> Get(int nroConsulta)
        {
            List<Consulta1> lst = new List<Consulta1>();

            if (nroConsulta == 3)
            {
                DataTable t = HelperDao.ObtenerInstancia().Select("dbo.consulta3()");

                foreach (DataRow row in t.Rows)
                {
                    Consulta1 pConsulta = new Consulta1();
                    pConsulta.valorInt1 = Convert.ToInt32(row["Cantidad de Alumnos que no rindieron ninguna materia"].ToString());

                    lst.Add(pConsulta);
                }
            }
            else if (nroConsulta == 5)
            {
                DataTable t = HelperDao.ObtenerInstancia().SelectSP("SP_consulta5");

                foreach (DataRow row in t.Rows)
                {
                    Consulta1 pConsulta = new Consulta1();
                    pConsulta.valorInt1 = Convert.ToInt32(row["Legajo"].ToString());
                    pConsulta.valorString1 = row["Alumno"].ToString();
                    pConsulta.valorInt2 = Convert.ToInt32(row["Nota en Final"].ToString());

                    lst.Add(pConsulta);
                }
            }
            return lst;
        }
        //-------------------------------------------------------------------------------------------
        public List<Consulta1> GetAnios(int anio)
        {
            List<Consulta1> lst = new List<Consulta1>();

            DataTable t = HelperDao.ObtenerInstancia().Post("SP_consulta7", anio);

            foreach (DataRow row in t.Rows)
            {
                Consulta1 pConsulta = new Consulta1();
                pConsulta.valorString1 = row["ALUMNO"].ToString();
                pConsulta.valorString2 = row["SIT. HAB."].ToString();
                pConsulta.valorInt1 = Convert.ToInt32(row["Cant. Aprobadas"].ToString());
                pConsulta.valorInt2 = Convert.ToInt32(row["Promedio Grl."].ToString());

                lst.Add(pConsulta);
            }
            return lst;
        }
        //-------------------------------------------------------------------------------------------
        public List<Consulta1> GetCarreras(string carrera)
        {
            List<Consulta1> lst = new List<Consulta1>();

            DataTable t = HelperDao.ObtenerInstancia().GetCarreras("SP_consulta8", carrera);

            foreach (DataRow row in t.Rows)
            {
                Consulta1 pConsulta = new Consulta1();
                pConsulta.valorString1 = row["NOMBRE"].ToString();
                pConsulta.valorInt1 = Convert.ToInt32(row["LEGAJO"].ToString());

                lst.Add(pConsulta);
            }
            return lst;
        }
    }
}
