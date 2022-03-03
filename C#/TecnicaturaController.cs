using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TecnicaturaBackend.Acceso_a_Datos;
using TecnicaturaBackend.Servicios;

namespace TecnicaturaWebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TecnicaturaController : ControllerBase
    {

        private IAplicacion app;

        public TecnicaturaController()
        {
            app = new ApplicationFactory().CrearAplicacion(new DaoFactory());
        }
        // ----------------------------------------------------------------------------
        [HttpGet("consulta/{nroConsulta}")]
        public IActionResult Get(int nroConsulta)
        {
            return Ok(app.Consulta(nroConsulta));
        }
        // ----------------------------------------------------------------------------
        [HttpGet("consultaNro/{nro}")]
        public IActionResult GetEdades(int nro)
        {
            if (nro <= 0)
                return BadRequest("Edad Mayor a 0");
            return Ok(app.ObtenerEdades(nro));
        }
        // ----------------------------------------------------------------------------
        [HttpGet("anios/{anio}")]
        public IActionResult GetAnio(int anio)
        {
            if (anio <= 0)
                return BadRequest("Año a 0");
            return Ok(app.GetAnios(anio));
        }
        // ----------------------------------------------------------------------------
        [HttpGet("carreras/{carrera}")]
        public IActionResult GetCarrera(string carrera)
        {
            if (String.IsNullOrEmpty(carrera))
                return BadRequest("Carrera nula o vacia");
            return Ok(app.GetCarrera(carrera));
        }
    }
}
