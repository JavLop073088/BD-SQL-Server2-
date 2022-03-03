using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TecnicaturaBackend.Acceso_a_Datos;

namespace TecnicaturaBackend.Servicios
{
    public class ApplicationFactory : AbstractApplicationFactory
    {
        public override IAplicacion CrearAplicacion(AbstractDaoFactory factory)
        {
            return new Aplicacion(factory);
        }
    }
}
