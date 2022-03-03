using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TecnicaturaBackend.Acceso_a_Datos;
using TecnicaturaBackend.Dominio;

namespace TecnicaturaBackend.Servicios
{
    public class Aplicacion : IAplicacion
    {
        private IDao dao;

        public Aplicacion(AbstractDaoFactory factory)
        {
            dao = factory.CrearTecnicaturaDao();
        }

        // ----------------------------------------------------------------------------
        public List<Consulta1> ObtenerEdades(int nro)
        {
            return dao.GetByNro(nro);
        }
        // ----------------------------------------------------------------------------
        public List<Consulta1> Consulta(int nroConsulta)
        {
            return dao.Get(nroConsulta);
        }
        // ----------------------------------------------------------------------------
        public List<Consulta1> GetAnios(int anio)
        {
            return dao.GetAnios(anio);
        }
        // ----------------------------------------------------------------------------
        public List<Consulta1> GetCarrera(string carrera)
        {
            return dao.GetCarreras(carrera);
        }
    }
}
