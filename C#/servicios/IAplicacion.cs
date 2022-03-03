using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TecnicaturaBackend.Dominio;

namespace TecnicaturaBackend.Servicios
{
    public interface IAplicacion
    {
        public List<Consulta1> ObtenerEdades(int nro);
        public List<Consulta1> Consulta(int nroConsulta);
        public List<Consulta1> GetAnios(int anio);
        public List<Consulta1> GetCarrera(string carrera);
    }
}
