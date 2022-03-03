using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TecnicaturaBackend.Acceso_a_Datos
{
    class HelperDao
    {
        private static HelperDao instancia;
        private string cadenaConexion;

        private SqlConnection cnn = null;
        private SqlCommand cmd = null;
        private DataTable tabla = null;
        private SqlTransaction trans = null;
        private SqlDataReader reader = null;

        private HelperDao()
        {
            cadenaConexion = @"Data Source=LAPTOP-JAVI\SQLEXPRESS;Initial Catalog=Tecnicatura;Integrated Security=True";
        }

        public static HelperDao ObtenerInstancia()
        {
            if (instancia == null)
            {
                instancia = new HelperDao();
            }
            return instancia;
        }

        //Métodos de Acceso a Datos
        //-------------------------------------------------------------------------------------------
        public DataTable SelectByNro(string storeName, int nro)
        {
            DataTable tabla = new DataTable();
            cnn = new SqlConnection(cadenaConexion);
            cmd = new SqlCommand();
            try
            {
                cnn.Open();
                cmd = new SqlCommand(storeName, cnn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@edadMin", nro);


                tabla.Load(cmd.ExecuteReader());
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (cnn != null && cnn.State == ConnectionState.Open)
                    cnn.Close();
            }
            return tabla;
        }
        //-------------------------------------------------------------------------------------------
        public DataTable Select(string storeName)
        {
            DataTable tabla = new DataTable();
            cnn = new SqlConnection(cadenaConexion);
            cmd = new SqlCommand();
            try
            {
                cnn.Open();
                cmd = new SqlCommand("SELECT * FROM " + storeName, cnn);
                cmd.CommandType = CommandType.Text;


                tabla.Load(cmd.ExecuteReader());
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (cnn != null && cnn.State == ConnectionState.Open)
                    cnn.Close();
            }
            return tabla;
        }
        //-------------------------------------------------------------------------------------------
        public DataTable SelectSP(string storeName)
        {
            DataTable tabla = new DataTable();
            cnn = new SqlConnection(cadenaConexion);
            cmd = new SqlCommand();
            try
            {
                cnn.Open();
                cmd = new SqlCommand(storeName, cnn);
                cmd.CommandType = CommandType.StoredProcedure;


                tabla.Load(cmd.ExecuteReader());
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (cnn != null && cnn.State == ConnectionState.Open)
                    cnn.Close();
            }
            return tabla;
        }
        //-------------------------------------------------------------------------------------------
        public DataTable Post(string storeName, int anio)
        {
            DataTable tabla = new DataTable();
            cnn = new SqlConnection(cadenaConexion);
            cmd = new SqlCommand();
            try
            {
                cnn.Open();
                cmd = new SqlCommand(storeName, cnn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@AÑO", anio);


                tabla.Load(cmd.ExecuteReader());
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (cnn != null && cnn.State == ConnectionState.Open)
                    cnn.Close();
            }
            return tabla;
        }
        //-------------------------------------------------------------------------------------------
        public DataTable GetCarreras(string storeName, string carrera)
        {
            DataTable tabla = new DataTable();
            cnn = new SqlConnection(cadenaConexion);
            cmd = new SqlCommand();
            try
            {
                cnn.Open();
                cmd = new SqlCommand(storeName, cnn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@carrera", carrera);


                tabla.Load(cmd.ExecuteReader());
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (cnn != null && cnn.State == ConnectionState.Open)
                    cnn.Close();
            }
            return tabla;
        }
    }
}
