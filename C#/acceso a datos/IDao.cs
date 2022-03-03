using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TecnicaturaBackend.Dominio;

namespace TecnicaturaBackend.Acceso_a_Datos
{
    public interface IDao
    {
        public List<Consulta1> GetByNro(int nro);
        public List<Consulta1> Get(int nroConsulta);
        public List<Consulta1> GetAnios(int anio);
        public List<Consulta1> GetCarreras(string carrera);
    }
}
