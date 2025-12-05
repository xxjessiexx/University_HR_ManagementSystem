using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace UNI
{
    using System;
    using System.Configuration;
    using System.Data;
    using System.Data.SqlClient;
    using System.Text;

    public partial class Employees_Details : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["GUCera"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM allEmployeeProfiles", conn);
                    conn.Open();
                    gvEmployees.DataSource = cmd.ExecuteReader();
                    gvEmployees.DataBind();
                }
            }
        }
    }
