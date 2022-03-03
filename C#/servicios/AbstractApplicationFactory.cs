using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TecnicaturaBackend.Acceso_a_Datos;

namespace TecnicaturaBackend.Servicios
{
    public abstract class AbstractApplicationFactory
    {
        public abstract IAplicacion CrearAplicacion(AbstractDaoFactory factory);
    }
}
