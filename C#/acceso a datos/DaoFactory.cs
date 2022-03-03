using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TecnicaturaBackend.Acceso_a_Datos
{
    public class DaoFactory : AbstractDaoFactory
    {
        public override IDao CrearTecnicaturaDao()
        {
            return new TecnicaturaDao();
        }
    }
}
