using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TecnicaturaBackend.Acceso_a_Datos
{
    public abstract class AbstractDaoFactory
    {
        public abstract IDao CrearTecnicaturaDao();
    }
}

